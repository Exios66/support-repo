hw_initial_split <- function(data, prop = 2/3, strata, seed = NULL) {
  if (!requireNamespace("rsample", quietly = TRUE)) {
    stop("Package 'rsample' (via tidymodels) is required for hw_initial_split().", call. = FALSE)
  }
  if (!is.null(seed)) {
    set.seed(seed)
  }
  splits <- rsample::initial_split(data, prop = prop, strata = {{ strata }})
  list(
    splits = splits,
    train = rsample::training(splits),
    test = rsample::testing(splits)
  )
}

hw_bootstraps <- function(data, times = 100, strata) {
  if (!requireNamespace("rsample", quietly = TRUE)) {
    stop("Package 'rsample' (via tidymodels) is required for hw_bootstraps().", call. = FALSE)
  }
  rsample::bootstraps(data, times = times, strata = {{ strata }})
}

hw_tune_grid <- function(model_spec, rec, resamples, grid, metrics) {
  if (!requireNamespace("tune", quietly = TRUE)) {
    stop("Package 'tune' (via tidymodels) is required for hw_tune_grid().", call. = FALSE)
  }
  tune::tune_grid(
    object = model_spec,
    preprocessor = rec,
    resamples = resamples,
    grid = grid,
    metrics = metrics
  )
}

hw_collect_best <- function(tuned_fit, metric) {
  if (!requireNamespace("tune", quietly = TRUE)) {
    stop("Package 'tune' (via tidymodels) is required for hw_collect_best().", call. = FALSE)
  }
  tune::select_best(tuned_fit, metric = metric)
}

hw_plot_neighbors <- function(tuned_knn_fit, title = "KNN Tuning: ROC AUC by Number of Neighbors") {
  if (!requireNamespace("ggplot2", quietly = TRUE) ||
      !requireNamespace("dplyr", quietly = TRUE) ||
      !requireNamespace("tune", quietly = TRUE)) {
    stop("Packages 'ggplot2', 'dplyr', and 'tune' are required for hw_plot_neighbors().", call. = FALSE)
  }

  tuned_knn_fit |>
    tune::collect_metrics() |>
    ggplot2::ggplot(ggplot2::aes(x = neighbors, y = mean)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::geom_errorbar(
      ggplot2::aes(ymin = mean - std_err, ymax = mean + std_err),
      width = 1
    ) +
    ggplot2::labs(
      x = "Number of Neighbors (K)",
      y = "ROC AUC (Bootstrap Mean \u00b1 SE)",
      title = title
    )
}

