#' Convert standardized country codes to country names
#'
#' \code{as_country_name} converts a vector of standardized country codes to
#' country names.
#'
#' Here's a placeholder of a fuller description
#'
#' @param x A vector of country codes
#' @param from Code format from which to convert. Defaults to \code{"iso3c"}.
#' @param language Language of country names desired. Defaults to \code{"en"}.
#' @param factor If \code{TRUE}, returns factor instead of character vector.
#' @param ... Other arguments passed to \code{\link[countrycode]{countrycode}}.
#'
#' @return A vector of country names.
#'
#' @export
as_country_name <- function(
    x,
    from = c("iso3c", "cowc", "cown", "eurostat", "fao", "fips105", "imf",
             "ioc", "iso2c", "iso3n", "p4_ccode", "p4_scode", "un", "wb",
             "wb_api2c", "wb_api3c", "wvs"),
    language = c('en', 'ar', 'de', 'es', 'fr', 'ru', 'zh'),
    factor = FALSE,
    ...
){
    from <- match.arg(from)
    language <- match.arg(language)

    countries <- countrycode::countrycode(
        sourcevar = x,
        origin = from,
        destination = paste0('country.name.', language),
        ...
    )

    if (factor) {
        countries <- factor(countries)
    }

    countries
}