% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/country_format.R
\name{country_format}
\alias{country_format}
\title{Construct formatter function to format country codes as country names}
\usage{
country_format(
  from = "iso2c",
  to = "en",
  short = TRUE,
  variant = FALSE,
  factor
)
}
\arguments{
\item{from}{Code format from which to convert. Defaults to \code{"iso2c"};
see \code{\link{codes}} for more options.}

\item{to}{Language code of country names desired. Defaults to \code{"en"};
see \code{\link{codes}} for more options.}

\item{short}{Whether to use short alternative name when available. Can be
length 1 or the same length as \code{x}.}

\item{variant}{Whether to use variant alternative name when available. Can
be length 1 or the same length as \code{x}.}

\item{factor}{If \code{TRUE}, returns factor instead of character vector. If not
supplied, defaults to \code{is.factor(x)}}
}
\value{
A function that accepts a vector of country codes and returns them
as country names.
}
\description{
\code{country_format} is a constructor function that returns a function
to format country codes as country names suitable for passing to ggplot2's
scale functions' \code{label} parameters.
}
\details{
A frequent reason to convert country codes back to country names is to make
data visualizations more readable. While both a code and name could be
stored in a data frame, the computation and extra storage required can be
avoided by transforming codes to names directly within the visualization via
a formatter function. \code{\link[=as_country_name]{as_country_name()}} could be used without
parentheses to format ISO 2-character codes as English names, but
\code{format_country} allows greater flexibility, returning a formatter
function with the specified parameters set.
}
\examples{
if (require(ggplot2, quietly = TRUE)) {
    ggplot(data.frame(country = c("KOR", "MMR", "TWN", "COG"),
                      y = 1:4),
           aes(x = country, y = y)) +
        geom_col() +
        scale_x_discrete(labels = country_format(from = "iso3c"))
}

}
\seealso{
For controlling the order of a discrete scale, pass the results of
\code{\link[=order_countries]{order_countries()}} to \code{limits}.
}
