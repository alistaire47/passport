#' Construct formatter function to format country codes as country names
#'
#' `country_format` is a constructor function that returns a function
#' to format country codes as country names suitable for passing to ggplot2's
#' scale functions' `label` parameter.
#'
#' A frequent reason to convert country codes back to country names is to make
#' data visualizations more readable. While both a code and name could be
#' stored in a data.frame, the computation and extra storage required can be
#' avoided by transforming codes to names directly within the visualization via
#' a formatter function. [as_country_name()] could be used without
#' parentheses to format ISO 2-character codes as English names, but
#' `format_country` allows greater flexibility, returning a formatter
#' function with the specified parameters set.
#'
#' @inheritParams as_country_name
#'
#' @return A function that accepts a vector of country codes and returns them
#' as country names.
#'
#' @examples
#' if (require(ggplot2)) {
#'
#' ggplot(data.frame(iso3c = c("KOR", "MMR", "TWN", "COG"),
#'                   value = 1:4),
#'        aes(x = iso3c, y = value)) +
#'     geom_col() +
#'     scale_x_discrete(labels = country_format('iso3c'))
#' }
#' @export
country_format <- function(
    from = 'iso2c',
    to = 'en',
    short = TRUE,
    variant = FALSE
){
    function(x){
        as_country_name(x, from = from, to = to, short = short,
                        variant = variant, factor = TRUE)
    }
}