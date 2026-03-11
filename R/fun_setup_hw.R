hw_load_core_packages <- function() {
  pkgs <- c(
    "tidyverse",
    "tidymodels",
    "future",
    "xfun",
    "janitor",
    "here"
  )
  to_load <- pkgs[!pkgs %in% loadedNamespaces()]
  for (p in to_load) {
    suppressPackageStartupMessages(require(p, character.only = TRUE))
  }
  invisible(pkgs)
}

hw_set_conflicts <- function() {
  options(conflicts.policy = "depends.ok")
  if (requireNamespace("conflicted", quietly = TRUE) &&
      requireNamespace("Matrix", quietly = TRUE)) {
    conflicted::conflictRules(
      "Matrix",
      mask.ok = c("expand", "pack", "unpack")
    )
  }
  invisible(NULL)
}

hw_enable_parallel <- function(workers = NULL) {
  if (!requireNamespace("future", quietly = TRUE)) {
    stop("Package 'future' is required for hw_enable_parallel().", call. = FALSE)
  }
  if (is.null(workers)) {
    workers <- parallel::detectCores(logical = FALSE)
  }
  future::plan(future::multisession, workers = workers)
  invisible(workers)
}

hw_theme_defaults <- function() {
  if (requireNamespace("ggplot2", quietly = TRUE)) {
    ggplot2::theme_set(ggplot2::theme_bw())
  }
  options(
    tibble.width = Inf,
    dplyr.print_max = Inf
  )
  invisible(NULL)
}

