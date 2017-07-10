context("Converting country names")

test_that("converting codes to names works", {
    skip_on_appveyor()

    expect_equal(as_country_name(c("TW", "KR", "UY")),
                 c("Taiwan", "South Korea", "Uruguay"))
    expect_equal(as_country_name(c("YE", "KR", "UY"), to = "es"),
                 c("Yemen", "Corea del Sur", "Uruguay"))
    expect_equal(as_country_name(c(124L, 203L, 626L), from = "iso3n"),
                 c("Canada", "Czechia", "Timor-Leste"))
    expect_equal(as_country_name(c("US", "GB"), short = FALSE),
                 c("United States", "United Kingdom"))
    expect_equal(as_country_name(c("CI", "CZ", "TL"), variant = TRUE),
                 c("Ivory Coast", "Czech Republic", "East Timor"))
    expect_equal(as_country_name(c("US", "GB", "CG", "CD"),
                                 short = c(FALSE, TRUE, TRUE, TRUE),
                                 variant = c(FALSE, FALSE, FALSE, TRUE)),
                 c("United States", "UK", "Congo - Brazzaville", "Congo (DRC)"))
    expect_s3_class(as_country_name(factor(c("CI", "CZ", "TL"))),
                    "factor")
    expect_message(as_country_name(c("GB", "FR"), to = "continent"),
                   "Multiple unique values aggregated to single output")
    expect_error(as_country_name(list("US")),
                 "Input is not an atomic vector")
    expect_error(as_country_name("US", from = "foo"),
                 "not in available formats")
    expect_error(as_country_name("US", to = "foo"),
                 "not in available formats")
    expect_error(as_country_name(c("CI", "CZ", "TL"), variant = c(TRUE, FALSE)),
                 "must be 1 or the same as the input vector")
})
