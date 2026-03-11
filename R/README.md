## R helper scripts reference

This directory contains reusable helper scripts for homework and lab workflows. They are designed to be **sourced directly from GitHub** (see the top-level `README.md` for raw URLs) and then called from Quarto / R Markdown documents.

Below is a function-by-function reference, grouped by file.

### `fun_setup_hw.R`

- **`hw_load_core_packages()`**
  - **Purpose**: Load the core package set used in homeworks.
  - **Behavior**: Quietly loads `tidyverse`, `tidymodels`, `future`, `xfun`, `janitor`, and `here` if they are not already loaded.
  - **Returns**: Invisibly returns the character vector of package names.

- **`hw_set_conflicts()`**
  - **Purpose**: Apply consistent conflict-handling options.
  - **Behavior**:
    - Sets `options(conflicts.policy = "depends.ok")`.
    - If both `conflicted` and `Matrix` are installed, calls:
      - `conflicted::conflictRules("Matrix", mask.ok = c("expand", "pack", "unpack"))`.
  - **Returns**: Invisibly returns `NULL`.

- **`hw_enable_parallel(workers = NULL)`**
  - **Purpose**: Enable parallel processing via the `future` package.
  - **Behavior**:
    - Requires `future`.
    - If `workers` is `NULL`, uses `parallel::detectCores(logical = FALSE)` to set the number of workers.
    - Calls `future::plan(future::multisession, workers = workers)`.
  - **Returns**: Invisibly returns the number of workers used.

- **`hw_theme_defaults()`**
  - **Purpose**: Apply plotting and printing defaults consistent with course materials.
  - **Behavior**:
    - If `ggplot2` is installed, sets `theme_set(theme_bw())`.
    - Sets options:
      - `tibble.width = Inf`
      - `dplyr.print_max = Inf`
  - **Returns**: Invisibly returns `NULL`.

### `fun_paths_data.R`

- **`hw_path_data(unit = NULL, path = NULL)`**
  - **Purpose**: Standardize where homework data lives.
  - **Behavior**:
    - If `path` is provided, returns it unchanged.
    - Else, if `unit` is provided, returns `file.path("HW", paste0("Unit_", unit))`.
    - Else, errors with a helpful message.
  - **Example**:
    - `hw_path_data(unit = 8)` → `"HW/Unit_8"`.

- **`hw_read_csv(path_data, file, show_col_types = FALSE, ...)`**
  - **Purpose**: Thin wrapper around `readr::read_csv()` using `here::here()`.
  - **Behavior**:
    - Requires `readr` and `here`.
    - Calls:
      - `readr::read_csv(here::here(path_data, file), show_col_types = show_col_types, ...)`.

- **`hw_glimpse(x)`**
  - **Purpose**: Convenience wrapper around `dplyr::glimpse()`.
  - **Behavior**:
    - Requires `dplyr`.
    - Calls `dplyr::glimpse(x)`.

- **`hw_tabyl_factor(df, var)`**
  - **Purpose**: Quick factor/tabulation summaries using `janitor`.
  - **Behavior**:
    - Requires `janitor`.
    - Uses tidy evaluation (`rlang::enquo()`) to capture `var`.
    - Calls `janitor::tabyl(df, !!var)`.

### `fun_cache_hw.R`

- **`hw_cache(expr, name, subdir = "cache", rerun = FALSE)`**
  - **Purpose**: Provide a simple, standardized caching wrapper for expensive computations.
  - **Behavior**:
    - Requires `xfun`.
    - Ensures `subdir` exists via `dir.create(subdir, showWarnings = FALSE, recursive = TRUE)`.
    - Delegates to:
      - `xfun::cache_rds(expr = expr, dir = subdir, file = name, rerun = rerun)`.
  - **Typical usage**:
    - Wraps a tuning or modeling expression; reuses cached results on subsequent runs unless `rerun = TRUE`.

### `fun_resampling_tune.R`

- **`hw_initial_split(data, prop = 2/3, strata, seed = NULL)`**
  - **Purpose**: Standardize initial train/test splits.
  - **Behavior**:
    - Requires `rsample` (via `tidymodels`).
    - If `seed` is not `NULL`, sets the random seed.
    - Calls `rsample::initial_split(data, prop = prop, strata = {{ strata }})`.
    - Returns a list with:
      - `splits`: the rsample split object.
      - `train`: training data (`rsample::training(splits)`).
      - `test`: test data (`rsample::testing(splits)`).

- **`hw_bootstraps(data, times = 100, strata)`**
  - **Purpose**: Wrap `rsample::bootstraps()` with tidy-eval `strata`.
  - **Behavior**:
    - Requires `rsample`.
    - Calls `rsample::bootstraps(data, times = times, strata = {{ strata }})`.

