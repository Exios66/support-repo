hw_check_packages <- function(pkgs) {
  pkgs <- as.character(pkgs)
  installed <- pkgs %in% rownames(installed.packages())
  tibble::tibble(
    package = pkgs,
    installed = installed
  )
}

hw_safe_read_csv <- function(path_data, file, show_col_types = FALSE, ...) {
  full_path <- here::here(path_data, file)
  if (!file.exists(full_path)) {
    stop(
      sprintf("File not found at '%s'. Check your 'path_data' and 'file' arguments.", full_path),
      call. = FALSE
    )
  }
  hw_read_csv(path_data = path_data, file = file, show_col_types = show_col_types, ...)
}

hw_seed <- function(seed) {
  stopifnot(length(seed) == 1L)
  set.seed(seed)
  invisible(seed)
}

