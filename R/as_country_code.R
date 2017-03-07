#' Convert standardized country names to country codes
#'
#' `as_country_code` converts a vector of standardized country names to
#' country codes
#'
#' Here's a placeholder of a fuller description
#'
#' @param x A character, factor, or numeric vector of country names or codes
#' @param from Format from which to convert. See Details for more options.
#' @param to Code format to which to convert. Defaults to `"iso2c"`; see
#'     Details for more options.
#' @param factor If `TRUE`, returns factor instead of character vector.
#'
#' @return A vector of country codes.
#'
#' @export
as_country_code <- function(x, from, to = 'iso2c', factor = is.factor(x)) {
    to <- gsub('-|\\.', '_', to)
    from <- gsub('-|\\.', '_', from)

    # check arguments
    if (!class(x) %in% c('character', 'factor', 'integer', 'numeric')) {
        stop('Input is not an atomic vector.')
    }
    if (!to %in% countries:::countries_colnames) {
        stop(paste(to, 'not in available code formats.'))
    }
    if (!from %in% countries:::countries_colnames) {
        stop(paste(from, 'not in available name formats.'))
    }

    convert_countries(x = x, to = to, from = from, short = TRUE,
                      variant = FALSE, factor = factor)
}