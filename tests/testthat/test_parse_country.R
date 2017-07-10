context("Parsing country names")

test_that("parsing country names with regex works", {
    expect_equal(parse_country(c("South Korea", "United States")),
                 c("KR", "US"))
    expect_equal(parse_country("Republic of Korea", to = "en"),
                 "South Korea")
    expect_equal(parse_country(c("Deutschland", "\u00d6sterreich"),
                               language = "de"),
                 c("DE", "AT"))
    expect_s3_class(parse_country("Taiwan, Province of China", factor = TRUE),
                    "factor")
    expect_warning(parse_country("foo"),
                   "NAs created: foo")
    expect_error(parse_country("USA", to = "foo"),
                 "not in available code formats")
})

test_that("parsing JSON works", {
    response_json <- '{"results":[{"geometry":{
        "location":{"lat":63.06933,"lng":-151.00609},
        "viewport":{"southwest":{"lat":null,"lng":null},
                    "northeast":{"lat":null,"lng":null}},
        "location_type":"APPROXIMATE"},
        "address_components":[{
            "short_name":"US",
            "long_name":"USA",
            "types":["country","political"]}],
        "types":[null,"political"]}],
    "status":"OK"} '

    expect_equal({
        response <- passport:::fromJSON(response_json)
        address_components <- response$results$address_components[[1]];
        address_components$short_name[vapply(address_components$types,
                                             function(t) { "country" %in% t },
                                             logical(1))]
        },
        "US")
})

test_that("parsing country names with simulated geocoding APIs works", {
    expect_error(
        with_mock(
            requireNamespace = function(...) { FALSE },
            parse_country("Sverige", how = "dstk")
        ),
        "jsonlite"
    )
    expect_error(
        mockr::with_mock(
            fromJSON = function(...) { list(status = "not OK") },
            parse_country("Sverige", how = "dstk")
        ),
        "not OK"
    )
    expect_equal(
        mockr::with_mock(
            fromJSON = function(...) {
                list(results = list(address_components = list(
                    list(short_name = "SE", types = "country")
                )), status = "OK")
            },
            parse_country("Sverige", to = "en", how = "dstk")),
        "Sweden"
    )
    expect_s3_class(
        mockr::with_mock(
            fromJSON = function(...) {
                list(results = list(address_components = list(
                    list(short_name = "SE", types = "country")
                )), status = "OK")
            },
            parse_country(factor("Sverige"), how = "dstk")),
        "factor"
    )
    expect_equal(
        mockr::with_mock(
            fromJSON = function(...) {
                list(results = list(address_components = list(
                    list(short_name = "SE", types = "country")
                )), status = "OK")
            },
            parse_country(c("Sverige", "Sweden"), how = "google")),
        c("SE", "SE"))
})

test_that("parsing country names with live geocoding APIs works", {
    skip_on_travis()
    skip_on_appveyor()
    skip_on_cran()

    expect_equal(parse_country("\u65e5\u672c", how = "google"),
                 "JP")
    expect_equal(parse_country("\u65e5\u672c", to = "en", how = "dstk"),
                "Japan")
    expect_equal(parse_country(c("\u65e5\u672c", "Japon", NA, "Burma"),
                               how = "dstk"),
                 c("JP", "JP", NA, "MM"))
})
