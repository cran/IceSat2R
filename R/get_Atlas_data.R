
#' Get ICESat-2 ATLAS data for a specific Date
#'
#' This function allows the user to download ICESat-2 ATLAS Product data for a specific date, bounding box, track and beam.
#'
#' @param minx the 'minx' parameter of the bounding box
#' @param maxx the 'maxx' parameter of the bounding box
#' @param miny the 'miny' parameter of the bounding box
#' @param maxy the 'maxy' parameter of the bounding box
#' @param date a character string specifying the Data collection date in the format 'yyyy-MM-dd' (such as '2020-01-01')
#' @param trackId an integer specifying the 'Reference ground track ID' (see the examples section on how to come to the 'trackId' and to a bounding box of 1 or 5 degrees globally)
#' @param beamName either NULL (if the 'product' parameter is not equal to 'atl03' which means data for all 6 beams will be returned) or a character string specifying the Beam Name, which can be one of the 'gt1l', 'gt1r', 'gt2l', 'gt2r', 'gt3l' or 'gt3r'
#' @param product a character string specifying the input data product (default value is 'atl03'). It can be one of 'atl03', 'atl06', 'atl07', 'atl08', 'atl10', 'atl12' or 'atl13'
#' @param client a character string specifying the 'Referring client'. Can be one of 'portal' or 'jupyter' (default is 'portal')
#' @param photonConfidence either NULL or a character vector specifying the 'Confidence levels of the photons (can be one or more). If NULL (default) all photon data will be returned. The available options are 'na', 'noise', 'buffer', 'low', 'medium', 'high'
#' @param sampling a boolean. If TRUE a sampling rate of 1/1000 will be used, otherwise all data will be returned (default is FALSE)
#' @param outputFormat a character string specifying the output format of the downloaded data. One of 'csv', 'json' or 'zip'
#' @param file_path_zip either NULL or a character string specifying a valid path to the output .zip file. This parameter will normally be a valid path if the 'outputFormat' parameter is set to 'zip'. If it's NULL and the 'outputFormat' parameter is 'zip' then the downloaded '.zip' file will be converted and returned as a data.table object
#' @param download_method a character string specifying the download method to use. Can be one of 'internal', 'wininet' (Windows only), 'libcurl', 'wget', 'curl' or 'auto'. For more information see the documentation of the 'utils::download.file()' function
#' @param verbose a boolean. If TRUE then information will be printed out in the console
#'
#' @return if the 'file_path_zip' parameter is NULL it returns either a data.table (if outputFormat is 'csv') or a nested list (if outputFormat is 'json') else the file path where the .zip file is saved. In case that the 'outputFormat' is set to 'zip' and the 'file_path_zip' parameter to NULL then a data.table will be returned.
#'
#' @details
#'
#' \describe{
#'  \item{'atl03', \emph{Global Geolocated Photon Data} (Version 4, Requests are limited to 1x1 degree spatial bounding box selection \emph{unless "sampling" is set to true})}{This data set \emph{(ATL03)} contains height above the WGS 84 ellipsoid (ITRF2014 reference frame), latitude, longitude, and time for all photons downlinked by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory. The ATL03 product was designed to be a single source for all photon data and ancillary information needed by higher-level ATLAS/ICESat-2 products. As such, it also includes spacecraft and instrument parameters and ancillary data not explicitly required for ATL03}
#'  \item{'atl06', \emph{Land Ice Height} (Version 4, Requests are limited to 5x5 degree spatial bounding box selection)}{This data set \emph{(ATL06)} provides geolocated, land-ice surface heights (above the WGS 84 ellipsoid, ITRF2014 reference frame), plus ancillary parameters that can be used to interpret and assess the quality of the height estimates. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl07', \emph{Sea Ice Height} (Version 4, Requests are limited to 5x5 degree spatial bounding box selection)}{The data set \emph{(ATL07)} contains along-track heights for sea ice and open water leads (at varying length scales) relative to the WGS84 ellipsoid (ITRF2014 reference frame) after adjustment for geoidal and tidal variations, and inverted barometer effects. Height statistics and apparent reflectance are also provided. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl08', \emph{Land and Vegetation Height} (Version 4, Requests are limited to 5x5 degree spatial bounding box selection)}{This data set \emph{(ATL08)} contains along-track heights above the WGS84 ellipsoid (ITRF2014 reference frame) for the ground and canopy surfaces. The canopy and ground surfaces are processed in fixed 100 m data segments, which typically contain more than 100 signal photons. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl10', \emph{Sea Ice Freeboard} (Version 4, Requests are limited to 5x5 degree spatial bounding box selection)}{This data set \emph{(ATL10)} contains estimates of sea ice freeboard, calculated using three different approaches. Sea ice leads used to establish the reference sea surface and descriptive statistics used in the height estimates are also provided. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl12', \emph{Ocean Surface Height} (Version 4, Requests are limited to 5x5 degree spatial bounding box selection)}{This data set \emph{(ATL12)} contains along-track sea surface heights at variable length scales over cloud-free regions. Estimates of height distributions, surface roughness, surface slope, and apparent reflectance are also provided. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl13', \emph{Inland Water Surface Height} (Version 4, Requests are limited to 5x5 degree spatial bounding box selection)}{This data set \emph{(ATL13)} contains along-track water surface heights and descriptive statistics for inland water bodies. Water bodies include lakes, reservoirs, bays, and estuaries. Descriptive statistics include along-track surface slope (where data permit), mean and standard deviation, subsurface signal (532 nm) attenuation, wave height, and coarse depth to bottom topography}
#'  }
#'
#' @references
#'
#' https://openaltimetry.earthdatacloud.nasa.gov
#'
#' https://nsidc.org/data/icesat-2
#'
#' @importFrom glue glue
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' require(IceSat2R)
#'
#' #............................................................
#' # observe the available countries and continents using the
#' # 'rnaturalearth' R package to perform a query using map-edit
#' #............................................................
#'
#' cntr_cnt = rnaturalearth::ne_countries(scale = 110,
#'                                        type = 'countries',
#'                                        returnclass = 'sf')
#'
#' cntr_cnt = cntr_cnt[, c('sovereignt', 'continent')]
#'
#' # sort(cntr_cnt$sovereignt)
#' # sort(unique(cntr_cnt$continent))
#'
#'
#' #............................
#' # Select a 'continent' as AOI   (5-degree query)
#' #............................
#'
#' init = select_aoi_global_grid$new(area_of_interest = 'Oceania',
#'                                   verbose = TRUE)
#'
#' init$draw_edit_aoi(degrees = 5.0, square_geoms = TRUE)
#' sf_obj = init$selected_areas_global_grid(plot_data = FALSE)
#' sf_obj
#'
#' #.....................................................
#' # I drew a bounding box close to 'Mount Hagen Papua'
#' # inside one of the 5-degreee cells (after zooming-in)
#' #.....................................................
#'
#' # mapview::mapview(sf_obj, legend = F)
#' # sf::st_as_text(sf::st_geometry(sf_obj))
#'
#' #................................................
#' # to reproduce the results without selecting
#' # an area based on the 'draw_edit_aoi()' function
#' #................................................
#'
#' # plg = "POLYGON ((140 -6.641235, 145 -6.641235, 145 -1.641235, 140 -1.641235, 140 -6.641235))"
#' # sf_obj = sf::st_as_sfc(plg, crs = 4326)
#'
#'
#' #....................................................
#' # first we find available ICESat-2 track-ID's
#' # and Dates (time interval) from a specific RGT cycle
#' #....................................................
#'
#' approx_date_start = "2021-02-01"
#' approx_date_end = "2021-02-15"
#' # 'RGT_cycle_10'
#'
#' res_rgt_many = time_specific_orbits(date_from = approx_date_start,
#'                                     date_to = approx_date_end,
#'                                     RGT_cycle = NULL,
#'                                     download_method = 'curl',
#'                                     threads = parallel::detectCores(),
#'                                     verbose = TRUE)
#' res_rgt_many
#'
#' #.........................................................
#' # then we create the bounding box of the selected area
#' # and proceed to the intersection with the computed RGT's
#' # ( include the bounding box for reproducibility )
#' #.........................................................
#'
#' bbx_aoi = sf::st_bbox(obj = sf_obj)
#' # c(xmin = 140, ymin = -6.641235, xmax = 145, ymax = -1.641235)
#'
#' sf_obj_bbx = sf::st_as_sfc(bbx_aoi)
#'
#' res_inters = sf::st_intersects(x = sf_obj_bbx,
#'                                y = sf::st_geometry(res_rgt_many),
#'                                sparse = TRUE)
#' #.....................
#' # matched (RGT) tracks
#' #.....................
#'
#' df_inters = data.frame(res_inters)
#'
#' if (nrow(df_inters) == 0) {
#'   stop("There is no intersection between the specified AOI and the RGTs!")
#' }
#'
#'
#' rgt_subs = res_rgt_many[df_inters$col.id, , drop = FALSE]
#' rgt_subs
#'
#'
#' #..........................................
#' # find out which of the time specific RGT's
#' # match the OpenAltimetry Track-ID's
#' #..........................................
#'
#' dtbl_rgts = verify_RGTs(nsidc_rgts = rgt_subs,
#'                         bbx_aoi = bbx_aoi,
#'                         verbose = TRUE)
#'
#' #...................................
#' # we will iterate over the available:
#' #    - Dates
#' #    - trackId's
#' #    - product's
#' # to gather the up to 5-degree data
#' #..................................
#'
#' dates_iters = unique(dtbl_rgts$Date_time)
#' RGTs_iters = unique(dtbl_rgts$RGT_NSIDC)
#' prods_5_degrs = c('atl06', 'atl07', 'atl08', 'atl10', 'atl12', 'atl13')
#'
#' dat_out = logs_out = list()
#'
#' for (idx in seq_along(dates_iters)) {
#'
#'   date_i = dates_iters[idx]
#'   rgt_i = RGTs_iters[idx]
#'
#'   for (prod_i in prods_5_degrs) {
#'
#'     name_iter = glue::glue("{date_i}_{rgt_i}_{prod_i}")
#'     cat(glue::glue("Date: '{date_i}'  RGT: '{rgt_i}'  Product: '{prod_i}'"), '\n')
#'
#'     iter_dat = get_atlas_data(minx = as.numeric(bbx_aoi['xmin']),
#'                               miny = as.numeric(bbx_aoi['ymin']),
#'                               maxx = as.numeric(bbx_aoi['xmax']),
#'                               maxy = as.numeric(bbx_aoi['ymax']),
#'                               date = date_i,
#'                               trackId = rgt_i,
#'                               product = prod_i,
#'                               client = 'portal',
#'                               outputFormat = 'csv',
#'                               verbose = FALSE)
#'
#'     iter_logs = list(Date = date_i,
#'                      RGT = rgt_i,
#'                      Product = prod_i,
#'                      N_rows = nrow(iter_dat))
#'
#'     logs_out[[name_iter]] = data.table::setDT(iter_logs)
#'     dat_out[[name_iter]] = iter_dat
#'   }
#' }
#'
#' #.........................................
#' # each sublist corresponds to a different
#' # parameter setting (Date, Track, Product)
#' #.........................................
#'
#' dat_out
#'
#' #.....
#' # Logs  (including the number of rows for each parameter setting)
#' #.....
#'
#' dtbl_logs = data.table::rbindlist(logs_out)
#' dtbl_logs = subset(dtbl_logs, N_rows > 0)
#' dtbl_logs = dtbl_logs[order(dtbl_logs$N_rows, decreasing = T), ]
#' dtbl_logs
#'
#' #.............................................
#' # The Products 'atl08' and 'atl13' have data
#' # for the Dates and RGT's of the selected area
#' #.............................................
#'
#' unique(dtbl_logs$Product)
#' # c("atl06" "atl08" "atl13" "atl12")
#'
#' #................
#' # RGT's with data
#' #................
#'
#' unique(dtbl_logs$RGT)
#' # c(627, 756, 688, 619, 817)
#'
#' #................
#' # Dates with Data
#' #................
#'
#' unique(dtbl_logs$Date)
#' # c("2021-02-03", "2021-02-11", "2021-02-07", "2021-02-02", "2021-02-15")
#'
#'
#' #============
#' # ATL03 Data
#' #============
#'
#' ................................................
#' # the default timeout is 60 and we set it to 600
#' #...............................................
#' 
#' options(timeout = 600)
#' print(getOption('timeout'))
#' 
#' 
#' # we skip the interactive selection of the 1 degree grid
#' plg = "POLYGON ((142 -34.64124, 143 -34.64124, 143 -33.64124, 142 -33.64124, 142 -34.64124))"
#' sf_obj_atl03 = sf::st_as_sfc(plg, crs = 4326)
#' 
#' # we update the bounding box based on the AOI
#' bbx_aoi = sf::st_bbox(obj = sf_obj_atl03)
#' # c(xmin = 142, ymin = -34.64124, xmax = 143, ymax = -33.64124)
#' 
#' sf_obj_bbx = sf::st_as_sfc(bbx_aoi)
#' 
#' res_inters = sf::st_intersects(x = sf_obj_bbx,
#'                                y = sf::st_geometry(res_rgt_many),
#'                                sparse = TRUE)
#' 
#' df_inters = data.frame(res_inters)
#' 
#' if (nrow(df_inters) == 0) {
#'   stop("There is no intersection between the specified AOI and the RGTs!")
#' }
#' 
#' 
#' rgt_subs = res_rgt_many[df_inters$col.id, , drop = FALSE]
#' rgt_subs
#' 
#' dtbl_rgts = verify_RGTs(nsidc_rgts = rgt_subs,
#'                         bbx_aoi = bbx_aoi,
#'                         verbose = TRUE)
#' 
#' comp_cas = complete.cases(dtbl_rgts)
#' dtbl_rgts = dtbl_rgts[comp_cas, , drop = F]
#' 
#' 
#' dates_iters = unique(dtbl_rgts$Date_time)
#' RGTs_iters = unique(dtbl_rgts$RGT_NSIDC)
#' prods_1_degrs = c('atl03')
#' 
#' #...........................
#' # use all beams with 'atl03'
#' #...........................
#' 
#' dat_out = logs_out = list()
#' 
#' for (idx in seq_along(dates_iters)) {
#'   
#'   date_i = dates_iters[idx]
#'   rgt_i = RGTs_iters[idx]
#'   
#'   name_iter = glue::glue("{date_i}_{rgt_i}")
#'   cat(glue::glue("Date: '{date_i}'  RGT: '{rgt_i}'"), '\n')
#'   
#'   iter_dat = get_atlas_data(minx = as.numeric(bbx_aoi['xmin']),
#'                             miny = as.numeric(bbx_aoi['ymin']),
#'                             maxx = as.numeric(bbx_aoi['xmax']),
#'                             maxy = as.numeric(bbx_aoi['ymax']),
#'                             date = date_i,
#'                             beamName = NULL,
#'                             trackId = rgt_i,
#'                             product = prods_1_degrs,
#'                             client = 'portal',
#'                             outputFormat = 'csv',
#'                             verbose = FALSE)
#'   
#'   iter_logs = list(Date = date_i,
#'                    RGT = rgt_i,
#'                    Product = prods_1_degrs,
#'                    N_rows = nrow(iter_dat))
#'   
#'   logs_out[[name_iter]] = data.table::setDT(iter_logs)
#'   dat_out[[name_iter]] = iter_dat
#' }
#' 
#' dat_out
#' unique(dtbl_logs$Product)
#' unique(dat_out[[1]]$beam)
#' unique(dat_out[[1]]$`confidence code`)
#' 
#' #..................................................
#' # use 2 beams with 'atl03' (a vector of characters) 
#' #..................................................
#' 
#' dat_out = logs_out = list()
#' 
#' for (idx in seq_along(dates_iters)) {
#'   
#'   date_i = dates_iters[idx]
#'   rgt_i = RGTs_iters[idx]
#'   
#'   name_iter = glue::glue("{date_i}_{rgt_i}")
#'   cat(glue::glue("Date: '{date_i}'  RGT: '{rgt_i}'"), '\n')
#'   
#'   iter_dat = get_atlas_data(minx = as.numeric(bbx_aoi['xmin']),
#'                             miny = as.numeric(bbx_aoi['ymin']),
#'                             maxx = as.numeric(bbx_aoi['xmax']),
#'                             maxy = as.numeric(bbx_aoi['ymax']),
#'                             date = date_i,
#'                             beamName = c("gt1l", "gt1r"),
#'                             trackId = rgt_i,
#'                             product = prods_1_degrs,
#'                             client = 'portal',
#'                             outputFormat = 'csv',
#'                             verbose = FALSE)
#'   
#'   iter_logs = list(Date = date_i,
#'                    RGT = rgt_i,
#'                    Product = prods_1_degrs,
#'                    N_rows = nrow(iter_dat))
#'   
#'   logs_out[[name_iter]] = data.table::setDT(iter_logs)
#'   dat_out[[name_iter]] = iter_dat
#' }
#' 
#' dat_out
#' unique(dtbl_logs$Product)
#' unique(dat_out[[1]]$beam)
#' 
#' 
#' #.............................................
#' # use 1 beam with 'atl03' (a character string) 
#' #.............................................
#' 
#' dat_out = logs_out = list()
#' 
#' for (idx in seq_along(dates_iters)) {
#'   
#'   date_i = dates_iters[idx]
#'   rgt_i = RGTs_iters[idx]
#'   
#'   name_iter = glue::glue("{date_i}_{rgt_i}")
#'   cat(glue::glue("Date: '{date_i}'  RGT: '{rgt_i}'"), '\n')
#'   
#'   iter_dat = get_atlas_data(minx = as.numeric(bbx_aoi['xmin']),
#'                             miny = as.numeric(bbx_aoi['ymin']),
#'                             maxx = as.numeric(bbx_aoi['xmax']),
#'                             maxy = as.numeric(bbx_aoi['ymax']),
#'                             date = date_i,
#'                             beamName = "gt1l",
#'                             trackId = rgt_i,
#'                             product = prods_1_degrs,
#'                             client = 'portal',
#'                             outputFormat = 'csv',
#'                             verbose = FALSE)
#'   
#'   iter_logs = list(Date = date_i,
#'                    RGT = rgt_i,
#'                    Product = prods_1_degrs,
#'                    N_rows = nrow(iter_dat))
#'   
#'   logs_out[[name_iter]] = data.table::setDT(iter_logs)
#'   dat_out[[name_iter]] = iter_dat
#' }
#' 
#' dat_out
#' unique(dtbl_logs$Product)
#' unique(dat_out[[1]]$beam)
#' 
#' 
#' #..............................................
#' # use all beams with 'atl03' & photonConfidence
#' #..............................................
#' 
#' dat_out = logs_out = list()
#' 
#' for (idx in seq_along(dates_iters)) {
#'   
#'   date_i = dates_iters[idx]
#'   rgt_i = RGTs_iters[idx]
#'   
#'   name_iter = glue::glue("{date_i}_{rgt_i}")
#'   cat(glue::glue("Date: '{date_i}'  RGT: '{rgt_i}'"), '\n')
#'   
#'   iter_dat = get_atlas_data(minx = as.numeric(bbx_aoi['xmin']),
#'                             miny = as.numeric(bbx_aoi['ymin']),
#'                             maxx = as.numeric(bbx_aoi['xmax']),
#'                             maxy = as.numeric(bbx_aoi['ymax']),
#'                             date = date_i,
#'                             beamName = NULL,
#'                             photonConfidence = c('buffer', 'low'),
#'                             trackId = rgt_i,
#'                             product = prods_1_degrs,
#'                             client = 'portal',
#'                             outputFormat = 'csv',
#'                             verbose = FALSE)
#'   
#'   iter_logs = list(Date = date_i,
#'                    RGT = rgt_i,
#'                    Product = prods_1_degrs,
#'                    N_rows = nrow(iter_dat))
#'   
#'   logs_out[[name_iter]] = data.table::setDT(iter_logs)
#'   dat_out[[name_iter]] = iter_dat
#' }
#' 
#' dat_out
#' unique(dtbl_logs$Product)
#' unique(dat_out[[1]]$beam)
#' unique(dat_out[[1]]$`confidence code`)
#' 
#' }


