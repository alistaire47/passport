convert_countries <- function(x, to, from, short, variant, factor) {
    # preprocess into factor so as to only operate on levels
    if (!is.factor(x)) {
        x <- factor(x)
    }
    x_levels <- levels(x)

    # convert names
    countries <- countries:::countries[countries:::countries[[from]] %in% x,
                                       c('alt', from, to)]    # filter countries

    # fill short and variant names
    countries_sub <- countries[Reduce(`|`, Map(function(country, s, v){
        s <- ifelse(s, 'short', NA)
        v <- ifelse(v, 'variant', NA)
        countries[[from]] == countries & (countries$alt == s | countries$alt == v)
    }, x_levels, short, variant)), c(to, from)]

    new_levels <- setNames(countries_sub[[to]], countries_sub[[from]])[x_levels]

    # fill non-alternate names
    countries_sub <- countries[countries[[from]] %in% x_levels[is.na(new_levels)] &
                                   is.na(countries$alt), c(to, from)]

    new_levels[is.na(new_levels)] <- setNames(
        countries_sub[[to]],
        countries_sub[[from]]
    )[x_levels[is.na(new_levels)]]

    levels(x) <- new_levels

    # warn if NAs created
    new_na <- is.na(new_levels) & !is.na(x_levels)
    if (any(new_na)) {warning(paste('NAs created:', toString(x_levels[new_na])))}

    if (factor) {
        return(droplevels(x))
    }
    as.character(x)
}

#' Convert standardized country codes to country names
#'
#' `as_country_name` converts a vector of standardized country codes to
#' country names.
#'
#' Here's a placeholder of a fuller description
#'
#' @param x A character, factor, or numeric vector of country codes
#' @param to Language code of country names desired. Defaults to `"en"`;
#'     see Details for more options.
#' @param from Code format from which to convert. Defaults to `"iso2c"`;
#'     see Details for more options.
#' @param short Whether to use short alternative name when available. Can be
#'     length 1 or the same length as `x`.
#' @param variant Whether to use variant alternative name when available. Can
#'     be length 1 or the same length as `x`.
#' @param factor If `TRUE`, returns factor instead of character vector.
#'
#' @return A character or factor vector of country names.
#'
#' @export
as_country_name <- function(x,
                             to = 'en',
                             from = 'iso2c',
                             short = TRUE,
                             variant = FALSE,
                             factor = is.factor(x)) {
    to <- gsub('-|\\.', '_', to)
    from <- gsub('-|\\.', '_', from)

    # check arguments
    if (!class(x) %in% c('character', 'factor', 'integer', 'numeric')) {
        stop('Input is not an atomic vector.')
    }
    if (!to %in% countries:::countries_colnames) {
        stop(paste(to, 'not in available name formats.'))
    }
    if (!from %in% countries:::countries_colnames) {
        stop(paste(from, 'not in available code formats.'))
    }
    if (!all(sapply(list(short, variant), length) %in% c(1, length(x)))) {
        stop('The length of the `short` and `variant` parameters must be 1 or the same as the input vector.')
    }

    convert_countries(x = x, to = to, from = from, short = short,
                      variant = variant, factor = factor)
}
