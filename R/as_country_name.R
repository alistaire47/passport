#' Convert standardized country codes to country names
#'
#' `as_country_name` converts a vector of standardized country codes to
#' country names.
#'
#' `as_country_name` takes a character, factor, or numeric vector of country
#' codes (or names in another standardized format) and converts them to
#' country names in the specified format. If you are trying to standardize an
#' existing set of names, see [parse_country()].
#'
#' The default `"en"` is
#' from [Unicode Common Locale Data Repository (CLDR)](http://cldr.unicode.org/),
#' which [aspires to use the most customary name](http://cldr.unicode.org/translation/country-names)
#' e.g. "Switzerland" instead of official ones, which are frequently awkward for
#' common usage, e.g. "Swiss Confederation". CLDR also supplies names in a huge
#' variety of languages, allowing for easy translation. Short and variant
#' alternates are available for some countries; if not, the function will fall
#' back to the standard form. See LICENSE file for terms of use.
#'
#' Other name sets are available from
#'
#' - [the UN Statistics Division(UNSD)](https://unstats.un.org/unsd/methodology/m49/),
#'     which maintains standardized names in English, Chinese, Russian, French,
#'     Spanish, and Arabic, here named as `"en_un"` etc.
#' - [the ISO](https://www.iso.org/home.html), `"en_iso"` and `"fr_iso"`, and
#' - [the CIA World Factbook](https://www.cia.gov/library/publications/the-world-factbook/fields/2142.html#af):
#'   - `"en_cia"`, which include many longer official forms and shorter
#' practical forms,
#'   - `"en_cia_local"`, which includes transliterations, and
#'   - `"en_cia_abbreviation"`, which includes commonly-used abbreviations.
#'
#' See [`codes`] for all options, or run `DT::datatable(codes)` for a
#' searchable widget.
#'
#'
#' @param x A character, factor, or numeric vector of country codes or names
#' @param to Language code of country names desired. Defaults to `"en"`;
#'     see [`codes`] for more options.
#' @param from Code format from which to convert. Defaults to `"iso2c"`;
#'     see [`codes`] for more options.
#' @param short Whether to use short alternative name when available. Can be
#'     length 1 or the same length as `x`.
#' @param variant Whether to use variant alternative name when available. Can
#'     be length 1 or the same length as `x`.
#' @param factor If `TRUE`, returns factor instead of character vector. If not
#'     supplied, defaults to `is.factor(x)`
#'
#' @return A character or factor vector of country names. Warns if new `NA`
#' values are added.
#'
#' @seealso For converting standardized names to codes, use [as_country_code()].
#'     For standardizing names to codes, use [parse_country()].
#'
#' @examples
#' # Usable names for tough-to-standardize places
#' as_country_name(c("US", "TW", "MM", "XK", "KR"))
#'
#' # If passed a factor, will return a releveled one
#' as_country_name(factor(c("US", "NF", "CD", "SJ")), short = FALSE, variant = TRUE)
#'
#' # Speaks a lot of languages, knows a lot of codes
#' as_country_name(c("SAH", "PCN", "OMA", "JPN"), from = "fifa", to = "cy")    # to Welsh
#'
#' @export
as_country_name <- function(x,
                             to = "en",
                             from = "iso2c",
                             short = TRUE,
                             variant = FALSE,
                             factor = is.factor(x)) {
    to <- gsub("-|\\.", "_", to)
    from <- gsub("-|\\.", "_", from)

    # check arguments
    check_parameters(x, from, to)
    if (!all(lengths(list(short, variant)) %in% c(1, length(x)))) {
        stop("The length of the `short` and `variant` parameters must be 1 or the same as the input vector.")
    }

    convert_country(x = x, to = to, from = from, short = short,
                      variant = variant, factor = factor)
}