get_atlas_data = function(minx,
                          miny,
                          maxx,
                          maxy,
                          date,
                          trackId,
                          beamName = NULL,
                          product = 'atl03',
                          client = 'portal',
                          photonConfidence = NULL,
                          sampling = FALSE,
                          outputFormat = 'csv',
                          file_path_zip = NULL,
                          download_method = 'curl',
                          verbose = FALSE) {

  if (!product %in% c('atl03', 'atl06', 'atl07', 'atl08', 'atl10', 'atl12', 'atl13')) stop("The 'product' parameter must be one of 'atl03', 'atl06', 'atl07', 'atl08', 'atl10', 'atl12' or 'atl13'!", call. = F)
  if (!client %in% c('portal', 'jupyter')) stop("The 'client' parameter must be one of 'portal' or 'jupyter'!", call. = F)
  if (!outputFormat %in% c('csv', 'json', 'zip')) stop("The 'outputFormat' parameter must be one of 'csv', 'json' or 'zip'!", call. = F)

  # The following is the default URL used in all products
  URL = glue::glue("https://openaltimetry.earthdatacloud.nasa.gov/data/api/icesat2/{product}?minx={minx}&miny={miny}&maxx={maxx}&maxy={maxy}&trackId={trackId}&outputFormat={outputFormat}&date={date}&client={client}")
  
  if (product == 'atl03') {
    
    URL = glue::glue("{URL}&sampling={tolower(sampling)}")
    
    # for 'atl03' we can also include the 'photonConfidence'
    if (!is.null(photonConfidence)) {
      
      make_url_ph = ''
      
      for (ph_i in photonConfidence) {                                                    # verify that the Beams are valid
        if (!ph_i %in% c('na', 'noise', 'buffer', 'low', 'medium', 'high')) {
          stop(glue::glue("The specified photonConfidence '{ph_i}' is not one of the available ones, i.e. 'na', 'noise', 'buffer', 'low', 'medium' or 'high'!"), call. = F)
        }
        
        make_url_ph = glue::glue("{make_url_ph}&photonConfidence={ph_i}")
      }
      
      URL = glue::glue("{URL}{make_url_ph}")
    }
  }
  
  # the 'beamName' applies to all 'products'
  if (!is.null(beamName)) {
    
    make_url = ''
    
    for (beam_i in beamName) {                                                    # verify that the Beams are valid
      if (!beam_i %in% c('gt1l', 'gt1r', 'gt2l', 'gt2r', 'gt3l', 'gt3r')) {
        stop(glue::glue("The specified beamName '{beam_i}' is not one of the available ones, i.e. 'gt1l', 'gt1r', 'gt2l', 'gt2r', 'gt3l' or 'gt3r'!"), call. = F)
      }
      
      make_url = glue::glue("{make_url}&beamNames={beam_i}")
    }
    
    URL = glue::glue("{URL}{make_url}")
  }

  res_out = get_URL_data(URL = URL,
                         outputFormat = outputFormat,
                         download_method = download_method,
                         file_path_zip = file_path_zip,
                         verbose = verbose)
  return(res_out)
}



