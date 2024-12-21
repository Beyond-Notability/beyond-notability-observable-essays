#########################
## network functions ####
#########################

library(tidygraph)

# create an undirected tbl_graph using person id as node id ####
# n = nodes list, e = edges list. need to be in the right sort of format! 
bn_tbl_graph <- function(n, e){
  tbl_graph(
    nodes= n,
    edges= e,
    directed = FALSE,
    node_key = "person"
  )
}




## new function to dedup repeated pairs after doing joins
make_edge_ids <- function(data){
  data |>
  # make std edge1-edge2 ordering numerically. (don't really need names? that's nodes metadata too really)
  mutate(across(c(from, to), ~str_remove(., "Q"), .names="{.col}_n")) |>
  mutate(across(c(from_n, to_n), parse_number)) |>
  # standard from_to id according to which is lower number, for deduping repeated pairs
  mutate(edge_id = case_when(
    from_n<to_n ~ glue("{from}_{to}"),
    to_n<from_n ~ glue("{to}_{from}")
  )) |>
  mutate(edge1 = case_when(
    from_n<to_n ~ from,
    to_n<from_n ~ to
  )) |>
  mutate(edge2 = case_when(
    from_n<to_n ~ to,
    to_n<from_n ~ from
  )) |>
  select(-from_n, -to_n)
}




# network has to be a tbl_graph
# must have weight col, even if all the weights are 1.
# centrality scores: degree, betweenness, [closeness], harmony, eigenvector. 
bn_centrality <- function(network){
  network |>
    # tidygraph fixes renumbering for you... but keep bn ids anyway.
  filter(!node_is_isolated()) |>
  # just two centrality measures this time.
    mutate(degree = centrality_degree(weights=weight),
           betweenness = centrality_betweenness(weights=weight) # number of shortest paths going through a node
    )  |>
    # make rankings. invert ranks so top=largest.
    mutate(across(c(degree, betweenness),  ~min_rank(desc(.)), .names = "{.col}_rank"))  
}



# community detection
# doing unweighted; seemed to work better for events?
# run this *after* centrality function otherwise you might need isolated filter

bn_clusters <- function(network){
  network |>
    #mutate(grp_edge_btwn = as.factor(group_edge_betweenness(directed=FALSE))) |> # v v slow for SAL but ok for events.
    mutate(grp_infomap = as.factor(group_infomap())) |>  
    mutate(grp_leading_eigen = as.factor(group_leading_eigen())) 
    #mutate(grp_louvain = as.factor(group_louvain()))  |>
    #mutate(grp_walktrap = as.factor(group_walktrap())) 
}





###########################
## metadata for people ####
###########################

# this should be the tidied up version...
## don't really need gender because both networks are women only, but part of pipeline for other networks. keep it but just get women.

# list of all the named people (not just women) with gender  
bn_gender_sparql <-
  'SELECT DISTINCT ?person ?personLabel 
