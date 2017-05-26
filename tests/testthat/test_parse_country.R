context("Parsing country names")

test_that("parsing country names with regex works", {
    expect_equal(parse_country(c('South Korea', 'United States')),
                 c('KR', 'US'))
    expect_equal(parse_country('Republic of Korea', to = 'en'),
                 "South Korea")
    expect_equal(parse_country(c("Deutschland", "\u00d6sterreich"), language = 'de'),
                 c('DE', 'AT'))
    expect_s3_class(parse_country('Taiwan, Province of China', factor = TRUE),
                    'factor')
    expect_warning(parse_country('foo'),
                   'NAs created: foo')
    expect_error(parse_country('USA', to = 'foo'),
                 'not in available code formats')
})


test_that("parsing country names with geocoding APIs works", {
    expect_equal(parse_country(c('\u65e5\u672c', 'Japon', NA, "Burma"), how = 'google'),
                 c("JP", "JP", NA, "MM"))
    expect_equal(parse_country(c('\u65e5\u672c', 'Japon', NA, "Burma"), how = 'google'),
                 c("JP", "JP", NA, "MM"))
    expect_equal(parse_country(c('\u65e5\u672c', 'Japon', NA, "Burma"),
                               to = 'en', how = 'dstk'),
                 c("Japan", "Japan", NA, "Myanmar"))
})

