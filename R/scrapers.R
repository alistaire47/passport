library(rvest)
library(tidyverse)

# CIA World Factbook country names
country_names <- 'https://www.cia.gov/library/publications/the-world-factbook/fields/2142.html' %>%
    read_html() %>%
    html_nodes('table tr[id]') %>%
    { setNames(map(., html_nodes, 'td'), toupper(html_attr(., 'id'))) } %>%
    map_df(~data_frame(
        country = html_text(.x[1]),
        key = map(.x[2], html_nodes, css = 'strong') %>% map(html_text),
        value = map(.x[2], html_nodes, xpath = 'text()') %>%
            map(html_text, trim = TRUE) %>%
            map(discard, `==`, '')
    ), .id = 'gec') %>%
    unnest() %>%
    mutate(key = gsub(':\\s+$|`', '', key),
           key = gsub('etymolgy', 'etymology', key),
           key = gsub('official|Papiamentu', 'local', key),
           key = gsub('English', 'conventional', key),
           key = ifelse(country == 'Curacao',
                        gsub('Dutch', 'conventional', key),
                        gsub('Dutch', 'local', key)),
           country = ifelse(gec == 'AS', 'Australia', country)) %>%
    spread(key, value)


# CIA World Factbook country codes

country_codes <- 'https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html' %>%
    read_html() %>%
    html_nodes('ul#GetAppendix_D li') %>%
    map(html_nodes, css = 'td') %>%
    map(html_text, trim = TRUE) %>%
    map(~.[c(-3, -10)]) %>%
    transpose() %>%
    simplify_all() %>%
    setNames(c('country', 'gec', 'iso2c', 'iso3c', 'iso3n', 'stanag', 'internet', 'comment')) %>%
    as_data_frame() %>%
    mutate_all(na_if, y = '-') %>%
    mutate(comment = na_if(comment, ''))


# Wikipedia country codes
w <- 'https://en.wikipedia.org/wiki/Category:Lists_of_country_codes' %>%
    read_html() %>%
    html_nodes('a[title*="Country codes:"]') %>%
    html_attr('href') %>%
    paste0('https://en.wikipedia.org', .) %>%
    map(read_html) %>%
    map(html_nodes, 'h2 + table') %>%
    at_depth(2, html_nodes, 'td') %>%
    map(map_df, ~list(
        key = map(.x, html_nodes, xpath = 'a|text()') %>%
            map(html_text) %>%
            map_chr(paste, collapse = '') %>%
            trimws(),
        value = html_nodes(.x, 'p') %>% html_text()
    ), .id = 'row') %>%
    map_df(spread, key, value) %>%
    select(-row) %>%
    mutate_all(na_if, y = '—') %>%
    setNames(c('internet', 'phone', 'mcc', 'gec', 'gs1.gtin', 'icao.aircraft', 'icao.airport', 'ioc', 'iso2c', 'iso3c', 'iso3n', 'itu.callsign', 'itu.letter', 'itu.maritime', 'license.plate', 'marc', 'stanag', 'nato2c', 'undp', 'wmo'))


# Wikipedia FIFA codes
fifa <- 'https://en.wikipedia.org/wiki/List_of_FIFA_country_codes' %>%
    read_html() %>%
    html_nodes('table.wikitable') %>%
    map(html_table, fill = TRUE) %>%
    .[-7:-9] %>%    # remove obsolete codes tables
    reduce(full_join) %>%
    mutate(FIFA = coalesce(Code, FIFA)) %>%
    select(-Code, -Confederation) %>%
    mutate_all(funs(gsub('\\[.*\\]', '', .))) %>% mutate_all(na_if, y = '') %>%
    setNames(tolower(names(.))) %>% rename(iso3c = iso)


# http://unicode.org/copyright.html
# http://unicode.org/repos/cldr/trunk/unicode-license.txt

# modern
langs_modern <- 'https://github.com/unicode-cldr/cldr-localenames-modern/tree/master/main' %>%
    read_html() %>%
    html_nodes('.content span a') %>% html_text()

unicode_modern <- langs_modern %>%
    set_names(
        paste0('https://github.com/unicode-cldr/cldr-localenames-modern/raw/master/main/',
               ., '/territories.json'),
        .) %>%
    map(jsonlite::fromJSON) %>%
    map(c(1, 1, 2, 1)) %>%
    simplify_all() %>%
    map2(names(.),
         ~set_names(data_frame(names(.x), .x),
                    c('code', .y))) %>%
    reduce(full_join)

lang_codes <- 'https://github.com/unicode-cldr/cldr-localenames-modern/raw/master/main/en-US-POSIX/languages.json' %>%
    jsonlite::fromJSON() %>%
    map(c(1,2,1)) %>% .[[1]] %>%
    simplify()

lang_code_df <- data_frame(language = lang_codes,
                           code = names(lang_codes))

# parse language codes. need to standardize country names (and langs?) to Unicode.
unicode_modern[-1] %>%
    names() %>%
    NLP::parse_IETF_language_tag(expand = TRUE) %>%
    map(~map2(.x, names(.x),
              ~head(.x %||% strsplit(.y, '=')[[1]][2], 1))) %>%
    map_chr(paste, collapse = '-')
