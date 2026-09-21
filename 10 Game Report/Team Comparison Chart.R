### to do
## better title spacing on final dashboard


######### generate team comparison chart with descriptive variabile names

###### load dependencies

require(tidyverse) 
require(ggthemes)
require(scales)
require(ggpubr)
library(cowplot)


###### select teams to compare

select_team <- "T.B"

compare_team <- "ARI"



###### define function for generating team comparison chart

generate_team_comparison_dashboard <- function(x) {

### format data for comparison charts

comp_chart <- report_data [3] %>% 
  
  data.frame(.) %>%
  
  filter(Team == select_team | Team == compare_team) %>%
  
  mutate(Team_Order = ifelse(Team == select_team, 1, 2)) %>%
  
  arrange(Team_Order, Group_Order, Measure_Order) %>%
  
  mutate(Team = factor(Team, levels = unique(Team)),
         Group = factor(Group, levels = unique(Group)),
         Verbose = factor(Verbose, levels = unique(Verbose)))


### define function for ordering within a variable in ggplot

reorder_within <- function(x, by, within, fun = mean, sep = "___", ...) 
  
  {
  
  new_x <- paste(x, within, sep = sep)
  
  stats::reorder(new_x, by, FUN = fun)

  }


### build one comparison panel
##
## the seven panels are identical apart from the Group they filter to,
## the measure the Good/Bad labels are anchored on, and the title

build_panel <- function(group_name, annotation_label, plot_title) {

  panel_data <- comp_chart %>%

    filter(Group == group_name) %>%

    arrange(Team_Order, Group_Order, Measure_Order)



    ggplot(panel_data,
           aes(
             x = reorder_within(Team,-Team_Order, Verbose),
             y = Season_Value_Z_Score,
             fill = Team
           )) +

    geom_bar(stat = "identity") +

    geom_point(
      aes(
        x = reorder_within(Team,-Team_Order, Verbose),
        y = U10_Value_Z_Score,
        fill = Team
      ),
      size = 5,
      shape = 21,
      stroke = 1,
      color = "black"
    ) +

    geom_rect(
      ymin = -2.5,
      ymax = -1,
      xmin = -Inf,
      xmax = Inf,
      fill = "tomato",
      alpha = 0.05
    ) +

    geom_rect(
      ymin = 1,
      ymax = 2.5,
      xmin = -Inf,
      xmax = Inf,
      fill = "forestgreen",
      alpha = 0.05
    ) +

    geom_hline(yintercept = 1,
               linetype = 2,
               size = 1) +

    geom_hline(yintercept = -1,
               linetype = 2,
               size = 1) +

    geom_label(
      data = filter(comp_chart, Verbose == annotation_label),
      aes(
        x = 2.15,
        y = 1.25,
        label = "Good",
        size = 6
      ),
      fill = "white",
      family = "Trebuchet MS"
    ) +

    geom_label(
      data = filter(comp_chart, Verbose == annotation_label),
      aes(
        x = 2.15,
        y = -1.25,
        label = "Bad",
        size = 6
      ),
      fill = "white",
      family = "Trebuchet MS"
    ) +

    facet_wrap(
      ~ Verbose,
      ncol = 1,
      strip.position = "left",
      scales = "free_y",
      labeller = label_wrap_gen(15)
    ) +

    coord_flip(ylim = c(-2.5, 2.5)) +

    theme_few() +

    ggtitle(plot_title) +

    scale_fill_manual(values = c("dodgerblue3", "darkorange2")) +

    theme(
      plot.title = element_text(
        face = "bold",
        size = 22,
        family = "Trebuchet MS"
      ),
      legend.position = "none",
      axis.title = element_blank(),
      strip.placement = "outside",
      strip.text.y = element_text(
        face = "bold",
        size = 15,
        angle = 180,
        family = "Trebuchet MS"
      ),
      axis.text = element_blank(),
      plot.caption = element_text(
        size = 18,
        face = "italic",
        hjust = 1,
        margin = margin(t = 15, b = 5),
        family = "Trebuchet MS"
      )
    )

}


### create individual component plots to be arranged on dashboard

off_5v5_plot    <- build_panel("5v5 Offense", "Shot Generation",         "5v5 Offense")
def_5v5_plot    <- build_panel("5v5 Defense", "Shot Suppression",        "5v5 Defense")
total_5v5_plot  <- build_panel("5v5 Total",   "Shot Share",              "5v5 Total")
result_5v5_plot <- build_panel("5v5 Results", "Goals Scored Above Exp.", "5v5 Results")
off_5v4_plot    <- build_panel("5v4 Offense", "Shot Generation",         "5v4 Offense")
def_4v5_plot    <- build_panel("4v5 Defense", "Shot Suppression",        "4v5 Defense")
result_st_plot  <- build_panel("ST Results",  "Goals Scored Above Exp.", "Special Teams Results")

### get legend for dashboard

legend <- get_legend(result_st_plot)


### arrange plots on dashboard

set_null_device("png")

comp_dash <-
  
  ggarrange(
    off_5v5_plot,
    off_5v4_plot,
    def_5v5_plot,
    def_4v5_plot,
    total_5v5_plot,
    result_st_plot + theme(legend.position = "none"),
    result_5v5_plot,
    legend,
    nrow = 4,
    ncol = 2,
    heights = c(3, 3, 2, 2)
  )


### get title info

team1 <- select_team

team2 <- compare_team

date <- Sys.Date()


### add titles and annotations to dashboard

annotate_figure(
  comp_dash,
  top = text_grob(
    paste0(team1, " vs. ", team2, " (", date, ")\n"),
    face = "bold",
    size = 28
  ),
  bottom = text_grob(
    "All data via naturalstattrick.com, chart by @loserpoints",
    hjust = 1.1,
    x = 1,
    face = "italic",
    size = 18
  )
)

### save plot

ggsave(paste0("Viz/team_comp_dash_", date, ".jpg"), width = 21.333, height = 10.667)

}


###### generate team comparison chart using function defined below

generate_team_comparison_dashboard()
