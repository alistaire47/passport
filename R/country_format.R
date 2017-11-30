#' Construct formatter function to format country codes as country names
#'
#' `country_format` is a constructor function that returns a function
#' to format country codes as country names suitable for passing to ggplot2's
#' scale functions' `label` parameters.
#'
#' A frequent reason to convert country codes back to country names is to make
#' data visualizations more readable. While both a code and name could be
#' stored in a data frame, the computation and extra storage required can be
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
#' @seealso For controlling the order of a discrete scale, pass the results of
#'     [order_countries()] to `limits`.
#'
#' @examples
#' if (require(ggplot2, quietly = TRUE)) {
#'     ggplot(data.frame(country = c("KOR", "MMR", "TWN", "COG"),
#'                       y = 1:4),
#'            aes(x = country, y = y)) +
#'         geom_col() +
#'         scale_x_discrete(labels = country_format(from = "iso3c"))
#' }
#'
#' @export
country_format <- function(from = "iso2c",
                           to = "en",
                           short = TRUE,
                           variant = FALSE,
                           factor) {
    missing_factor <- missing(factor)

    function(x) {
        if (missing_factor) {
            factor <- is.factor(x)
        }

        as_country_name(x,
                        from = from, to = to,
                        short = short, variant = variant,
                        factor = factor)
    }
}

#' Order a vector of countries
#'
#' `order_countries` reorders a vector of countries, returning a result useful
#' for passing to ggplot2's scale functions' `limits` parameters.
#'
#' `order_countries` orders a vector of countries by
#' - itself converted to a country code or name if `by` is a code from [`codes`]
#' to which to convert
#' - a sortable vector if `by` is a vector of the same length as `x`
#' - `x` itself if neither is supplied.
#'
#' @inheritParams as_country_name
#' @param by Either a length-one country code from [`codes`] or a vector the
#'     same length as `x` by which to order `x`
#' @param ... Parameters passed on to [order()], including addition vectors by
#'     which to sort, `decreasing`, and `na.last`.
#'
#' @return The original vector of countries, ordered according to the parameters
#'     passed. Note that factors are not releveled, but are reordered. To
#'     relevel, pass the results to [levels<-()]
#'
#' @seealso To change labels of a discrete scale, pass the results of
#'     [country_format()] to the `labels` parameter.
#'
#' @examples
#' countries <- c("FR", "CP", "UZ", "BH", "BR")
#'
#' order_countries(countries)
#'
#' order_countries(countries, "ja")
#'
#' order_countries(countries, rnorm(5))
#'
#' order_countries(countries, grepl("F", countries), 1:5, decreasing = TRUE)
#'
#' if (require(ggplot2, quietly = TRUE)) {
#'     df_countries <- data.frame(country = countries,
#'                                y = exp(1:5))
#'
#'     ggplot(df_countries, aes(country, y)) +
#'         geom_col() +
#'         scale_x_discrete(
#'             limits = order_countries(df_countries$country,
#'                                      df_countries$y)[df_countries$y > 5],
#'             labels = country_format(to = "en-cia-local")
#'         )
#' }
#'
#' @export
order_countries <- function(x,
                            by,
                            ...,
                            from = "iso2c",
                            short = TRUE,
                            variant = FALSE,
                            factor = is.factor(x)) {
    missing_by <- missing(by)
    if (!missing_by) {
        if (length(by) == 1) {
            to <- by
            missing_to <- FALSE
            check_parameters(x, from, to)
        } else if (length(x) == length(by)) {
            missing_to <- TRUE
        } else {
            stop("`by` must be a length-1 country code or a vector the same length as `x`")
        }
    } else {
        missing_to <- TRUE
    }

    if (!missing_to) {
        x[order(as_country_name(x = x, to = to, from = from,
                                short = short, variant = variant,
                                factor = factor),
                ...)]
    } else if (!missing_by) {
        x[order(by, ...)]
    } else {
        x[order(x, ...)]
    }
}