WHERE {  
  ?person bnwdt:P3 bnwd:Q3 .
  FILTER NOT EXISTS {?person bnwdt:P4 bnwd:Q12 .} #filter out project team 
  SERVICE wikibase:label {bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en-gb,en".}
}
order by ?personLabel'

bn_gender_query <-
  bn_std_query(bn_gender_sparql) |>
  make_bn_ids(person) 

bn_gender <-
  bn_gender_query |>
  rename(name = personLabel)



# dates

## this is not the all-the-dates query (but it could be)
bn_dates_sparql <-
'SELECT distinct ?person (year(?dod) as ?year_death) (year(?dob) as ?year_birth) ?s
  WHERE {
   ?person bnwdt:P12 bnwd:Q2137 . #humans
   FILTER NOT EXISTS { ?person bnwdt:P4 bnwd:Q12 . } # not project team
   
  optional { ?person bnwdt:P15 ?dod .   }
  optional { ?person bnwdt:P26 ?dob .   }
    
} # /where
ORDER BY ?person ?date'

bn_dates_query <-
  bn_std_query(bn_dates_sparql) |>
  make_bn_ids(c(person, s))  


# there is still the occasional dup on year i think
bn_birth_dates <-
bn_dates_query |>
  filter(!is.na(year_birth)) |> 
  distinct(person, year_birth) |>
  group_by(person) |>
  arrange(year_birth, .by_group = T) |>
  top_n(-1, row_number()) |>
  ungroup() 

# dod seems fine on year, but don't assume it'll stay that way
bn_death_dates <-
bn_dates_query |>
  filter(!is.na(year_death)) |>
  distinct(person, year_death)|>
  group_by(person) |>
  arrange(year_death, .by_group = T) |>
  top_n(-1, row_number()) |>
  ungroup() 



bn_person_list <-
bn_gender |>
  left_join(bn_birth_dates, by="person") |>
  left_join(bn_death_dates, by="person") 





###########################
#### setting up events ####
###########################

## some of this may not really be needed here... but I can't face going through it all again to find out what/if I could simplify.

# organised by (P109): union query for linked event pages or in quals, excluding human organisers. atm all are items.
# slightly trimmed version to speed up query as you don't need claim . don't even really need ?person.

bn_organised_by_sparql <-
'SELECT distinct 
?s ?organised_by ?organised_byLabel 
#?person ?prop ?ev 

WHERE {  
  ?person bnwdt:P3 bnwd:Q3 .
  ?person ( bnp:P71 | bnp:P24 | bnp:P72 | bnp:P23 | bnp:P13 | bnp:P120  ) ?s . # | bnp:P113
    ?s ( bnps:P71 | bnps:P24 | bnps:P72 | bnps:P23 | bnps:P13 | bnps:P120  ) ?ev .  # | bnps:P113
   
  # ?person ?p ?s .
  #     ?prop wikibase:claim ?p;      
  #        wikibase:statementProperty ?ps.  

  # organised by  .
  {
    # in linked event page
   ?ev bnwdt:P109 ?organised_by .  
  }
  union
  {
    # in qualifier
     ?s bnpq:P109 ?organised_by . 
    }
  
  # exclude human organisers... P12 Q2137
       filter not exists { ?organised_by bnwdt:P12 bnwd:Q2137 . }
        
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en,en-gb". } 
}'


bn_organised_by_query <-
  bn_std_query(bn_organised_by_sparql) |>
  #make_bn_item_id(person) |>
  make_bn_ids(c(organised_by, s)) 


bn_women_events_sparql <-
  'SELECT distinct ?person ?personLabel ?propLabel ?ppaLabel  ?qual_propLabel ?qual_valueLabel ?qual_value ?prop ?ppa ?qual_prop
?s

WHERE {  
  ?person bnwdt:P3 bnwd:Q3 .
  ?person ( bnp:P71 | bnp:P24 | bnp:P72 | bnp:P23 | bnp:P13 | bnp:P120  ) ?s . # | bnp:P113
    ?s ( bnps:P71 | bnps:P24 | bnps:P72 | bnps:P23 | bnps:P13 | bnps:P120  ) ?ppa .  # | bnps:P113
   
  ?person ?p ?s .
      ?prop wikibase:claim ?p.      
          
  # qualifiers
   optional { 
     ?s ( bnpq:P78|bnpq:P66 | bnpq:P2	 ) ?qual_value . # limit to the qualifiers youre actually using
     ?s ?qual_p ?qual_value .   
     ?qual_prop wikibase:qualifier ?qual_p . 
    }
        
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en,en-gb". } 
}

order by ?personLabel '


bn_events_fetched <-
  bn_std_query(bn_women_events_sparql)
  

# process the data a bit
bn_women_events_query <-
  bn_events_fetched |>
  make_bn_item_id(person) |>
  make_bn_ids(c(ppa, s, qual_value, prop, qual_prop)) |>
  mutate(across(c(qual_value, qual_valueLabel, qual_prop, qual_propLabel), ~na_if(., ""))) |>
  relocate(person, .after = last_col()) |>
  arrange(bn_id, s)



#  main only
# bn_women_ppa_events <-
bn_women_events <-
bn_women_events_query |>
  distinct(bn_id, personLabel, propLabel, ppaLabel, prop, ppa, s) |>
  left_join(bn_women_dob_dod |> select(bn_id, yob=bn_dob_yr, dob=bn_dob), by="bn_id") |>
  left_join(bn_organised_by_query |> 
              # just in case you get another with multiple organisers
              group_by(s) |>
              top_n(1, row_number()) |>
              ungroup() |>
              select(s, organised_by, organised_byLabel), by="s") |>
  #renaming to match original
  rename(event=ppaLabel, event_id=ppa) |>
  rename(ppa=prop, ppa_label=propLabel) |>
  relocate(ppa, .after = ppa_label) |>
  relocate(s, .after = last_col())


# bn_women_ppa_events_qualifiers <-
bn_women_events_qualifiers <-
bn_women_events_query |>
  #renaming to match original
  rename(event=ppaLabel, event_id=ppa) |>
  rename(ppa=prop, ppa_label=propLabel) |>
  rename(qual_label = qual_propLabel, qual_p=qual_prop) |>
  relocate(ppa, .after = ppa_label) |>
  relocate(event_id, .after = event)


# get instance of for qualifiers
# i think it's better to get them separately esp as there are multis etc
# problems adapting the query for events only... just get all for ppa for now and get moving
# it's not that slow; maybe come back to it
# but i think you may need to work it out so you can narrow down? for now do a semi join afterwards

bn_women_ppa_qual_inst_sparql <-
  'SELECT distinct ?person ?ppa ?qual ?qual_instance ?qual_instanceLabel  ?s
WHERE {  
  ?person bnwdt:P3 bnwd:Q3 .
  ?person ?p ?s .  
 
      ?ppa wikibase:claim ?p;      
         wikibase:statementProperty ?ps.       
      ?ppa bnwdt:P12 bnwd:Q151 . # i/o ppa      
 
      # get stuff about ?s 
      ?s ?ps ?qual.
  
      # get instance of for qual
        ?qual bnwdt:P12 ?qual_instance .

  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en,en-gb". } 
}
order by ?s'

bn_women_ppa_qual_inst_query <-
  bn_std_query(bn_women_ppa_qual_inst_sparql) |>
  make_bn_item_id(person) |>
  make_bn_ids(c(ppa, qual, qual_instance, s)) |>
  select(-person) |>
  semi_join(bn_women_events, by="s")


## fetching date prop labels makes the query a *lot* slower, so get R to turn the prop IDs into labels instead.

bn_women_events_time_precision_sparql <-
'SELECT distinct ?person ?date ?date_precision ?pq ?pqv  ?s  ?ppa   

WHERE {  
  ?person bnwdt:P3 bnwd:Q3 .
  ?person ( bnp:P71 | bnp:P24 | bnp:P72 | bnp:P23 | bnp:P13 | bnp:P120  ) ?s .  # | bnp:P113
    ?s ( bnps:P71 | bnps:P24 | bnps:P72 | bnps:P23 | bnps:P13 | bnps:P120  ) ?ppa .  # | bnps:P113
   
  # dont need any of this
  # ?person ?p ?s .
  #     ?prop wikibase:claim ?p;
  #        wikibase:statementProperty ?ps.      

  # qualifier timevalue and precision.
      ?s (bnpqv:P1 | bnpqv:P27 | bnpqv:P28 ) ?pqv.
      ?s ?pq ?pqv .
          ?pqv wikibase:timeValue ?date .  
          ?pqv wikibase:timePrecision ?date_precision .  
  
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en,en-gb". } 
}
'



bn_events_time_precision_fetched <-
  bn_std_query(bn_women_events_time_precision_sparql)


bn_women_events_time_precision_query <-
  bn_events_time_precision_fetched |>
  make_bn_item_id(person) |>
  make_bn_ids(c(ppa, pq, pqv, s)) |>
  make_date_year() |>
  mutate(date_propLabel = case_when(
    pq=="P1" ~ "point in time",
    pq=="P27" ~ "start time",
    pq=="P28" ~ "end time"
  )) |>
  rename(date_prop=pq) |>
  select(-person)


bn_women_events_dates <-
  bn_women_events_time_precision_query |>
  # need to keep date as well as the precision when you pivot, to join. c() in values_from
  # start/end pivot to a single row
  filter(date_prop %in% c("P27", "P28")) |>
  pivot_wider(names_from = date_propLabel, values_from = c(date_precision, date), id_cols = s) |>
  clean_names("snake") |>
  rename(start_precision=date_precision_start_time, end_precision = date_precision_end_time) |>
  # then add p.i.t.
  bind_rows(
    bn_women_events_time_precision_query |>
      filter(date_prop %in% c("P1")) |>
      select(s, pit_precision=date_precision, date)
  ) |> 
  mutate(date = case_when(
    !is.na(date) ~ date,
    !is.na(date_start_time) ~ date_start_time
  )) |>
  mutate(date_precision = case_when(
    !is.na(pit_precision) ~ pit_precision,
    !is.na(start_precision) ~ start_precision
  )) |>
  mutate(year = year(date)) |>
  # drop extra stuff; you can always get it back if you need it right.
  select(s, date, date_precision, year)


# add a new step before of_dates for doing of_org combination
bn_women_events_of <-
bn_women_events |> 
  left_join(bn_women_events_qualifiers |>
              # of (item/free text)
              filter(qual_p %in% c("P78", "P66")) |>
              anti_join(bn_women_events |> filter(event_id=="Q3644"), by="s") |> # exclude CAS AGM of 
              distinct(s, qual_p, qual_label, qual_value, qual_valueLabel) |>
              # ensure you have only 1 per stmt. these are all spoke_at; are they the ones with multiple papers?
              group_by(s) |>
              top_n(1, row_number()) |>
              ungroup() |>
              rename(of_label=qual_label, of=qual_p, of_id=qual_value, of_value=qual_valueLabel) 
              , by="s") |>
  # prefer of if you have both
  # i think organised_by is Items only, but use the id here just in case
  mutate(of_org = case_when(
    !is.na(of_value) ~ of_value,
    !is.na(organised_by) ~ organised_byLabel
  )) |>
  mutate(of_org_id = case_when(
    !is.na(of_id) ~ of_id,
    !is.na(organised_by) ~ organised_by
  )) 


# had manytomany warning. caused by multiple orgs in of. top_n as a quick hack to get rid. there are only a handful.
bn_women_events_of_dates <-
  bn_women_events_of |>
  left_join(bn_women_events_dates, by="s")  |>
  relocate(s, .after = last_col())



bn_women_events_of_dates_types_all <-
bn_women_events_of_dates |>
  # add i/o that are generic event types meeting/conference/exhibition - shouldn't dup... if it does will need to turn this into a separate step
  left_join(
    bn_women_ppa_qual_inst_query |>
      filter(qual_instanceLabel %in% c("meeting", "conference", "exhibition")) |>
      distinct(qual, qual_instance, qual_instanceLabel) |>
      rename(instance_id=qual_instance, instance=qual_instanceLabel), by=c("event_id"="qual")
  ) |>
  # add directly available locations
  left_join(
    bn_women_events_qualifiers |>
      filter(qual_label=="location") |>
      group_by(s) |>
      top_n(1, row_number()) |>
      ungroup() |>
      select(s, qual_location=qual_valueLabel, qual_location_value=qual_value)
  , by="s") |>
  
  # consolidate ppa_label item/text. currently only for delegate
  mutate(ppa_type = case_when(
    str_detect(ppa_label, "was delegate") ~ "was delegate at",
    .default = ppa_label
  )) |>
  relocate(ppa_type, .after = ppa)  |>
  # make event type. tweak for F.S.
  mutate(event_type = case_when(
    event %in% c("meeting", "exhibition", "conference") ~ event,
    event_id=="Q292" & is.na(of_org) ~ "meeting",  # folklore society not specified as meetings, but they almost certainly are
    #event_id=="Q682" ~ "conference", # Annual Meeting as conference? - to work this has to go before instance
    instance %in% c("meeting", "exhibition", "conference") ~ instance,
    event %in% c("committee", "museum") ~ "other",
    str_detect(event, "Meeting|Congress of the Congress of Archaeological Societies") ~ "meeting",
    str_detect(event, "Conference|Congress") | str_detect(of_org, "Conference|Congress") ~ "conference",
    #str_detect(instance2, "society|organisation|museum|institution|library") ~ "other",
    str_detect(of_org, "Society|Museum|Library|Institut|Association|School|College|Academy|University|Club|Gallery|Committee") | str_detect(event, "Society|Museum|Museo|Library|Institut|Association|School|College|Academy|University|Club|Gallery|Committee") ~ "other",
    .default = "misc"
  )) |>
  
    mutate(event_org = case_when(
    !is.na(of_org) ~ of_org,
    event_id=="Q292" & is.na(of_org) ~ event,
    event_type=="other" ~ event,
    str_detect(event, "Royal Archaeological Institute|\\bRAI\\b") ~ "Royal Archaeological Institute", 
    str_detect(event, "Society of Antiquaries of London|\\bSAL\\b") ~ "Society of Antiquaries of London",
    str_detect(event, "Congress of Archaeological Societies|\\bCAS\\b") ~ "Congress of Archaeological Societies",
    str_detect(event, "Royal Academy") ~ "Royal Academy",
    str_detect(event, "Society of Lady Artists") ~ "Society of Women Artists", 
    str_detect(event, "Folklore Society") ~ "The Folklore Society",
    # i think use event name for conferences/exhibitions without an of. but not generic
    event_type %in% c("conference", "exhibition", "misc")  & !event %in% c("meeting", "exhibition", "event", "petition", "conference")  ~ event
  )) |>

  # need an org id as well as org name. not quite the same as of_org_id... probably
  mutate(org_id = case_when(
    !is.na(of_org_id) ~ of_org_id,
    event_id=="Q292" & is.na(of_org) ~ event_id,
    # need these IDs 
    str_detect(event, "Royal Archaeological Institute|\\bRAI\\b") ~ "Q35", 
    str_detect(event, "Society of Antiquaries of London|\\bSAL\\b") ~ "Q8",
    str_detect(event, "Congress of Archaeological Societies|\\bCAS\\b") ~ "Q186", 
    str_detect(event, "Royal Academy") ~ "Royal_Academy",
    str_detect(event, "Society of Lady Artists") ~ "Q1891", # probably don't need this now ?
    str_detect(event, "Folklore Society") ~ "Q292",
    !is.na(event_org) ~ event_id,
    # conferences etc without an of - use event_id. but not if generic
    event_type %in% c("conference", "exhibition", "misc") & !event %in% c("meeting", "exhibition", "event", "petition", "conference") ~ event_id
  )) |>
  
  # event title. still probably wip. this is now not going to exactly match grouping of instance id, i think.
  # adding organised by -> needs some sort of tweak
  mutate(event_title = case_when(
    # for FS. not sure if still needed...
    event_id=="Q292" & is.na(of_org) ~ paste("meeting,", event),
    #  use year if other info is lacking. either should match instance id without a problem 
    event %in% c("exhibition", "meeting", "event", "conference") & is.na(of_org) & !is.na(year) ~ paste0(event, " (", year, ")"),
    event_id %in% c("Q1918") ~ event,  # society of ladies exhibition- don't want organised by in title here.
    !event %in% c("meeting", "event", "conference") & !is.na(organised_by) ~ event,
    is.na(of_org) ~ event,
    event=="event" ~ of_org,
    .default = paste(event, of_org, sep=", ")
  )) |>
  # some abbreviations
  mutate(event_title = str_replace_all(event_title, sal_rai_cas_abbr))  |>

  # grouping date for distinct events according to type of event
  # do i need to check this again after adjusting event_type? 
  mutate(event_instance_date = case_when(
    is.na(date) ~ NA,
    event_id=="Q682" ~ paste0(year, "-01-01"),
    event_type %in% c("misc", "meeting", "other") ~ as.character(date), # should i make this month?
    event_type %in% c("conference", "exhibition") ~ paste0(year, "-01-01")
  ))  |>

  mutate(event_instance_id = paste(event_instance_date, org_id, event_type, sep="_"))  |>
  
  # hmm, this may not quite work. and might need a bit of extra work for CAS etc. 
  mutate(event_org_id = case_when(
    # if generic and no other info except date, add year to the id [as in event_title].
    event %in% c("exhibition", "meeting", "event", "conference", "Annual Meeting", "petition") & is.na(of_org) & !is.na(year) ~ paste(org_id, event_type, year, sep="_"),
    # otherwise exclude date info
    .default =  paste(org_id, event_type, sep="_"))
    ) |>
  relocate(event_title, event_type, year, event_instance_date, event_org, org_id, event_instance_id, event_org_id, of_org, of_org_id, .after = ppa_type) 
  
bn_women_events_of_dates_types <-
bn_women_events_of_dates_types_all |>
  # losing ppa_label, but keep ppa in case you need any joins. bear in mind slight difference.
  # also dropping separate organised by and of cols.
  distinct(bn_id, personLabel, ppa_type, ppa, event_title, event_type, year, event_instance_date, event_org, org_id, event_instance_id, event_org_id, dob, yob)


# unique event instances based on the workings
# probably not quite right because it includes too much stuff incl title in group by
bn_women_event_instances <-
bn_women_events_of_dates_types_all |>
  group_by(event_instance_id, event_org_id, event_title, event_type, event_org, event, of_org, event_id, of_org_id, event_instance_date, year) |>
  # get all unique dates listed for the event instance, in chronological order
  arrange(date, .by_group = T) |>
  summarise(dates_in_db = paste(unique(date), collapse = " | "), .groups = "drop_last") |>
  ungroup()



# for making network 

bn_events_dated_for_pairs <-
bn_women_events_of_dates_types_all |>
  filter(!is.na(org_id) & !str_detect(org_id, "_:t") & !is.na(year)) |>
  mutate(org_year = paste(org_id, year))  |>
  distinct(from=bn_id, from_name=personLabel, org_year, event_instance_id, ppa_type, year )  |>
  mutate(group_id = paste0("events_", event_instance_id))



##############################
#### setting up served on ####
##############################


bn_women_served_sparql <-
'SELECT distinct ?personLabel ?serviceLabel  ?qualLabel  ?qual_propLabel ?qual  ?partofLabel ?instanceLabel ?person ?service ?partof ?instance ?qual_prop ?s
WHERE {  
  ?person bnwdt:P3 bnwd:Q3 . # select women
  FILTER NOT EXISTS {?person bnwdt:P4 bnwd:Q12 .} 
  
  ?person bnp:P102 ?s . # need this to get quals... i think  
  ?person ?p ?s . # for claim    
  
  ?served wikibase:claim ?p;      
         wikibase:statementProperty ?ps.    
    
    ?s ?ps ?service .
      # get part of statements for orgs in service
      optional { ?service bnwdt:P4 ?partof . }  
      optional { ?service bnwdt:P12 ?instance . }
   
   # fish for qualifiers
    optional {
     ?s ?pq ?qual .      
        ?qual_prop wikibase:qualifier ?pq. 
      } # /quals


  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE], en-gb, en". } 
}

