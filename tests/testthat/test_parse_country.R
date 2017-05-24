context("Parsing country names")

test_that("parsing country names works", {
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

