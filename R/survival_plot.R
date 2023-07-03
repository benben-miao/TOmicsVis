#' @title Survival plot for analyzing and visualizing survival data.
#' @description Survival plot for analyzing and visualizing survival data.
#' @author benben-miao
#'
#' @return Plot: survival plot for analyzing and visualizing survival data.
#' @param data Dataframe: include columns (Time, Status, Group), rows (records).
#' @param curve_function Character: an arbitrary function defining a transformation of the survival curve. Often used transformations can be specified with a character argument: "event" plots cumulative events (f(y) = 1-y), "cumhaz" plots the cumulative hazard function (f(y) = -log(y)), and "pct" for survival probability in percentage.
#' @param conf_inter Logical: confidence interval. Default: TRUE, options: TRUE, FALSE.
#' @param interval_style Character: confidence interval style. Default: "ribbon", options: "ribbon", "step".
#' @param risk_table Logical: show cumulative risk table. Default: TRUE, options: TRUE, FALSE.
#' @param num_censor Logical: show cumulative number of censoring. Default: TRUE, options: TRUE, FALSE.
#' @param sci_palette Character: ggsci color palette. Default: "aaas", options: "aaas", "npg", "lancet", "jco", "ucscgb", "uchicago", "simpsons", "rickandmorty".
#' @param ggTheme Character: ggplot2 themes. Default: "theme_light", options: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
#' @param x_start Numeric: x-axis start value. Default: 0, min: 0, max: null.
#' @param y_start Numeric: y-axis start value. Default: 0, min: 0, max: 100.
#' @param y_end Numeric: y-axis end value. Default: 100, min: 0, max: 100.
#' @param x_break Numeric: x-axis break value. Default: 100, min: 0, max: null.
#' @param y_break Numeric: y-axis break value. Default: 25, min: 0, max: 100.
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
#'
#' # 3. Default parameters
#' survival_plot(survival_data)
#'
#' # 4. Set curve_function = "event"
#' survival_plot(survival_data, curve_function = "event")
#'
#' # 5. Set conf_inter = FALSE
#' survival_plot(survival_data, conf_inter = FALSE)
#'
#' # 6. Set interval_style = "step"
#' survival_plot(survival_data, interval_style = "step")
#'
#' # 7. Set sci_palette = "jco"
#' survival_plot(survival_data, sci_palette = "jco")
#'
survival_plot <- function(data,
													curve_function = "pct",
													conf_inter = TRUE,
													interval_style = "ribbon",
													risk_table = TRUE,
													num_censor = TRUE,
													sci_palette = "aaas",
													ggTheme = "theme_light",
													x_start = 0,
													y_start = 0,
													y_end = 100,
													x_break = 100,
													y_break = 25
													){
	# -> 2. Data
	data <- as.data.frame(data)
	colnames(data) <- c("Time", "Status", "Group")

	fit <- survival::survfit(survival::Surv(Time, Status == 1) ~ Group, data = data)

	xLimEnd <- max(data$Time)
	data <- data[data[,1] < xLimEnd,]
	# <- 2. Data

	# -> 3. Plot parameters
	# fonts <- "Times"
	# ChoiceBox: "Times", "Palatino", "Bookman", "Courier", "Helvetica", "URWGothic", "NimbusMon", "NimbusSan"

	# ggTheme <- "theme_light"
	# ChoiceBox: "theme_default", "theme_bw", "theme_gray", "theme_light", "theme_linedraw", "theme_dark", "theme_minimal", "theme_classic", "theme_void"
	if (ggTheme == "theme_default") {
		gg_theme <- theme()
	} else if (ggTheme == "theme_bw") {
		gg_theme <- theme_bw()
	} else if (ggTheme == "theme_gray") {
		gg_theme <- theme_gray()
	} else if (ggTheme == "theme_light") {
		gg_theme <- theme_light()
	} else if (ggTheme == "theme_linedraw") {
		gg_theme <- theme_linedraw()
	} else if (ggTheme == "theme_dark") {
		gg_theme <- theme_dark()
	} else if (ggTheme == "theme_minimal") {
		gg_theme <- theme_minimal()
	} else if (ggTheme == "theme_classic") {
		gg_theme <- theme_classic()
	} else if (ggTheme == "theme_void") {
		gg_theme <- theme_void()
	} else if (ggTheme == "theme_test") {
		gg_theme <- theme_test()
	}

	# sci_palette <- "aaas"
	# ChoiceBox: "aaas", "npg", "lancet", "jco", "ucscgb", "uchicago", "simpsons", "rickandmorty"

	# curve_function <- "pct"
	# ChoiceBox: "pct", "event", "cumhaz"

	# confInterval <- "ShowConfInterval"
	# if (confInterval == "ShowConfInterval") {
	# 	conf_int <- TRUE
	# } else if (confInterval == "HindConfInterval") {
	# 	conf_int <- FALSE
	# }
	# # ChoiceBox: "ShowConfInterval", "HindConfInterval"

	# interval_style <- "ribbon"
	# ChoiceBox: "ribbon", "step"

	# riskTable <- "ShowRiskTable"
	# if (riskTable == "ShowRiskTable") {
	# 	risk_table <- TRUE
	# } else if (riskTable == "HindRiskTable") {
	# 	risk_table <- FALSE
	# }
	# # ChoiceBox: "ShowRiskTable", "HindRiskTable"

	# numCensor <- "ShowNumCensor"
	# if (numCensor == "ShowNumCensor") {
	# 	num_censor <- TRUE
	# } else if (numCensor == "HindNumCensor") {
	# 	num_censor <- FALSE
	# }
	# # ChoiceBox: "ShowNumCensor", "HindNumCensor"

	# x_start <- 0
	# Slider: 0 0,1,1000

	# y_start <- 0
	# Slider: 0 0,1,100

	# y_end <- 100
	# Slider: 100 0,1,100

	# x_break <- 100
	# Slider: 100 1,1,1000

	# y_break <- 25
	# Slider: 25 1,5,100

	# <- 3. Plot parameters

	# # -> 4. Plot
	p <- survminer::ggsurvplot(
		fit,
		data = data,
		fun = curve_function,
		risk.table = risk_table,
		pval = TRUE,
		conf.int = conf_inter,
		conf.int.style = interval_style,
		size = 1,
		xlab = "Time",
		ylab = "Survival probability",
		ggtheme = gg_theme,
		risk.table.y.text.col = TRUE,
		risk.table.height = 0.25,
		risk.table.y.text = TRUE,
		ncensor.plot = num_censor,
		ncensor.plot.height = 0.25,
		surv.median.line = "hv",
		palette = sci_palette,
		xlim = c(x_start, xLimEnd),
		ylim = c(y_start, y_end),
		break.x.by = x_break,
		break.y.by = y_break
	)
	# p
	# # <- 4. Plot

	return(p)
	invisible()
}