ORDER BY ?personLabel ?s'

bn_women_served_query <-
  bn_std_query(bn_women_served_sparql) |>
  make_bn_item_id(person) |>
  make_bn_ids(c(qual, s, service, instance, partof, qual_prop)) |>
  mutate(across(c(qual, qualLabel, qual_propLabel, partofLabel, instanceLabel, partof, instance, qual_prop), ~na_if(., ""))) |>
  relocate(s, person, .after = last_col())


# drop a few quals that aren't helpful. there is an NA somewhere.
bn_women_served_prep <-
  bn_women_served_query |> 
  filter(!qual_prop %in%   c("P108", "P17", "P47", "P9", "P55", "P88")) |> 
  distinct(bn_id, personLabel, serviceLabel, qualLabel, qual, qual_propLabel, partofLabel, instanceLabel, instance, s, qual_prop, service, partof)


# just the service and s. not getting any multis from instance in this case. keep partof; shoudn't cause any multis.
bn_women_served_base <-
bn_women_served_prep |>
  filter(!is.na(qual)) |>
  distinct(bn_id, personLabel, serviceLabel, instanceLabel, partofLabel, partof, service, s)






bn_women_served_dates <-
bn_women_served_query  |>
  # don't need qualLabel for this one, it's basically the same as qual
  select(bn_id, s, qual_propLabel, qual, service, serviceLabel) |> 
  filter(qual_propLabel %in% c("end time", "point in time", "start time")) |>   #for this drop latest date
  # and drop unknown value (2) 
  filter(!str_detect(qual, "^_:t")) |>
  mutate(date = parse_date_time(qual, "ymdHMS"), year=year(date)) 

