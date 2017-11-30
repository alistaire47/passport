context("Formatter function construction and country ordering")

test_that("country format construction works", {
    expect_type(country_format(),
                "closure")
    expect_s3_class(country_format(factor = TRUE)("AU"),
                    "factor")
    expect_equal(
        country_format(from = "iso3c", to = "cy")(factor(c("USA", "FRA", "CHN"))),
        structure(c(3L, 2L, 1L),
                  .Label = c("Tsieina", "Ffrainc", "UDA"),
                  class = "factor")
    )
})

test_that("country reordering works", {
    expect_equal(order_countries(c("SE", "NZ")),
                 c("NZ", "SE"))
    expect_equal(order_countries(factor(c("Sweden", "New Zealand")), by = "ja",
                                 from = 'en', short = FALSE, variant = TRUE),
                 structure(1:2, .Label = c("New Zealand", "Sweden"),
                           class = "factor"))
    expect_equal(order_countries(c("SE", "NZ", "LK"), by = c("a", "b", "a"),
                                 c(3, 1, 2), decreasing = TRUE),
                 c("NZ", "SE", "LK"))
    expect_error(order_countries(c("SE", "NZ", "LK"), 1:2),
                 "must be a length-1 country code or a vector the same length")
})
