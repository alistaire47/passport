# passport 0.2.0

* Add `order_countries()` to make sorting vectors of countries simpler, 
    particularly when passed to the `limits` parameter of a ggplot2 discrete 
    scale.
    
* Change `country_format()` to accept a `factor` parameter along to 
    `as_country_name()`.

* Update documentation and tests to account for DSTK downtime.

# passport 0.1.1

* Added a `NEWS.md` file to track changes to the package.

* Added option to use geocoding web APIs to supercharge `parse_country()`.

* Added `convert_country()` constructor for ggplot2 convenience.

* Added essential API for converting between country names and codes.