# do grouping/pivoting in a separate step.

bn_women_served_years <-
bn_women_served_dates |>
  # only need year for this. distinct probably not needed but just in case.
  distinct(bn_id, qual_propLabel, serviceLabel, year, s) |>
  # top_n gets rid of dup(s). only one person, start time
  group_by(s, bn_id, qual_propLabel, serviceLabel) |>
  top_n(-1, year) |>
  ungroup() |> 
  pivot_wider(id_cols = c(s, bn_id, serviceLabel), names_from = qual_propLabel, values_from = year) |>
  clean_names("snake") |>
  relocate(start_time, .before = end_time) |>
  # duration for start+end and also pit+end
  mutate(ds = end_time - start_time, dp = end_time - point_in_time) |>
  # std start and end years, inferred as 4 if there's only one; if pit+end treat pit as start.
  mutate(start_year = case_when(
    !is.na(ds) & ds >0 ~ start_time,
    !is.na(dp) & dp>0 ~ point_in_time,
    !is.na(point_in_time) ~ point_in_time,
    !is.na(start_time) ~ start_time,
    !is.na(end_time) ~ end_time - 4
  )) |>
  mutate(end_year = case_when(
    !is.na(ds) & ds > 0 ~ end_time,
    !is.na(dp) & dp>0 ~ end_time,
    !is.na(point_in_time) ~ point_in_time,
    !is.na(end_time) ~ end_time,
    !is.na(start_time) ~ start_time + 4
  )) 




