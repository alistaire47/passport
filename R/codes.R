#' Country code and name details and documentation
#'
#' A codebook data.frame of codes and details for country code and name
#' conversions available. Contains
#' [Internet Engineering Task Force (IETF) language tags](https://en.wikipedia.org/wiki/IETF_language_tag)
#' (e.g. `"en-nz"` for New Zealand English) for
#' [Unicode Common Locale Data Repository (CLDR)](http://cldr.unicode.org/) names,
#' similar approximations for institutional names (e.g. `"en-iso"`), and short
#' names (e.g. `"iso2c"`) for country codes.
#'
#' All functions can accept codes separated with underscores `_`, hyphens `-`,
#' or periods `.`.
#'
#' @format A data.frame of 393 rows and 9 variables.
#'
#' Structure:
#'
#' - `column`: The column name in the internal `passport:::countries`
#'     data.frame. Valid for use in `from` and `to` parameters.
#' - `code`: `column` with hyphens for underscores, which is a valid IANA
#'     language tag for Unicode CLDR country names. Valid for use in `from` and
#'     `to` parameters.
#' - `name`: Full name or code name for non-CLDR options.
#' - `notes`: Things to note, including deprecations, oddities, etc.
#' - `language`: Full language name parsed from `code`.
#' - `region`: Full country or region name parsed from `code`.
#' - `script`: Full language script name parsed from `code`.
#' - `variant`: Full variant parsed from `code`. Also used for
#'     organization-standardized names.
#' - `extension`: Further specification of name type.
#'
#' @examples
#' # A searchable widget to find a code or name
#' if (requireNamespace("DT", quietly = TRUE)) {
#'     DT::datatable(codes)
#' }
"codes"
