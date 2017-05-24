context("Formatter function construction")

test_that("country format construction works", {
    expect_type(country_format(),
                'closure')
    expect_s3_class(country_format()('AU'),
                    'factor')
    expect_equal(country_format(from = 'iso3c', to = 'ja')(c('USA', 'FRA', 'CHN')),
                 structure(c(3L, 2L, 1L),
                           .Label = c("中国", "フランス", "アメリカ"),
                           class = "factor"))
})