bn_women_served_of <-
bn_women_served_prep |>
  filter(qual_propLabel=="of") |> 
  filter(!str_detect(qualLabel, "^[a-z]") & qualLabel !="Annual Meeting") |>
  distinct(bn_id, ofLabel=qualLabel,of= qual, s)




bn_women_service_org <-
bn_women_served_base |>
  left_join(bn_women_served_of, by=c("s", "bn_id")) |> 
  mutate(serv_orgLabel = case_when(
    !is.na(partof) ~ partofLabel, # first use part of
    is.na(of) & service %in% c("Q589", "Q293") ~ NA, # make NA if no specific info
    is.na(of) ~ serviceLabel, # then if no `of` use service
    .default = ofLabel    # then use of.
  )) |>
  mutate(serv_org = case_when(
    !is.na(partof) ~ partof,
    is.na(of) & service %in% c("Q589", "Q293") ~ NA,
    is.na(of) ~ service,
    .default = of
  )) |>
  distinct(bn_id, personLabel, serv_org, serv_orgLabel, partofLabel, serviceLabel, ofLabel, s) |>
  filter(!is.na(serv_org)) 



bn_women_service_org_years <-
  bn_women_service_org |>
  # only orgs with at least 2 women
  semi_join(
    bn_women_service_org |>
      distinct(bn_id, serv_org) |>
      count(serv_org) |> filter(n>1), by="serv_org"
  ) |>
  # dated
  inner_join(bn_women_served_years |> select(s, start_year, end_year), by="s") |>
  # expand years. should this have a group by?
  # purrr::map2 and seq() to fill out a list from a start number to given end number. then unnest to put each one on a new row.
  mutate(year = map2(start_year, end_year, ~seq(.x, .y, by=1))) |>
  unnest(year) |>
  # now you can do distinct... may want a date summary. 
  distinct(bn_id, personLabel, serv_org, serv_orgLabel, year)   |>
  mutate(group_id=paste("committees", serv_org, year, sep = "_"))
  

