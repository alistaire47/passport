#' Parse country names to standardized form
#'
#' \code{parse_country} parses country names to the standardized ISO
#' 3-character code.
#'
#' Here's a placeholder of a fuller description
#'
#' @param x A character vector of country names.
#' @param to Output format, defaults to \code{"iso3c"}.
#' @param language Language from which to parse country names. Currently
#' accepts \code{"en"} (default) and \code{"de"}.
#' @param factor If \code{TRUE}, returns factor instead of character vector.
#' @param ... Other arguments passed to \code{\link[countrycode]{countrycode}}.
#'
#' @return A character vector of ISO 3-character country codes, unless
#' \code{factor = TRUE}. Warns of any parsing failure.
#'
#' @export
parse_country <- function(
    x,
    to = c("iso3c", "ar5", "continent", "cowc", "cown", "eu28",
           "eurocontrol_pru", "eurocontrol_statfor", "fao", "fips105", "icao",
           "icao_region", "imf", "ioc", "iso2c", "iso3n", "region", "un", "wb",
           "country.name.ar", "country.name.de", "country.name.en",
           "country.name.es", "country.name.fr", "country.name.ru",
           "country.name.zh", "eurostat", "wb_api2c", "wb_api3c", "p4_scode",
           "p4_ccode", "wvs"),
    language = c('en', 'de'),
    factor = FALSE,
    ...
){
    to <- match.arg(to)
    language <- match.arg(language)

    countries <- countrycode::countrycode(
        sourcevar = x,
        origin = c('en' = 'country.name.en',
                   'de' = 'country.name.de')[language],
        destination = to,
        ...
    )

    if (factor) {
        countries <- factor(countries)
    }

    countries
}