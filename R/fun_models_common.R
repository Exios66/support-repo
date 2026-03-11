hw_rec_glm_classification <- function(data, outcome) {
  if (!requireNamespace("recipes", quietly = TRUE)) {
    stop("Package 'recipes' is required for hw_rec_glm_classification().", call. = FALSE)
  }
  outcome <- rlang::ensym(outcome)
  recipes::recipe(rlang::new_formula(outcome, quote(.)), data = data)
}

hw_rec_knn_classification <- function(data, outcome) {
  if (!requireNamespace("recipes", quietly = TRUE)) {
    stop("Package 'recipes' is required for hw_rec_knn_classification().", call. = FALSE)
  }
  outcome <- rlang::ensym(outcome)
  recipes::recipe(rlang::new_formula(outcome, quote(.)), data = data) |>
    recipes::step_normalize(recipes::all_numeric_predictors())
}

hw_knn_grid <- function(neighbors_min = 1, neighbors_max = 100, by = 5) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for hw_knn_grid().", call. = FALSE)
  }
  dplyr::tibble(neighbors = seq(neighbors_min, neighbors_max, by = by))
}

hw_rec_regularized_regression <- function(data, outcome, id_var = "pid") {
  if (!requireNamespace("recipes", quietly = TRUE)) {
    stop("Package 'recipes' is required for hw_rec_regularized_regression().", call. = FALSE)
  }
  outcome <- rlang::ensym(outcome)
  id_var <- rlang::ensym(id_var)

  recipes::recipe(rlang::new_formula(outcome, quote(.)), data = data) |>
    recipes::step_rm(!!id_var) |>
    recipes::step_impute_median(recipes::all_numeric_predictors()) |>
    recipes::step_impute_mode(recipes::all_nominal_predictors()) |>
    recipes::step_normalize(recipes::all_numeric_predictors()) |>
    recipes::step_dummy(recipes::all_nominal_predictors())
}

hw_grid_penalty <- function(n = 100, min_log = -6, max_log = 8) {
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for hw_grid_penalty().", call. = FALSE)
  }
  dplyr::tibble(penalty = exp(seq(min_log, max_log, length.out = n)))
}

