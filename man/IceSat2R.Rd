% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IceSat2R.R
\name{IceSat2R}
\alias{IceSat2R}
\title{The "IceSat2R" package}
\description{
An important aspect of the "IceSat2R" (https://cran.r-project.org/web/packages/IceSat2R/index.html) package is that it includes the code, documentation, and
examples so that users can retrieve, process, and analyze data based on specific workflows.
}
\details{
For instance,

\itemize{
  \item A user can select an "area of interest" (AOI) either programmatically or interactively
  \item If the "Reference Ground Track" (RGT) is not known, the user has the option to utilize either
    \enumerate{
      \item one of the "overall_mission_orbits()" or "time_specific_orbits()" to compute the RGT(s) for a pre-specified global area or for a time period, or
      \item one of the "vsi_nominal_orbits_wkt()" or "vsi_time_specific_orbits_wkt()" to compute the RGT(s) for a specific AOI
    }
  \item Once the RGT is computed it can be verified with the "getTracks()" function of the "OpenAltimetry Web API" (https://openaltimetry.org/data/swagger-ui/)
  \item Finally the user can utilize one of the "get_atlas_data()" or "get_level3a_data()" functions to retrieve the data for specific product(s), Date(s) and Beam(s)
}

This work-flow is illustrated also in a \href{https://raw.githubusercontent.com/mlampros/IceSat2R/master/inst/joss_paper/figures/icesat_2_diagram.png}{diagram}
}
