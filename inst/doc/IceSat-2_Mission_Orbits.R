## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(fig.width = 4,
                      fig.height = 4, 
                      fig.align = "center",
                      fig.pos = "!H",
                      warning = FALSE, 
                      message = FALSE,
                      echo = TRUE,
                      eval = TRUE)

## -----------------------------------------------------------------------------

require(IceSat2R)
require(magrittr)
require(sf)

sf::sf_use_s2(use_s2 = FALSE)                        # disable 's2' in this vignette
mapview::mapviewOptions(leafletHeight = '600px', 
                        leafletWidth = '700px')      # applies to all leaflet maps


## ---- eval = FALSE------------------------------------------------------------
#  
#  avail_cycles = available_RGTs(only_cycle_names = TRUE)
#  avail_cycles
#  # [1] "RGT_cycle_1"  "RGT_cycle_2"  "RGT_cycle_3"  "RGT_cycle_4"  "RGT_cycle_5"  "RGT_cycle_6"
#  #     "RGT_cycle_7"  "RGT_cycle_8"  "RGT_cycle_9"  "RGT_cycle_10" "RGT_cycle_11" "RGT_cycle_12"
#  #     "RGT_cycle_13" "RGT_cycle_14" "RGT_cycle_15"
#  
#  choose_cycle = avail_cycles[14]
#  choose_cycle
#  # [1] "RGT_cycle_14"
#  
#  
#  res_rgt_many = time_specific_orbits(RGT_cycle = choose_cycle,
#                                      download_method = 'curl',
#                                      threads = 8,
#                                      verbose = TRUE)
#  

## ---- eval = FALSE------------------------------------------------------------
#  
#  rgt_subs = sf::st_coordinates(res_rgt_many)
#  colnames(rgt_subs) = c('longitude', 'latitude')
#  rgt_subs = data.table::data.table(rgt_subs)
#  rgt_subs$day_of_year = res_rgt_many$day_of_year
#  rgt_subs$Date = as.Date(res_rgt_many$Date_time)
#  rgt_subs$hour = lubridate::hour(res_rgt_many$Date_time)
#  rgt_subs$minute = lubridate::minute(res_rgt_many$Date_time)
#  rgt_subs$second = lubridate::second(res_rgt_many$Date_time)
#  rgt_subs$RGT = res_rgt_many$RGT
#  

## ---- echo = FALSE, eval = FALSE----------------------------------------------
#  
#  #..........................................................
#  # I saved the 'rgt_subs' object as RDS initially
#  # so that I don't have to call the 'time_specific_orbits()'
#  # function in the vignette
#  #..........................................................
#  
#  # saveRDS(object = rgt_subs, file = 'RGT_cycle_14.RDS')
#  

## ---- echo = FALSE------------------------------------------------------------

#..............................................
# load the saved data and create an 'sf' object
#..............................................

pth_rds = system.file('data_files/RGT_cycle_14.RDS', package = "IceSat2R")
rgt_subs = readRDS(file = pth_rds)


## -----------------------------------------------------------------------------

res_rgt_many = sf::st_as_sf(x = rgt_subs, coords = c('longitude', 'latitude'), crs = 4326)
res_rgt_many


## -----------------------------------------------------------------------------

cntr = rnaturalearth::ne_countries(scale = 110, type = 'countries', returnclass = 'sf')
cntr = cntr[, c('sovereignt', 'sov_a3')]
cntr


## -----------------------------------------------------------------------------

dat_both = suppressMessages(sf::st_join(x = res_rgt_many,
                                        y = cntr, 
                                        join = sf::st_intersects, 
                                        left = TRUE))
dat_both


## -----------------------------------------------------------------------------

length(unique(dat_both$RGT))


## -----------------------------------------------------------------------------

df_tbl = data.frame(table(dat_both$sovereignt), stringsAsFactors = F)
colnames(df_tbl) = c('country', 'Num_IceSat2_points')

df_subs = dat_both[, c('RGT', 'sovereignt')]
df_subs$geometry = NULL
df_subs = data.table::data.table(df_subs, stringsAsFactors = F)
colnames(df_subs) = c('RGT', 'country')
df_subs = split(df_subs, by = 'country')
df_subs = lapply(df_subs, function(x) {
  unq_rgt = sort(unique(x$RGT))
  items = ifelse(length(unq_rgt) < 5, length(unq_rgt), 5)
  concat = paste(unq_rgt[1:items], collapse = '-')
  iter_dat = data.table::setDT(list(country = unique(x$country), 
                                    Num_RGTs = length(unq_rgt), 
                                    first_5_RGTs = concat))
  iter_dat
})

df_subs = data.table::rbindlist(df_subs)

