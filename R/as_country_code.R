#' Convert standardized country names to country codes
#'
#' `as_country_code` converts a vector of standardized country names or codes to
#' country codes
#'
#' `as_country_code` takes a character, factor, or numeric vector of country
#' names or codes to translate into the specified code format. The default for
#' `to` is `"iso2c"`, the ISO 3166-1 Alpha-2 character codes, but many
#' alternatives are available.
#'
#' Several non-unique codes are available as well, including `"continent"`,
#' `"is_independent"`, ISO 4217 currency codes, etc. Backwards conversion will
#' not work for such cases.
#'
#' If converting to country names, use [as_country_name()], which offers
#' control of short and variant forms.
#'
#' See [`codes`] for all options, or run `DT::datatable(codes)` for a
#' searchable widget.
#'
#' @param x A character, factor, or numeric vector of country names or codes
#' @param from Format from which to convert. See Details for more options.
#' @param to Code format to which to convert. Defaults to `"iso2c"`; see
#'     [`codes`] for more options.
#' @param factor If `TRUE`, returns factor instead of character vector.
#'
#' @return A vector of country codes. Warns if new `NA` values are added.
#'
#' @examples
#' # Codifies standardized names
#' as_country_code(c("US", "Taiwan", "Myanmar", "Kosovo", "South Korea"), from = "en")
#'
#' # Translates codes; if passed a factor, returns a releveled one
#' as_country_code(factor(c("SAH", "PCN", "OMA", "JPN")),
#'                 from = "fifa", to = "iso4217_3c")
#'
#' @export
as_country_code <- function(x, from, to = "iso2c", factor = is.factor(x)) {
    to <- gsub("-|\\.", "_", to)
    from <- gsub("-|\\.", "_", from)

    check_parameters(x, from, to)

    convert_country(x = x, to = to, from = from, short = TRUE,
                      variant = FALSE, factor = factor)
}
