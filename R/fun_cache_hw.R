hw_cache <- function(expr, name, subdir = "cache", rerun = FALSE) {
  if (!requireNamespace("xfun", quietly = TRUE)) {
    stop("Package 'xfun' is required for hw_cache().", call. = FALSE)
  }

  dir.create(subdir, showWarnings = FALSE, recursive = TRUE)

  xfun::cache_rds(
    expr = expr,
    dir = subdir,
    file = name,
    rerun = rerun
  )
}

