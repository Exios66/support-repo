# support-repo

## Overview

This repository hosts reusable R helper scripts for homework and lab workflows (for example, psych 752). The helpers live in the `R/` subdirectory and provide a consistent API for:

- **Setup**: packages, conflicts, parallel processing, and plotting/theme defaults.
- **Data paths & reading**: standard homework directory conventions and CSV loading.
- **Caching**: fast re-runs of expensive computations.
- **Resampling & tuning**: common rsample / tune workflows.
- **Model recipes & grids**: shared tidymodels recipes and hyperparameter grids.
- **Plots**: correlation heatmaps and predictor variance plots.

These helpers are designed to be **sourced directly from GitHub** using raw URLs.

## Sourcing helpers from GitHub

The public GitHub location for these scripts is:

- **Repository**: `Exios66/support-repo`
- **Default branch**: `main`

To use the helpers in a Quarto (`.qmd`) or R Markdown document, add a setup chunk that sources the scripts from their raw URLs:

```r
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_setup_hw.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_paths_data.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_cache_hw.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_resampling_tune.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_models_common.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_plots_hw.R")
```

These scripts **do not install packages for you**. Make sure the required packages
(`tidyverse`, `tidymodels`, `future`, `xfun`, `janitor`, `here`, `conflicted`, etc.)
are installed in your R environment.

## Helper script index

All helpers live under the `R/` directory:

- **Setup helpers** – [`R/fun_setup_hw.R`](R/fun_setup_hw.R)
  - `hw_load_core_packages()`: Load core packages (tidyverse, tidymodels, future, xfun, janitor, here) quietly.
  - `hw_set_conflicts()`: Set conflict policy and apply Matrix-related conflict rules (when `conflicted` is available).
  - `hw_enable_parallel(workers = NULL)`: Configure `future::plan(multisession, workers = ...)` for parallel processing.
  - `hw_theme_defaults()`: Apply `ggplot2::theme_bw()` and wide tibble/`dplyr` print options.

- **Path & data helpers** – [`R/fun_paths_data.R`](R/fun_paths_data.R)
  - `hw_path_data(unit = NULL, path = NULL)`: Build standard homework data paths like `"HW/Unit_<unit>"`, or accept a custom path.
  - `hw_read_csv(path_data, file, show_col_types = FALSE, ...)`: Read CSVs via `readr::read_csv(here::here(path_data, file), ...)`.
  - `hw_glimpse(x)`: Convenience wrapper around `dplyr::glimpse()`.
  - `hw_tabyl_factor(df, var)`: Factor/tabulation helper via `janitor::tabyl()` with tidy-eval.

- **Caching helper** – [`R/fun_cache_hw.R`](R/fun_cache_hw.R)
  - `hw_cache(expr, name, subdir = "cache", rerun = FALSE)`: Create the cache directory if needed and delegate to `xfun::cache_rds()` for reproducible caching of expensive computations.

- **Resampling & tuning helpers** – [`R/fun_resampling_tune.R`](R/fun_resampling_tune.R)
  - `hw_initial_split(data, prop = 2/3, strata, seed = NULL)`: Wrap `rsample::initial_split()` and return `splits`, `train`, and `test`.
  - `hw_bootstraps(data, times = 100, strata)`: Wrap `rsample::bootstraps()` with tidy-eval `strata`.
  - `hw_tune_grid(model_spec, rec, resamples, grid, metrics)`: Wrap `tune::tune_grid()` over a model, recipe, resamples, grid, and metrics.
  - `hw_collect_best(tuned_fit, metric)`: Wrap `tune::select_best()` to extract best hyperparameters.
  - `hw_plot_neighbors(tuned_knn_fit, title = "KNN Tuning: ROC AUC by Number of Neighbors")`: Produce a KNN ROC AUC vs neighbors plot (with error bars) using `tune::collect_metrics()` and `ggplot2`.

