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
           country = ifelse(gec == 'as', 'Australia', country)) %>%
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
    mutate_all(na_if, '-') %>%
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
    mutate_all(na_if, '—') %>%
    setNames(c('internet', 'phone', 'mcc', 'gec', 'gs1.gtin', 'icao.aircraft', 'icao.airport', 'ioc', 'iso2c', 'iso3c', 'iso3n', 'itu.callsign', 'itu.letter', 'itu.maritime', 'license.plate', 'marc', 'stanag', 'nato2c', 'undp', 'wmo'))