#######################
#### prep networks ####
#######################

# make unaggregated pairs: events, served, all

bn_events_pairs <-
bn_events_dated_for_pairs |>
  select(-event_instance_id) |>
  inner_join(bn_events_dated_for_pairs |>
               select(to=from, to_name=from_name, group_id), by="group_id", relationship = "many-to-many") |>
  filter(from!=to) |>
  relocate(to, to_name, .after = from_name) |>
  arrange(from_name, to_name) |>
  make_edge_ids() |>
  mutate(group="events")

bn_served_pairs <-
bn_women_service_org_years |>
  rename(from=bn_id, from_name=personLabel) |>
  inner_join(bn_women_service_org_years |>
               select(to=bn_id, to_name=personLabel, group_id), by=c("group_id"), relationship = "many-to-many") |>
  filter(from!=to) |>
  relocate(to, to_name, .after = from_name) |>
  arrange(from_name, to_name) |>
  make_edge_ids() |>
  mutate(group="committees")


bn_group_pairs <-
  bind_rows(
    bn_events_pairs ,
    bn_served_pairs
  ) |>
# doing distinct here might cause occasional glitch in binding but that should be easy to fix
  distinct(edge1, edge2, group_id, group) |>
  arrange(edge1, edge2, group)



# make nodes and edges lists for tidygraph

