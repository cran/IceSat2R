% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mission_orbits.R
\name{time_specific_orbits}
\alias{time_specific_orbits}
\title{Time Specific Orbits}
\usage{
time_specific_orbits(
  date_from = NULL,
  date_to = NULL,
  RGT_cycle = NULL,
  download_method = "curl",
  threads = 1,
  verbose = FALSE
)
}
\arguments{
\item{date_from}{either NULL or a character string specifying the start date in the format 'yyyy-MM-dd' (such as '2020-01-01'). If this parameter is NULL then the 'RGT_cycle' parameter must be specified}

\item{date_to}{either NULL or a character string specifying the end date in the format 'yyyy-MM-dd' (such as '2020-01-01'). If this parameter is NULL then the 'RGT_cycle' parameter must be specified}

\item{RGT_cycle}{a character vector specifying the RGT (Reference Ground Track) cycle(s) (the specific revisit times of ICESAT-2). This parameter can be greater or equal to 1 with a maximum 'RGT-cycle' names as determined by the output of the 'available_RGTs(only_cycle_names = TRUE)' function. The computation time of a single 'RGT-cycle' might take approximately 15 minutes utilizing 8 threads (in parallel) and require approximately 2 GB of memory.}

\item{download_method}{a character string specifying the download method. Corresponds to the 'method' parameter of the 'utils::download.file()' function. Can be one of 'internal', 'wininet' (Windows only), 'libcurl', 'wget', 'curl' or 'auto'}

\item{threads}{an integer that specifies the number of threads to use in parallel when processing the data}

\item{verbose}{a boolean. If TRUE then information will be printed out in the console}
}
\value{
an 'sf' object that will include one or more Reference Ground Tracks  (see the 'RGT' column of the output object)
}
\description{
This function shows the reference ground track time and locations for specific date ranges. "Updated KML files have been posted to the 'tech-specs'
website (see the 'references' section for more details) containing individual files for each Reference Ground Track (RGT) with a date and time stamp
posted every 420 kilometers along-track (roughly 1 minute of flight time in between each point). The first RGT is 234; this is where the time series
begins. The date of each RGT is in the file name, so the user can easily ascertain where and when ICESat-2 will be on a particular day."
}
\examples{

\dontrun{

require(IceSat2R)

#................................................
# RGTs (Reference Ground Tracks) for a single day
#................................................

res_rgt_one = time_specific_orbits(date_from = '2019-06-01',
                                   date_to = '2019-06-01',
                                   download_method = 'curl',
                                   threads = 1,
                                   verbose = TRUE)
str(res_rgt_one)

#..........................................................
# RGTs (Reference Ground Tracks) for a specific time period
#..........................................................

res_rgt_many = time_specific_orbits(date_from = '2019-06-01',
                                    date_to = '2019-06-03',
                                    download_method = 'curl',
                                    threads = 1,
                                    verbose = TRUE)
str(res_rgt_many)


#.........................................................
# processing more than one RGTs for a specified date range
#.........................................................

res_rgt_inters = time_specific_orbits(date_from = '2021-03-23',
                                      date_to = '2021-03-26',
                                      download_method = 'curl',
                                      threads = 1,
                                      verbose = TRUE)
str(res_rgt_inters)

table(res_rgt_inters$cycle)
table(res_rgt_inters$day_of_year)
table(res_rgt_inters$RGT)

#...............................................................
# RGTs (Reference Ground Tracks) for a selected 'cycle'
# Observe the available RGT-cycles and use all available threads
#...............................................................

avail_cycles = available_RGTs(only_cycle_names = TRUE,
                              verbose = TRUE)
avail_cycles

choose_cycle = avail_cycles[3]

res_rgt_many = time_specific_orbits(RGT_cycle = choose_cycle,
                                    download_method = 'curl',
                                    threads = parallel::detectCores(),
                                    verbose = TRUE)
}
}
\references{
https://icesat-2.gsfc.nasa.gov/science/specs
}
