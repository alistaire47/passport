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
#' of factors (like all passport functions).
#'
#' The regex are from
#' [countrycode](https://github.com/vincentarelbundock/countrycode), whose
#' authors deserve full credit and to whom you should submit regex in
#' more languages if you would like to extend these packages.
#'
#' @inheritParams as_country_name
#' @param x A character or factor vector of country names to standardize
#' @param to Format to which to convert. Defaults to `"iso2c"`; see [`codes`]
#'     for more options.
#' @param language Language from which to parse country names. Currently
#' accepts `"en"` (default) and `"de"`.
#'
#' @return A character vector or factor of ISO 2-character country codes or
#' other specified codes or names. Warns of any parsing failure.
#'
#' @examples
#' parse_country(c('United States', 'USA', 'U.S.', 'us', 'United States of America'))
#' #> [1] "US" "US" "US" "US" "US"
#'
#' @export
parse_country <- function(x,
                          to = 'iso2c',
                          language = c('en', 'de'),
                          factor = is.factor(x)) {
    # parameter checking
    to <- gsub('-|\\.', '_', to)
    if (!to %in% countries_colnames) {
        stop(paste(to, 'not in available code formats.'))
    }
    language <- paste0(match.arg(language), '_regex')

    if (!is.factor(x)) {
        x <- factor(x)
    }

    x_levels <- levels(x)

    countries <- countries[is.na(countries$alt) & !is.na(countries[[language]]),
                           c(language, to)]

    x_mat <- do.call(rbind, lapply(countries[[language]], grepl, x_levels,
                                   ignore.case = TRUE, perl = TRUE))
    new_levels <- if (sum(x_mat) == 0) {
        rep(NA_character_, length(x_levels))
    } else {
        sapply(apply(x_mat, 2, which), function(i){
            country <- countries[i,][[to]]
            ifelse(length(country) == 0, NA_character_, country)
        })
    }

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