bn_events_edges <-
bn_events_pairs |>
  distinct(edge_id, edge1, edge2, group_id, year, group) |> # 585
  group_by(edge1, edge2, group) |>
  summarise(weight=n(), edge_start_year=min(year), edge_end_year=max(year), .groups = "drop_last") |>
  ungroup() |>
  mutate(from=edge1, to=edge2) |>
  relocate(from, to) 

# use edges list to make nodes list
bn_events_nodes <-
bn_events_edges |>
  pivot_longer(from:to, values_to = "person") |>
  # might want name=personLabel
  distinct(person, group) |>
  # do you want this now? don't think you do.
  #inner_join(bn_person_list, by="person") |>
  # not too sure about this either, but keep it for the moment.
  inner_join(
    bn_events_pairs |>
      distinct(from, to, group_id) |>
      pivot_longer(c(from, to), values_to = "person") |>
      distinct(person, group_id) |> 
  	count(person, name="nn"), by="person"
  ) 

bn_served_edges <-
  bn_served_pairs |>
  distinct(edge_id, edge1, edge2, group_id, year, group) |> 
  group_by(edge1, edge2, group) |>
  summarise(weight=n(), edge_start_year=min(year), edge_end_year=max(year), .groups = "drop_last") |>
  ungroup() |>
  mutate(from=edge1, to=edge2) |>
  relocate(from, to) 

bn_served_nodes <-
bn_served_edges |>
  pivot_longer(from:to, values_to = "person") |>
  # might want name=personLabel here.
  distinct(person, group) |>
  # don't think you want this
  #inner_join(bn_person_list, by="person") |>
  inner_join(
    bn_served_pairs |>
      distinct(from, to, group_id) |>
      pivot_longer(c(from, to), values_to = "person") |>
      distinct(person, group_id) |> 
  	count(person, name="nn"), by="person"
  ) 



bn_group_edges <-
bn_group_pairs |>
  group_by(edge1, edge2) |>
  summarise(weight=n(), .groups = "drop_last") |>
  ungroup() |>
  # keep the original edge1 and edge2 rather than renaming
  mutate(from=edge1, to=edge2) |>
  relocate(from, to) |>
  # can't make final group here
  mutate(group="all")


# use edges list to make nodes list
bn_group_nodes <-
bn_group_edges |>
  pivot_longer(from:to, values_to = "person") |>
  distinct(person) |>
  #inner_join(bn_person_list, by="person") |>
  inner_join(
  bn_group_pairs |>
      # probably don't need this... but just in case
      distinct(edge1, edge2, group_id, group) |>
      pivot_longer(c(edge1, edge2), values_to = "person") |>
      distinct(person, group_id, group) |> 
  	count(person, name="nn"), by="person" 
    # but what exactly is nn(n) when you merge everything... 
  )  |> 
  # try this for group instead
  left_join(bn_served_nodes |> select(person) |> mutate(in_served="y"), by="person") |>
  left_join(bn_events_nodes |> select(person) |> mutate(in_events="y"), by="person") |>
  mutate(group = case_when(
    in_served=="y" & in_events=="y" ~ "both",
    in_served=="y" ~ "committees",
    in_events=="y" ~ "events"
  )) |>
  select(-in_served, -in_events)
  # don't want this, it's confusing, because only some are "all"
  #mutate(group="all")




