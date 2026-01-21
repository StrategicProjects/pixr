# Build pkgdown documentation site
#
# Prerequisites:
#   install.packages(c("pkgdown", "devtools"))
#
# Usage:
#   source("build_site.R")

# Load required packages
library(pkgdown)
library(devtools)

# Set working directory to package root if needed
# setwd("path/to/pixr")

# Step 1: Document the package (generate Rd files from roxygen)
message("Step 1: Documenting package...")
devtools::document()

# Step 2: Build the pkgdown site
message("Step 2: Building pkgdown site...")
pkgdown::build_site()

# The site will be available in docs/ folder
# Open docs/index.html in a browser to preview

message("Done! Open docs/index.html to preview the site.")
message("To deploy to GitHub Pages, push the docs/ folder to your repository.")
