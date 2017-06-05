context("Coding country names")

test_that("coding countries works", {
    test_countries <- c("Taiwan", "South Korea", "Uruguay")
    expect_equal(as_country_code(test_countries, from = 'en'),
                 c("TW", "KR", "UY"))
    expect_equal(as_country_code(test_countries, from = 'en', to = 'stanag'),
                 c("TWN", "KOR", "URY"))
    expect_s3_class(as_country_code(test_countries, from = 'en', factor = TRUE),
                    'factor')
    expect_warning(as_country_code('foo', from = 'en'),
                   'NAs created: foo')
    expect_error(as_country_code(list(), 'en'),
                 'Input is not an atomic vector')
    expect_error(as_country_code('US', from = 'foo'),
                 'not in available formats')
    expect_error(as_country_code('US', from = 'iso2c', to = 'foo'),
                 'not in available formats')
})