# make events network. 
bn_events_network <-
bn_tbl_graph(
  bn_events_nodes,
  bn_events_edges
)   |>
  #filter(!node_is_isolated()) |> don't need this if you use bn_centrality.
  bn_centrality() 
#  bn_clusters()


# make served network
bn_served_network <-
bn_tbl_graph(
  bn_served_nodes, 
  bn_served_edges) |>
  bn_centrality() 
#  bn_clusters() 


# make group network
bn_group_network <-
  bn_tbl_graph(bn_group_nodes, bn_group_edges) |>
  #filter(!node_is_isolated()) |> not needed if using bn_centrality
  bn_centrality() 
  




## pull out the bits of events/served you need to use in grouped meta.

bn_events_nodes_for_meta <-
bn_events_network |>
  activate(nodes) |>
  as_tibble() |>
  select(-betweenness) 

bn_events_edges_for_meta <-
bn_events_network |>
  activate(edges) |>
  as_tibble() |>
  select(-from, -to)


bn_served_nodes_for_meta <-
bn_served_network |>
  activate(nodes) |>
  as_tibble() |>
  select(-betweenness) 

bn_served_edges_for_meta <-
bn_served_network |>
  activate(edges) |>
  as_tibble() |>
  select(-from, -to)




bn_group_nodes_for_meta <-
bn_group_network |>
  activate(nodes) |>
  as_tibble() |>
  select(-betweenness) 

bn_group_edges_for_meta <-
bn_group_network |>
  activate(edges) |>
  as_tibble() |>
  select(-from, -to)






#### make meta ####


bn_nodes_meta <-
  # you don't want to include all at this point.
bind_rows(
  bn_events_nodes_for_meta,
  bn_served_nodes_for_meta
) |>
  select(person, group) |>
  # groups as a list-column, for filtering. events, committees only.
  group_by(person) |>
  arrange(group, .by_group = T) |>
  summarise(groups=list(group)) |>
  ungroup() |>
  # the actual metadata - events, committees, all.
  left_join(
    bn_events_nodes_for_meta |>
      select(-group) |>
      group_by(person) |>
      # this gives events: [{}] and i think you only want events: {} but maybe you can work with it.
      nest(events = c(nn, degree, degree_rank, betweenness_rank)) |> ##, grp_infomap, grp_leading_eigen
      ungroup() , by=c("person")
  ) |>
  left_join(
    bn_served_nodes_for_meta |>
      select(-group) |>
      group_by(person) |>
      nest(committees = c(nn, degree, degree_rank, betweenness_rank)) |> ##, grp_infomap, grp_leading_eigen
      ungroup() , by=c("person")
  ) |>
  left_join(
    bn_group_nodes_for_meta |>
      select(-group) |>
      group_by(person) |>
      nest(all = c(nn, degree, degree_rank, betweenness_rank)) |> ##, grp_infomap, grp_leading_eigen
      ungroup() , by=c("person")
  ) 


bn_edges_meta <-
  bind_rows(
  bn_events_edges_for_meta,
  bn_served_edges_for_meta
)  |>
      select(edge1, edge2, group, weight) |>
  pivot_wider(id_cols = c(edge1, edge2), names_from = group, values_from = weight, names_prefix = "weight_") |>
  mutate(group = case_when(
    is.na(weight_committees) ~ "events",
    is.na(weight_events) ~ "committees",
    .default = "both"
    ) ) |>
  mutate(weight_both = case_when(
    group=="events" ~ weight_events,
    group=="committees" ~ weight_committees,
    .default = weight_committees + weight_events
  )) 


# adjust so person=id and name is used as label only. i think should only affect labels/tooltips.

bn_group_nodes_d3 <-
bn_group_network |>
  activate(nodes) |>
  as_tibble() |>
  # drop most of the top level metadata.
  select(person, nn, group) |>
  inner_join(bn_person_list, by="person") |>
  #nested nodes metadata. 
  left_join(bn_nodes_meta, by="person") |>
  mutate(id=person) |>
  relocate(id) |>
  arrange(name)




bn_group_edges_d3 <-
bn_group_network |>
  activate(edges) |>
  as_tibble() |>
  # don't use weight here
  select(edge1, edge2) |>
  # group should be in here now...
  left_join(bn_edges_meta, by=c("edge1", "edge2")) |>
  rename(source=edge1, target=edge2)

  
# put in named list ready to write_json  
bn_two_json <-
list(
     nodes= bn_group_nodes_d3,
     links= bn_group_edges_d3
     )  
     
    
