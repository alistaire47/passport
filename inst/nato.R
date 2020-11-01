#' Parse NATO defense expenditure excel file into clean dataframe
#'
#' Source website: https://www.nato.int/cps/en/natohq/news_167080.htm
#' Direct file URL: https://www.nato.int/docu/pr/2019/PR-2019-069-eng.xlsx


nato_defense_expenditure_path <- '/tmp/PR-2019-069-eng.xlsx'

download.file(
    'https://www.nato.int/docu/pr/2019/PR-2019-069-eng.xlsx',
    nato_defense_expenditure_path,
    method = 'curl'
)

df_list <- readxl::excel_sheets(nato_defense_expenditure_path)[c(-1, -4)] %>%
    map(~{
        df = readxl::read_excel(
            nato_defense_expenditure_path,
            sheet = .x, skip = if (grepl('5|7', .x)) 18 else 6,
            na = '..'
        )

        if (grepl('5', .x)) {
            df[1, 1] <- 'Real GDP (2015 prices)'
        }
        if (grepl('7', .x)) {
            df[1, 1] <- 'Military personnel (thousands)'
        }

        df
    })

nato <- df_list %>%
    map_dfr(function(df) {
        df %>%
            filter(!is.na(`...2`) | rowSums(!is.na(.)) == 1, rowSums(!is.na(.)) > 0) %>%
            fill(`...1`) %>%
            filter(!is.na(`2012`)) %>%
            rename(variable = `...1`, country_stanag = `...2`) %>%
            mutate(country_stanag = parse_country(country_stanag, to = 'stanag')) %>%
            gather(year, value, -1:-2) %>%
            mutate(year = as.integer(parse_number(year)))
    }) %>%
    spread(variable, value)

nato$`Real GDP (2015 prices)` <- nato$`Real GDP (2015 prices)` * 1000000000L
nato$`GDP per capita (thousand US dollars)` <- nato$`GDP per capita (thousand US dollars)` * 1000L
nato$`Military personnel (thousands)` <- round(nato$`Military personnel (thousands)` * 1000L)
nato$`Current prices and exchange rates` <- nato$`Current prices and exchange rates` * 1000000L
nato$`Constant 2015 prices and exchange rates` <- nato$`Constant 2015 prices and exchange rates` * 1000000L

names(nato) <- c(
    "country_stanag", "year",
    "Defense expenditure annual real change (% GDP)",
    "Defense expenditure (USD, 2015 prices)",
    "Defense expenditure (USD, current prices)",
    "Defence expenditure per capita (USD)",
    "Equipment expenditure (%)", "GDP per capita (USD)",
    "Infrastructure expenditure (%)",
    "Military personnel",
    "Other expenditure (%)", "Personnel expenditure (%)",
    "Real GDP (2015 prices)", "Defense expenditure (% real GDP)"
)

nato <- nato[, c(1, 2, 5, 4, 14, 3, 13, 8, 6, 10, 7, 12, 9, 11)]

usethis::use_data(nato, overwrite = TRUE)