- **Common model specs & grids** – [`R/fun_models_common.R`](R/fun_models_common.R)
  - `hw_rec_glm_classification(data, outcome)`: Build a simple classification recipe `outcome ~ .` using `recipes::recipe()`.
  - `hw_rec_knn_classification(data, outcome)`: Classification recipe plus `step_normalize(all_numeric_predictors())` for KNN.
  - `hw_knn_grid(neighbors_min = 1, neighbors_max = 100, by = 5)`: Construct a `tibble(neighbors = ...)` grid for tuning.
  - `hw_rec_regularized_regression(data, outcome, id_var = "pid")`: Regularized regression recipe that removes ID, imputes numeric/nominal, normalizes numeric, and one-hot encodes nominal predictors.
  - `hw_grid_penalty(n = 100, min_log = -6, max_log = 8)`: Build a penalty grid `penalty = exp(seq(min_log, max_log, length.out = n))`.

- **Plot helpers** – [`R/fun_plots_hw.R`](R/fun_plots_hw.R)
  - `hw_plot_cor_heatmap(df, title = "Predictor Correlations in Training Data")`: Numeric correlation heatmap using `dplyr`, `tidyr`, and `ggplot2`.
  - `hw_plot_predictor_sd(df, title = "Predictor Variance in Training Data")`: Flipped bar chart of numeric predictor standard deviations.

- **Additional utilities** – [`R/fun_hw_utils_extra.R`](R/fun_hw_utils_extra.R)
  - `hw_check_packages(pkgs)`: Return a tibble indicating which requested packages are installed.
  - `hw_safe_read_csv(path_data, file, show_col_types = FALSE, ...)`: Safe wrapper around `hw_read_csv()` that checks file existence and gives a clearer error if missing.
  - `hw_seed(seed)`: Small helper to set the random seed and return it invisibly.

## Example: using helpers in a Quarto homework

Below is a minimal pattern for using these helpers in a homework `.qmd` document.

### Setup chunk

```r
```{r}
# Source helper scripts from GitHub
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_setup_hw.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_paths_data.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_cache_hw.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_resampling_tune.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_models_common.R")
source("https://raw.githubusercontent.com/Exios66/support-repo/main/R/fun_plots_hw.R")

# Core setup
hw_load_core_packages()
hw_set_conflicts()
hw_enable_parallel()
hw_theme_defaults()

rerun_setting <- FALSE
path_data <- hw_path_data(unit = 8)

data_all <- hw_read_csv(path_data, "breast_cancer.csv", show_col_types = FALSE)

hw_glimpse(data_all)
hw_tabyl_factor(data_all, diagnosis)
```
```

### Modeling chunk (KNN example)

```r
```{r}
# Resampling
splits <- hw_initial_split(data_all, prop = 2/3, strata = diagnosis, seed = 12345)
data_train <- splits$train
data_test  <- splits$test

splits_boot <- hw_bootstraps(data_train, times = 100, strata = diagnosis)

# Recipes & grids
rec_glm <- hw_rec_glm_classification(data_train, diagnosis)
rec_knn <- hw_rec_knn_classification(data_train, diagnosis)
grid_knn <- hw_knn_grid()

# KNN tuning with caching
fits_knn <- hw_cache(
  expr = hw_tune_grid(
    model_spec = nearest_neighbor(neighbors = tune()),
    rec        = rec_knn,
    resamples  = splits_boot,
    grid       = grid_knn,
    metrics    = yardstick::metric_set(roc_auc)
  ),
  name   = "fits_knn_boot",
  subdir = "cache",
  rerun  = rerun_setting
)

hw_plot_neighbors(fits_knn)
```
```

### Plot helpers in practice

Once you have a training data set (for example, `data_train` above), you can call:

```r
hw_plot_cor_heatmap(data_train)
hw_plot_predictor_sd(data_train)
```

These will generate correlation and variance diagnostics consistent with the corresponding homework units.



