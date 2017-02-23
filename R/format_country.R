#' Construct formatter function to format country codes as country names
#'
#' \code{format_country} is a constructor function that returns a function
#' to format country codes as country names suitable for passing to ggplot2's
#' scale functions' \code{label} parameter.
#'
#' A frequent reason to convert country codes back to country names is to make
#' data visualizations more readable. While both a code and name could be
#' stored in a data.frame, the computation and extra storage required can be
#' avoided by transforming codes to names directly within the visualization via
#' a formatter function. \code{\link{as_country_name}} could be used without
#' parentheses to format ISO 3-character codes as English names, but
#' \code{format_country} allows greater flexibility, returning a formatter
#' function with the specified parameters set.
#'
#' @param from Code format from which to convert. Defaults to \code{"iso3c"}.
#' @param language Language of country names desired. Defaults to \code{"en"}.
#' @param ... Other arguments passed to \code{\link{as_country_name}} and
#' \code{\link[countrycode]{countrycode}}.
#'
#' @return A function that accepts a vector of country codes and returns them
#' as country names.
#'
#' @examples
#' ggplot(data.frame(iso3c = c("KOR", "MMR", "TWN", "COG"),
#'                   value = 1:4),
#'        aes(x = iso3c, y = value)) +
#'     geom_col() +
#'     scale_x_discrete(labels = format_country())
#' @export
format_country <- function(
    from = c("iso3c", "cowc", "cown", "eurostat", "fao", "fips105", "imf",
             "ioc", "iso2c", "iso3n", "p4_ccode", "p4_scode", "un", "wb",
             "wb_api2c", "wb_api3c", "wvs"),
    language = c('en', 'ar', 'de', 'es', 'fr', 'ru', 'zh'),
    factor = TRUE,
    ...
){
    function(x){
        as_country_name(x, from = from, language = language, ...)
    }
}