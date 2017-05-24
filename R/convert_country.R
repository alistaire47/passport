#' @importFrom stats setNames
#'

convert_country <- function(x, to, from, short, variant, factor) {
    # preprocess into factor so as to only operate on levels
    if (!is.factor(x)) {
        x <- factor(x)
    }
    x_levels <- levels(x)

    # collapse vector flags to levels
    x_level_index <- match(x_levels, x)
    if (length(short) > 1) { short <- short[x_level_index] }
    if (length(variant) > 1) { variant <- variant[x_level_index] }

    # convert names
    countries <- countries[countries[[from]] %in% x,
                           c('alt', from, to)]    # filter countries

    # fill short and variant names
    countries_sub <- countries[
        Reduce(`|`, Map(
            function(country, s, v){
                countries[[from]] == country & (countries$alt == s | countries$alt == v)
            },
            country = x_levels,
            s = ifelse(short, 'short', NA),
            v = ifelse(variant, 'variant', NA)
        )),
        c(to, from)]

    new_levels <- setNames(countries_sub[[to]], countries_sub[[from]])[x_levels]

    # fill non-alternate names
    countries_sub <- countries[countries[[from]] %in% x_levels[is.na(new_levels)] &
                                   is.na(countries$alt),
                               c(to, from)]

    new_levels[is.na(new_levels)] <- setNames(
        countries_sub[[to]],
        countries_sub[[from]]
    )[x_levels[is.na(new_levels)]]

    if (length(new_levels) != length(unique(new_levels))) {
        message('Multiple unique values aggregated to single output')
    }

    levels(x) <- new_levels

    # warn if NAs created
    new_na <- is.na(new_levels) & !is.na(x_levels)
    if (any(new_na)) {warning(paste('NAs created:', toString(x_levels[new_na])))}

    if (factor) {
        return(droplevels(x))
    }
    as.character(x)
}
