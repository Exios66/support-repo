hw_path_data <- function(unit = NULL, path = NULL) {
  if (!is.null(path)) {
    return(path)
  }
  if (is.null(unit)) {
    stop("Provide either 'unit' or 'path' to hw_path_data().", call. = FALSE)
  }
  file.path("HW", paste0("Unit_", unit))
}

hw_read_csv <- function(path_data, file, show_col_types = FALSE, ...) {
  if (!requireNamespace("readr", quietly = TRUE) ||
      !requireNamespace("here", quietly = TRUE)) {
    stop("Packages 'readr' and 'here' are required for hw_read_csv().", call. = FALSE)
  }
  readr::read_csv(
    here::here(path_data, file),
    show_col_types = show_col_types,
    ...
  )
}

hw_glimpse <- function(x) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for hw_glimpse().", call. = FALSE)
  }
  dplyr::glimpse(x)
}

hw_tabyl_factor <- function(df, var) {
  if (!requireNamespace("janitor", quietly = TRUE)) {
    stop("Package 'janitor' is required for hw_tabyl_factor().", call. = FALSE)
  }
  var <- rlang::enquo(var)
  janitor::tabyl(df, !!var)
}

