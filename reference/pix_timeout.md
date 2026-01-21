# Get or Set API Request Timeout

Get or set the timeout for API requests. The default timeout is 120
seconds. The BCB API can be slow for large queries, so a generous
timeout is recommended.

## Usage

``` r
pix_timeout(seconds = NULL)
```

## Arguments

- seconds:

  Integer; timeout in seconds. If NULL, returns the current timeout.

## Value

- `pix_timeout()`: Returns the current timeout in seconds (invisibly
  when setting).

- When called with `seconds`, sets the timeout and returns the new value
  invisibly.

## Examples

``` r
# Get current timeout
pix_timeout()
#> [1] 120

# Set timeout to 180 seconds (3 minutes)
pix_timeout(180)
#> ✔ Timeout set to 180 seconds

# Set timeout to 60 seconds
pix_timeout(60)
#> ✔ Timeout set to 60 seconds

# Reset to default (120 seconds)
pix_timeout(120)
#> ✔ Timeout set to 120 seconds
```
