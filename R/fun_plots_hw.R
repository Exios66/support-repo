hw_plot_cor_heatmap <- function(df, title = "Predictor Correlations in Training Data") {
  if (!requireNamespace("dplyr", quietly = TRUE) ||
      !requireNamespace("tidyr", quietly = TRUE) ||
      !requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Packages 'dplyr', 'tidyr', and 'ggplot2' are required for hw_plot_cor_heatmap().", call. = FALSE)
  }

  df |>
    dplyr::select(dplyr::where(is.numeric)) |>
    stats::cor() |>
    tibble::as_tibble(rownames = "predictor1") |>
    tidyr::pivot_longer(-predictor1, names_to = "predictor2", values_to = "cor") |>
    ggplot2::ggplot(ggplot2::aes(x = predictor1, y = predictor2, fill = cor)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_gradient2(
      low = "blue",
      high = "red",
      mid = "white",
      midpoint = 0,
      limits = c(-1, 1)
    ) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, size = 6),
      axis.text.y = ggplot2::element_text(size = 6)
    ) +
    ggplot2::labs(
      x = NULL,
      y = NULL,
      fill = "r",
      title = title
    )
}

hw_plot_predictor_sd <- function(df, title = "Predictor Variance in Training Data") {
  if (!requireNamespace("dplyr", quietly = TRUE) ||
      !requireNamespace("tidyr", quietly = TRUE) ||
      !requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Packages 'dplyr', 'tidyr', and 'ggplot2' are required for hw_plot_predictor_sd().", call. = FALSE)
  }

  df |>
    dplyr::select(dplyr::where(is.numeric)) |>
    dplyr::summarize(dplyr::across(dplyr::everything(), stats::sd)) |>
    tidyr::pivot_longer(dplyr::everything(), names_to = "predictor", values_to = "sd") |>
    ggplot2::ggplot(ggplot2::aes(x = stats::reorder(predictor, sd), y = sd)) +
    ggplot2::geom_col() +
    ggplot2::coord_flip() +
    ggplot2::labs(
      x = NULL,
      y = "Standard Deviation",
      title = title
    )
}