#' Get IceSat-2 ATLAS 'Level-3A' data for a time interval (up to 1 year)
#'
#' This function allows the user to download IceSat-2 ATLAS 'Level-3A' data for a specific time interval, bounding box, track and beam.
#'
#' @param minx the 'minx' parameter of the bounding box
#' @param maxx the 'maxx' parameter of the bounding box
#' @param miny the 'miny' parameter of the bounding box
#' @param maxy the 'maxy' parameter of the bounding box
#' @param startDate a character string specifying the Data collection of the \emph{start} Date in the format 'yyyy-MM-dd' (such as '2020-01-01')
#' @param endDate a character string specifying the Data collection of the \emph{end} Date in the format 'yyyy-MM-dd' (such as '2020-01-01')
#' @param trackId an integer specifying the 'Reference ground track ID' (see the examples section on how to come to the 'trackId' and to a bounding box of 1 or 5 degrees globally)
#' @param beamName either NULL (data for all 6 beams will be returned) or a character vector specifying the Beam Name(s), It can be one or more of the 'gt1l', 'gt1r', 'gt2l', 'gt2r', 'gt3l' or 'gt3r'
#' @param product a character string specifying the input data product (default value is 'atl08'). It can be one of 'atl06', 'atl07', 'atl08', 'atl10', 'atl12' or 'atl13'
#' @param client a character string specifying the 'Referring client'. Can be one of 'portal' or 'jupyter' (default is 'portal')
#' @param outputFormat a character string specifying the output format of the downloaded data. One of 'csv', 'json' or 'zip'
#' @param file_path_zip either NULL or a character string specifying a valid path to the output .zip file. This parameter will normally be a valid path if the 'outputFormat' parameter is set to 'zip'. If it's NULL and the 'outputFormat' parameter is 'zip' then the downloaded '.zip' file will be converted and returned as a data.table object
#' @param download_method a character string specifying the download method to use. Can be one of 'internal', 'wininet' (Windows only), 'libcurl', 'wget', 'curl' or 'auto'. For more information see the documentation of the 'utils::download.file()' function
#' @param verbose a boolean. If TRUE then information will be printed out in the console
#'
#' @return if the 'file_path_zip' parameter is NULL it returns either a data.table (if outputFormat is 'csv') or a nested list (if outputFormat is 'json') else the file path where the .zip file is saved. In case that the 'outputFormat' is set to 'zip' and the 'file_path_zip' parameter to NULL then a data.table will be returned.
#'
#' @details
#'
#' Up to 1 year worth of ICESat-2 \emph{Level-3A} product data can be downloaded. \emph{Note:} requests are limited to 5x5 degree spatial bounding box selection
#'
#' \describe{
#'  \item{'atl06', \emph{Land Ice Height} (Version 4)}{This data set \emph{(ATL06)} provides geolocated, land-ice surface heights (above the WGS 84 ellipsoid, ITRF2014 reference frame), plus ancillary parameters that can be used to interpret and assess the quality of the height estimates. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl07', \emph{Sea Ice Height} (Version 4)}{The data set \emph{(ATL07)} contains along-track heights for sea ice and open water leads (at varying length scales) relative to the WGS84 ellipsoid (ITRF2014 reference frame) after adjustment for geoidal and tidal variations, and inverted barometer effects. Height statistics and apparent reflectance are also provided. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl08', \emph{Land and Vegetation Height} (Version 4)}{This data set \emph{(ATL08)} contains along-track heights above the WGS84 ellipsoid (ITRF2014 reference frame) for the ground and canopy surfaces. The canopy and ground surfaces are processed in fixed 100 m data segments, which typically contain more than 100 signal photons. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl10', \emph{Sea Ice Freeboard} (Version 4)}{This data set \emph{(ATL10)} contains estimates of sea ice freeboard, calculated using three different approaches. Sea ice leads used to establish the reference sea surface and descriptive statistics used in the height estimates are also provided. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl12', \emph{Ocean Surface Height} (Version 4)}{This data set \emph{(ATL12)} contains along-track sea surface heights at variable length scales over cloud-free regions. Estimates of height distributions, surface roughness, surface slope, and apparent reflectance are also provided. The data were acquired by the Advanced Topographic Laser Altimeter System (ATLAS) instrument on board the Ice, Cloud and land Elevation Satellite-2 (ICESat-2) observatory}
#'  \item{'atl13', \emph{Inland Water Surface Height} (Version 4)}{This data set \emph{(ATL13)} contains along-track water surface heights and descriptive statistics for inland water bodies. Water bodies include lakes, reservoirs, bays, and estuaries. Descriptive statistics include along-track surface slope (where data permit), mean and standard deviation, subsurface signal (532 nm) attenuation, wave height, and coarse depth to bottom topography}
#'  }
#'
#' @references
#'
#' https://openaltimetry.earthdatacloud.nasa.gov
#'
#' https://nsidc.org/data/icesat-2
#'
#' @importFrom glue glue
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' require(IceSat2R)
#'
#' #.......................................................
#' # parameter setting based on the output results from the
#' # 'examples' section of the 'get_atlas_data()' function
#' # so that we can iterate over the RGT's and Products for
#' # the specified time interval
#' #.......................................................
#'
#' bbx = c(xmin = 140, ymin = -6.641235, xmax = 145, ymax = -1.641235)
#' start_date = "2021-02-03"
#' end_date = "2021-02-15"
#' RGTs = c(627, 756, 688, 619, 817)
#' Products = c('atl08', 'atl13')
#'
#' #........................................................
#' # loop over the specified parameters and save the results
#' #........................................................
#'
#' dat_out = logs_out = list()
#'
#' for (prod_i in Products) {
#'   for (track_i in RGTs) {
#'
#'     name_iter = glue::glue("{track_i}_{prod_i}")
#'     cat(glue::glue("RGT: '{track_i}'  Product: '{prod_i}'"), '\n')
#'
#'     iter_dat = get_level3a_data(minx = as.numeric(bbx['xmin']),
#'                                 miny = as.numeric(bbx['ymin']),
#'                                 maxx = as.numeric(bbx['xmax']),
#'                                 maxy = as.numeric(bbx['ymax']),
#'                                 startDate = start_date,
#'                                 endDate = end_date,
#'                                 trackId = track_i,
#'                                 beamName = NULL,        # return data of all 6 beams
#'                                 product = prod_i,
#'                                 client = 'portal',
#'                                 outputFormat = 'csv',
#'                                 verbose = FALSE)
#'
#'     iter_logs = list(RGT = track_i,
#'                      Product = prod_i,
#'                      N_rows = nrow(iter_dat))
#'
#'     logs_out[[name_iter]] = data.table::setDT(iter_logs)
#'     dat_out[[name_iter]] = iter_dat
#'   }
#' }
#'
#'
#' #.........................................
#' # each sublist corresponds to a different
#' # parameter setting (Track, Product)
#' #.........................................
#'
#' dat_out
#'
#' #.....
#' # Logs  (including the number of rows for each parameter setting)
#' #.....
#'
#' dtbl_logs = data.table::rbindlist(logs_out)
#' dtbl_logs = subset(dtbl_logs, N_rows > 0)
#' dtbl_logs = dtbl_logs[order(dtbl_logs$N_rows, decreasing = T), ]
#' dtbl_logs
#'
#' }