- **`hw_tune_grid(model_spec, rec, resamples, grid, metrics)`**
  - **Purpose**: Consistent front-end to `tune::tune_grid()`.
  - **Behavior**:
    - Requires `tune`.
    - Calls:
      - `tune::tune_grid(object = model_spec, preprocessor = rec, resamples = resamples, grid = grid, metrics = metrics)`.

- **`hw_collect_best(tuned_fit, metric)`**
  - **Purpose**: Thin wrapper over `tune::select_best()`.
  - **Behavior**:
    - Requires `tune`.
    - Calls `tune::select_best(tuned_fit, metric = metric)`.

- **`hw_plot_neighbors(tuned_knn_fit, title = "KNN Tuning: ROC AUC by Number of Neighbors")`**
  - **Purpose**: Reproduce the standard KNN tuning plot (ROC AUC vs neighbors with error bars).
  - **Behavior**:
    - Requires `ggplot2`, `dplyr`, and `tune`.
    - Uses `tuned_knn_fit |> tune::collect_metrics()` to obtain performance metrics.
    - Plots `neighbors` vs `mean` with error bars (`mean ± std_err`), labeled with the provided `title`.

### `fun_models_common.R`

- **`hw_rec_glm_classification(data, outcome)`**
  - **Purpose**: Provide a simple classification recipe baseline.
  - **Behavior**:
    - Requires `recipes`.
    - Uses `rlang::ensym(outcome)` and `recipes::recipe(rlang::new_formula(outcome, quote(.)), data = data)`.
    - No additional preprocessing steps are applied.

- **`hw_rec_knn_classification(data, outcome)`**
  - **Purpose**: Classification recipe for KNN models with numeric predictors normalized.
  - **Behavior**:
    - Requires `recipes`.
    - Same base as `hw_rec_glm_classification()`, but adds:
      - `recipes::step_normalize(recipes::all_numeric_predictors())`.

- **`hw_knn_grid(neighbors_min = 1, neighbors_max = 100, by = 5)`**
  - **Purpose**: Construct a simple neighbors grid for KNN tuning.
  - **Behavior**:
    - Requires `dplyr`.
    - Returns `dplyr::tibble(neighbors = seq(neighbors_min, neighbors_max, by = by))`.

- **`hw_rec_regularized_regression(data, outcome, id_var = "pid")`**
  - **Purpose**: Implement the regularized regression preprocessing pipeline from Unit 6.
  - **Behavior**:
    - Requires `recipes`.
    - Uses a recipe with outcome ~ all predictors, then applies:
      - `step_rm(!!id_var)` to drop the identifier.
      - `step_impute_median(all_numeric_predictors())`.
      - `step_impute_mode(all_nominal_predictors())`.
      - `step_normalize(all_numeric_predictors())`.
      - `step_dummy(all_nominal_predictors())`.

- **`hw_grid_penalty(n = 100, min_log = -6, max_log = 8)`**
  - **Purpose**: Provide a default penalty grid for LASSO / regularized models.
  - **Behavior**:
    - Requires `dplyr`.
    - Returns `dplyr::tibble(penalty = exp(seq(min_log, max_log, length.out = n)))`.

### `fun_plots_hw.R`

- **`hw_plot_cor_heatmap(df, title = "Predictor Correlations in Training Data")`**
  - **Purpose**: Visualize pairwise correlations among numeric predictors.
  - **Behavior**:
    - Requires `dplyr`, `tidyr`, and `ggplot2`.
    - Selects numeric columns, computes the correlation matrix, reshapes with `pivot_longer()`, and plots a heatmap with a diverging color scale centered on 0.

- **`hw_plot_predictor_sd(df, title = "Predictor Variance in Training Data")`**
  - **Purpose**: Visualize variability across numeric predictors.
  - **Behavior**:
    - Requires `dplyr`, `tidyr`, and `ggplot2`.
    - Computes standard deviations for numeric predictors, reshapes to long format, and plots a flipped bar chart ordered by SD.

### `fun_hw_utils_extra.R`

- **`hw_check_packages(pkgs)`**
  - **Purpose**: Quickly check whether a set of packages is installed.
  - **Behavior**:
    - Coerces `pkgs` to character.
    - Returns a tibble with columns `package` and `installed` (logical).

- **`hw_safe_read_csv(path_data, file, show_col_types = FALSE, ...)`**
  - **Purpose**: Safer CSV reading that validates file existence before calling `hw_read_csv()`.
  - **Behavior**:
    - Uses `here::here(path_data, file)` and `file.exists()` to check that the file is present.
    - If missing, throws a clear error message including the full path.
    - Otherwise, delegates to `hw_read_csv()` with the same arguments.

- **`hw_seed(seed)`**
  - **Purpose**: Tiny helper to set and record the random seed.
  - **Behavior**:
    - Checks that `seed` has length 1 and then calls `set.seed(seed)`.
    - Invisibly returns the seed value.

