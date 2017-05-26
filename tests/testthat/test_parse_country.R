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
    skip_on_appveyor()

    expect_match(parse_country('\u65e5\u672c', how = 'google'),
                 "JP|Google Maps geocoding API call failed")
    expect_match(parse_country('\u65e5\u672c', to = 'en', how = 'dstk'),
                "Japan|Data Science Toolkit geocoding API call failed")
})

test_that("parsing non-length-1 vectors via APIs works", {
    skip_on_travis()
    skip_on_appveyor()
    skip_on_cran()

    expect_equal(parse_country(c('\u65e5\u672c', 'Japon', NA, "Burma"),
                               how = 'dstk'),
                 c("JP", "JP", NA, "MM"))
})