get_level3a_data = function(minx,
                            miny,
                            maxx,
                            maxy,
                            startDate,
                            endDate,
                            trackId,
                            beamName = NULL,
                            product = 'atl08',
                            client = 'portal',
                            outputFormat = 'csv',
                            file_path_zip = NULL,
                            download_method = 'curl',
                            verbose = FALSE) {

  if (!product %in% c('atl06', 'atl07', 'atl08', 'atl10', 'atl12', 'atl13')) stop("The 'level3a product' parameter must be one of 'atl06', 'atl07', 'atl08', 'atl10', 'atl12' or 'atl13'!", call. = F)
  if (!client %in% c('portal', 'jupyter')) stop("The 'client' parameter must be one of 'portal' or 'jupyter'!", call. = F)
  if (!outputFormat %in% c('csv', 'json', 'zip')) stop("The 'outputFormat' parameter must be one of 'csv', 'json' or 'zip'!", call. = F)
  if (as.Date(startDate) > as.Date(endDate)) stop(glue::glue("The start Date '{startDate}' has to be equal or smaller to the end Date '{endDate}'!"), call. = F)
  
  URL = glue::glue("https://openaltimetry.earthdatacloud.nasa.gov/data/api/icesat2/level3a?product={product}&minx={minx}&miny={miny}&maxx={maxx}&maxy={maxy}&trackId={trackId}&outputFormat={outputFormat}&startDate={startDate}&endDate={endDate}&client={client}")
  
  if (!is.null(beamName)) {
    
    make_url = ''
    
    for (beam_i in beamName) {                                                    # verify that the Beams are valid
      if (!beam_i %in% c('gt1l', 'gt1r', 'gt2l', 'gt2r', 'gt3l', 'gt3r')) {
        stop(glue::glue("The specified beamName '{beam_i}' is not one of the available ones, i.e. 'gt1l', 'gt1r', 'gt2l', 'gt2r', 'gt3l' or 'gt3r'!"), call. = F)
      }
      
      make_url = glue::glue("{make_url}&beamNames={beam_i}")
    }

    URL = glue::glue("{URL}{make_url}")
  }

  res_out = get_URL_data(URL = URL,
                         outputFormat = outputFormat,
                         download_method = download_method,
                         file_path_zip = file_path_zip,
                         verbose = verbose)
  return(res_out)
}

