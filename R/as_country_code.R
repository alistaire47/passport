#' Convert standardized country names to country codes
#'
#' \code{as_country_code} converts a vector of standardized country names to
#' country codes
#'
#' Here's a placeholder of a fuller description
#'
#' @param x A vector of country names
#' @param to Code format to which to convert. Defaults to \code{"iso3c"}.
#' @param language Language of country names supplied. Defaults to \code{"en"}.
#' @param factor If \code{TRUE}, returns factor instead of character vector.
#' @param ... Other arguments passed to \code{\link[countrycode]{countrycode}}.
#'
#' @return A vector of country codes.
#'
#' @export
as_country_code <- function(
    x,
    to = c("iso3c", "ar5", "cowc", "cown", "eu28", "fao", "fips105", "icao",
           "imf", "ioc", "iso2c", "iso3n", "un", "wb", "eurostat", "wb_api2c",
           "wb_api3c", "p4_scode", "p4_ccode", "wvs"),
    language = c('en', 'ar', 'de', 'es', 'fr', 'ru', 'zh'),
    factor = FALSE,
    ...
){
    to <- match.arg(to)
    language <- match.arg(language)

    countries <- countrycode::countrycode(
        sourcevar = x,
        origin = paste0('country.name.', language),
        destination = to,
        ...
    )

    if (factor) {
        countries <- factor(countries)
    }

    countries
}