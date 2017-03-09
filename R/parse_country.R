#' Parse country names to standardized form
#'
#' `parse_country` parses irregular country names to the ISO 3166-1 Alpha-2 code
#' or other standardized code or name format.
#'
#' `parse_country` tries to parse a character or factor vector of country names
#' to a standardized form: by default, ISO 3166-1 Alpha-2 codes. It uses regular
#' expressions, and thus is likely to be slower than [as_country_name()] or
#' [as_country_code()], but unless the data contains a very large number of
#' alternatives is still likely to be reasonably quick due to its internal use
#' of factors (like all countries functions).
#'
#' The regex are from
#' [countrycode](https://github.com/vincentarelbundock/countrycode), whose
#' authors deserve enormous credit, and to whom I suggest you submit regex in
#' more languages if you would like to extend these packages.
#'
#' @inheritParams as_country_name
#' @param x A character or factor vector of country names to standardize
#' @param to Format to which to convert. Defaults to `"iso2c"`; see [`codes`]
#'     for more options.
#' @param language Language from which to parse country names. Currently
#' accepts `"en"` (default) and `"de"`.
#'
#' @return A character vector of ISO 3-character country codes, unless
#' \code{factor = TRUE}. Warns of any parsing failure.
#'
#' @examples
#' parse_country(c('United States', 'USA', 'US', 'us', 'United States of America'))
#' #> [1] "US" "US" "US" "US" "US"
#'
#' @export
parse_country <- function(x,
                          to = 'iso2c',
                          language = c('en', 'de'),
                          short = TRUE,
                          variant = FALSE,
                          factor = is.factor(x)) {
    # parameter checking
    to <- gsub('-|\\.', '_', to)
    if (!to %in% countries:::countries_colnames) {
        stop(paste(to, 'not in available code formats.'))
    }
    language <- paste0(match.arg(language), '_regex')
    if (!all(sapply(list(short, variant), length) %in% c(1, length(x)))) {
        stop('The length of the `short` and `variant` parameters must be 1 or the same as the input vector.')
    }

    if (!is.factor(x)) {
        x <- factor(x)
    }

    x_levels <- levels(x)

    # collapse vector flags to levels
    x_level_index <- match(x_levels, x)
    if (length(short) > 1) { short <- short[x_level_index] }
    if (length(variant) > 1) { variant <- variant[x_level_index] }

    countries <- countries:::countries
    countries_sub <- countries[!is.na(countries[[language]]), c('alt', language, to)]

    x_mat <- do.call(rbind, lapply(countries_sub[[language]], grepl, x_levels,
                                   ignore.case = TRUE, perl = TRUE))
    countries_sub_list <- lapply(apply(x_mat, 2, which), function(i){countries_sub[i,]})
    new_levels <- mapply(function(country, s, v){
        i <- 1
        if (s & 'short' %in% country$alt) { i <- which(country$alt == 'short') }
        if (v & 'variant' %in% country$alt) { i <- which(country$alt == 'variant') }
        country[[to]][i]
    }, countries_sub_list, short, variant)

    levels(x) <- new_levels

    new_na <- is.na(new_levels) & !is.na(x_levels)
    if (any(new_na)) {
        warning(paste('NAs created:', toString(x_levels[new_na])))
    }

    if (factor) {
        return(droplevels(x))
    }
    as.character(x)
}