df_tbl = merge(df_tbl, df_subs, by = 'country')
df_tbl = df_tbl[order(df_tbl$Num_IceSat2_points, decreasing = T), ]


## -----------------------------------------------------------------------------

DT_dtbl = DT::datatable(df_tbl, rownames = FALSE)


## ---- echo = FALSE------------------------------------------------------------

DT_dtbl


## -----------------------------------------------------------------------------

num_sea = sum(is.na(dat_both$sovereignt))
num_land = sum(!is.na(dat_both$sovereignt))

perc_sea = round(num_sea / nrow(dat_both), digits = 4) * 100.0
perc_land = round(num_land / nrow(dat_both), digits = 4) * 100.0

dtbl_land_sea = data.frame(list(percentage = c(perc_sea, perc_land),
                                Num_Icesat2_points = c(num_sea, num_land)))

row.names(dtbl_land_sea) = c('sea', 'land')



## ---- results = 'asis'--------------------------------------------------------

stargazer::stargazer(dtbl_land_sea, 
                     summary = FALSE, 
                     rownames = FALSE, 
                     header = FALSE, 
                     table.placement = 'h', 
                     title = 'Land and Sea Proportions')


## -----------------------------------------------------------------------------

ne_glaciers = system.file('data_files', 'ne_10m_glaciated_areas.RDS', package = "IceSat2R")
ne_obj = readRDS(file = ne_glaciers)


## -----------------------------------------------------------------------------

ne_obj_subs = subset(ne_obj, !is.na(name))
ne_obj_subs = sf::st_make_valid(x = ne_obj_subs)      # check validity of geometries
ne_obj_subs


## -----------------------------------------------------------------------------

mpv = mapview::mapview(ne_obj_subs, 
                       color = 'cyan', 
                       col.regions = 'blue', 
                       alpha.regions = 0.5, 
                       legend = FALSE)
mpv

## -----------------------------------------------------------------------------

res_rgt_many$id_rgt = 1:nrow(res_rgt_many)       # include 'id' for fast subsetting

dat_glac_sf = suppressMessages(sf::st_join(x = ne_obj_subs,
                                           y = res_rgt_many, 
                                           join = sf::st_intersects))

dat_glac = data.table::data.table(sf::st_drop_geometry(dat_glac_sf), stringsAsFactors = F)
dat_glac = dat_glac[complete.cases(dat_glac), ]              # keep non-NA observations
dat_glac


## -----------------------------------------------------------------------------

dat_glac_name = split(x = dat_glac, by = 'name')

sum_stats_glac = lapply(dat_glac_name, function(x) {
  
  dtbl_glac = x[, .(name_glacier = unique(name), 
                    Num_unique_Dates = length(unique(Date)),
                    Num_unique_RGTs = length(unique(RGT)))]
  dtbl_glac
})

sum_stats_glac = data.table::rbindlist(sum_stats_glac)
sum_stats_glac = sum_stats_glac[order(sum_stats_glac$Num_unique_RGTs, decreasing = T), ]


## ---- results = 'asis'--------------------------------------------------------

stargazer::stargazer(sum_stats_glac, 
                     summary = FALSE, 
                     rownames = FALSE, 
                     header = FALSE, 
                     table.placement = 'h', 
                     title = 'Days and RGTs')


## -----------------------------------------------------------------------------

sample_glacier = 'Southern Patagonian Ice Field'
dat_glac_smpl = dat_glac_name[[sample_glacier]]


## ---- results = 'asis'--------------------------------------------------------

cols_display = c('name', 'day_of_year', 'Date', 'hour', 'minute', 'second', 'RGT')

stargazer::stargazer(dat_glac_smpl[, ..cols_display], 
                     summary = FALSE, 
                     rownames = FALSE, 
                     header = FALSE, 
                     table.placement = 'h', 
                     title = 'Southern Patagonian Ice Field')


## -----------------------------------------------------------------------------

subs_rgts = subset(res_rgt_many, id_rgt %in% dat_glac_smpl$id_rgt)

set.seed(1)
samp_colrs = sample(x = grDevices::colors(distinct = TRUE), 
                    size = nrow(subs_rgts))
subs_rgts$color = samp_colrs


## -----------------------------------------------------------------------------

ne_obj_subs_smpl = subset(ne_obj_subs, name == sample_glacier)

mpv_glacier = mapview::mapview(ne_obj_subs_smpl, 
                               color = 'cyan', 
                               col.regions = 'blue', 
                               alpha.regions = 0.5, 
                               legend = FALSE)

mpv_RGTs = mapview::mapview(subs_rgts,
                            color = subs_rgts$color,
                            alpha.regions = 0.0,
                            lwd = 6,
                            legend = FALSE)

## -----------------------------------------------------------------------------

lft = mpv_glacier + mpv_RGTs
lft


