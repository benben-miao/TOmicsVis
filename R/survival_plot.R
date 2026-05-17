#' @title Survival plot for analyzing and visualizing survival data.
#' @description Survival plot for analyzing and visualizing survival data.
#' @author benben-miao
#'
#' @return Plot: survival plot for analyzing and visualizing survival data.
#' @param data Dataframe: survival record data (1st-col: Time, 2nd-col: Status, 3rd-col: Group).
#' @param curve_function Character: an arbitrary function defining a transformation of the survival curve. Often used transformations can be specified with a character argument: "event" plots cumulative events (f(y) = 1-y), "cumhaz" plots the cumulative hazard function (f(y) = -log(y)), and "pct" for survival probability in percentage.
#' @param log_rank Character: the weights to be used in computing the p-value for log-rank test. Default: "1", options: "1", "n", "sqrtN", "S1", "S2", "FH". so that weight correspond to the test as : 1 - log-rank, n - Gehan-Breslow (generalized Wilcoxon), sqrtN - Tarone-Ware, S1 - Peto-Peto's modified survival estimate, S2 - modified Peto-Peto (by Andersen), FH - Fleming-Harrington(p=1, q=1).
#' @param conf_inter Logical: confidence interval. Default: TRUE, options: TRUE, FALSE.
#' @param interval_style Character: confidence interval style. Default: "ribbon", options: "ribbon", "step".
#' @param risk_table Logical: show cumulative risk table. Default: TRUE, options: TRUE, FALSE.
#' @param num_censor Logical: show cumulative number of censoring. Default: TRUE, options: TRUE, FALSE.
#' @param sci_palette Character: ggsci color palette. Default: "aaas", options: "aaas", "npg", "lancet", "jco", "ucscgb", "uchicago", "simpsons", "rickandmorty".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_publication", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#' @param x_start Numeric: x-axis start value. Default: 0, min: 0, max: null.
#' @param y_start Numeric: y-axis start value. Default: 0, min: 0, max: 100.
#' @param y_end Numeric: y-axis end value. Default: 100, min: 0, max: 100.
#' @param x_break Numeric: x-axis break value. Default: 10, min: 0, max: null.
#'
#' @import ggplot2
#' @import ggsci
#' @importFrom survival survfit Surv
#' @importFrom survminer ggsurvplot
#' @export
#'
#' @examples
#' # 1. Library TOmicsVis package
#' library(TOmicsVis)
#'
#' # 2. Use example dataset
#' data(survival_data)
#' head(survival_data)
#'
#' # 3. Default parameters
#' survival_plot(survival_data)
#'
#' # 4. Set conf_inter = FALSE
#' survival_plot(survival_data, conf_inter = FALSE)
#'
#' # 5. Set sci_palette = "jco"
#' survival_plot(survival_data, sci_palette = "jco")
#'

survival_plot <- function(data,
													curve_function = "pct",
													log_rank = "1",
													conf_inter = TRUE,
													interval_style = "ribbon",
													risk_table = TRUE,
													num_censor = TRUE,
													sci_palette = "aaas",
													ggTheme = "theme_publication",
													x_start = 0,
													y_start = 0,
													y_end = 100,
													x_break = 10){

	validate_character_options(ggTheme, "ggTheme",
														 c("theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw",
															 "theme_dark", "theme_minimal", "theme_classic", "theme_void",
															 "theme_publication"))

	if (!requireNamespace("survminer", quietly = TRUE)) {
		stop("Package 'survminer' is required for survival_plot().\n",
				 "Please install: BiocManager::install('survminer')",
				 call. = FALSE)
	}

	if (!is.data.frame(data) && !is.matrix(data)) {
		stop("data must be a data.frame or matrix", call. = FALSE)
	}

	if (ncol(data) < 3) {
		stop("data must have at least 3 columns: Time, Status, Group", call. = FALSE)
	}

	data <- as.data.frame(data)
	colnames(data) <- c("Time", "Status", "Group")

	fit <- survival::survfit(survival::Surv(Time, Status == 1) ~ Group, data = data)

	xLimEnd <- max(data$Time)
	data <- data[data[,1] < xLimEnd, ]

	gg_theme <- get_ggtheme(ggTheme)

	p <- survminer::ggsurvplot(
		fit,
		data = data,
		fun = curve_function,
		conf.int = conf_inter,
		conf.int.style = interval_style,
		pval = TRUE,
		pval.method = TRUE,
		log.rank.weights = log_rank,
		xlab = "Time",
		ylab = "Survival probability",
		ggtheme = gg_theme,
		risk.table = risk_table,
		risk.table.height = 0.25,
		risk.table.y.text = TRUE,
		risk.table.y.text.col = TRUE,
		ncensor.plot = num_censor,
		ncensor.plot.height = 0.25,
		cumevents = FALSE,
		cumcensor = FALSE,
		surv.median.line = "hv",
		palette = sci_palette,
		xlim = c(x_start, xLimEnd),
		ylim = c(y_start, y_end),
		break.x.by = x_break
	)

	return(p)
}
