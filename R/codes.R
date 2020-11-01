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
#' @format A data.frame of 427 rows and 9 variables.
#'
#' Variables:
#'
#' \describe{
#'     \item{`column`}{The column name in the internal `passport:::countries`
#'     data.frame. Valid for use in `from` and `to` parameters.}
#'     \item{`code`}{`column` with hyphens for underscores, which is a valid IANA
#'     language tag for Unicode CLDR country names. Valid for use in `from` and
#'     `to` parameters.}
#'     \item{`name`}{Full name or code name for non-CLDR options.}
#'     \item{`notes`}{Things to note, including deprecations, oddities, etc.}
#'     \item{`language`}{Full language name parsed from `code`.}
#'     \item{`region`}{Full country or region name parsed from `code`.}
#'     \item{`script`}{Full language script name parsed from `code`.}
#'     \item{`variant`}{Full variant parsed from `code`. Also used for
#'     organization-standardized names.}
#'     \item{`extension`}{Further specification of name type.}
#' }
#'
#'
#' @examples
#' # A searchable widget to find a code or name
#' if (requireNamespace("DT", quietly = TRUE)) {
#'     DT::datatable(codes)
#' }
"codes"
