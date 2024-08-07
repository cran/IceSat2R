% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/API_utils.R
\name{download_file}
\alias{download_file}
\title{Customized function to download files}
\usage{
download_file(url, destfile, download_method, verbose = FALSE)
}
\arguments{
\item{url}{a character string specifying a valid url}

\item{destfile}{a character string specifying a valid path where the output file will be saved}

\item{download_method}{a character string specifying the download method to use. Can be one of 'internal', 'wininet' (Windows only), 'libcurl', 'wget', 'curl' or 'auto'. For more information see the documentation of the 'utils::download.file()' function}

\item{verbose}{a boolean. If TRUE then information will appear in the console}
}
\description{
Customized function to download files
}
\examples{

\dontrun{

require(IceSat2R)

# the default timeout is 60 and we set it to 600
options(timeout = 600)

# we specify a URL and a temporary file
default_url = "https://icesat-2.gsfc.nasa.gov/sites/default/"
url_downl = glue::glue('{default_url}files/page_files/IS2RGTscycle12datetime.zip')
tmp_f = tempfile(fileext = '.zip')

# then we download the file
downl_f = download_file(url = url_downl,
                        destfile = tmp_f, 
                        download_method = 'curl',
                        verbose = TRUE)
}
}
\references{
https://github.com/mlverse/torchdatasets/blob/master/R/utils.R#L20
}
