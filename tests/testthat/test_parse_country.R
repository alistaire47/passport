context("Parsing country names")

test_that("parsing country names with regex works", {
    expect_equal(parse_country(c('South Korea', 'United States')),
                 c('KR', 'US'))
    expect_equal(parse_country('Republic of Korea', to = 'en'),
                 "South Korea")
    expect_equal(parse_country(c("Deutschland", "Österreich"), language = 'de'),
                 c('DE', 'AT'))
    expect_s3_class(parse_country('Taiwan, Province of China', factor = TRUE),
                    'factor')
    expect_warning(parse_country('foo'),
                   'NAs created: foo')
})


test_that("parsing country names with geocoding APIs works", {
    skip("Don't waste API calls")

    expect_equal(parse_country(c('日本', 'Japon', NA, "Burma"), how = 'google'),
                 c("JP", "JP", NA, "MM"))
    expect_equal(parse_country(c('日本', 'Japon', NA, "Burma"), how = 'dstk'),
                 c("JP", "JP", NA, "MM"))
    expect_equal(parse_country(c('日本', 'Japon', NA, "Burma"),
                               to = 'en', how = 'dstk'),
                 c("Japan", "Japan", NA, "Myanmar"))
})

