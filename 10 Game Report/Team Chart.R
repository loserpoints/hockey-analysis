### to do
## better title spacing on final dashboard


######### generate single team chart with descriptive variabile names

###### load dependencies

library(tidyverse)
library(ggthemes) 
library(scales) 
library(ggpubr)
library(extrafont)
library(cowplot)

###### load fonts for viz

loadfonts(device = "win", quiet = T)


###### select team for chart

select_team <- "T.B"

verbose_team <- "Tampa Bay Lightning"



###### define function for generating team chart

generate_team_dashboard <- function(x) {
  
  team_chart <- report_data [3] %>%
    
    data.frame(.) %>%
    
    filter(Team == select_team) %>%
    
    arrange(Group_Order, Measure_Order) %>%
    
    mutate(
      Group = factor(Group, levels = unique(Group)),
      Verbose = factor(Verbose, levels = unique(Verbose))
    )

  ####### build one dashboard panel
  ##
  ## the seven panels are identical apart from the Group they filter to,
  ## the measure the Good/Bad labels are anchored on, and the title

  build_panel <- function(group_name, annotation_label, plot_title) {

    panel_data <- team_chart %>%

      filter(Group == group_name) %>%

      arrange(Group_Order, Measure_Order)



      ggplot(panel_data, aes(x = Verbose, y = Season_Value_Z_Score)) +

      geom_bar(stat = "identity", fill = "dodgerblue3") +

      geom_point(
        aes(x = Verbose, y = PU10_Value_Z_Score),
        size = 5,
        shape = 21,
        stroke = 1,
        color = "black",
        fill = "gray"
      ) +

      geom_point(
        aes(x = Verbose, y = U10_Value_Z_Score),
        size = 5,
        shape = 21,
        stroke = 1,
        color = "black",
        fill = "darkorange2"
      ) +

      geom_hline(yintercept = 1,
                 linetype = 2,
                 size = 1) +

      geom_hline(yintercept = -1,
                 linetype = 2,
                 size = 1) +

      geom_rect(
        ymin = -2.5,
        ymax = -1,
        xmin = -Inf,
        xmax = Inf,
        fill = "tomato",
        alpha = 0.1
      ) +

      geom_rect(
        ymin = 1,
        ymax = 2.5,
        xmin = -Inf,
        xmax = Inf,
        fill = "forestgreen",
        alpha = 0.1
      ) +

      geom_label(
        data = filter(team_chart, Verbose == annotation_label),
        aes(
          x = 1.35,
          y = 1.25,
          label = "Good",
          size = 6
        ),
        fill = "white",
        family = "Trebuchet MS"
      ) +

      geom_label(
        data = filter(team_chart, Verbose == annotation_label),
        aes(
          x = 1.35,
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

      ggtitle(plot_title) +

      theme_few() +

      theme(
        plot.title = element_text(
          face = "bold",
          size = 22,
          family = "Trebuchet MS"
        ),
        axis.title = element_blank(),
        axis.text = element_blank(),
        strip.placement = "outside",
        strip.text.y = element_text(
          face = "bold",
          size = 15,
          angle = 180,
          family = "Trebuchet MS"
        ),
        legend.position = "none",
        plot.caption = element_text(
          size = 18,
          face = "italic",
          hjust = 1,
          margin = margin(t = 15, b = 5),
          family = "Trebuchet MS"
        )
      )

  }


  ####### create individual component plots to be arranged on dashboard

  off_5v5_plot    <- build_panel("5v5 Offense", "Shot Generation",         "5v5 Offense")
  def_5v5_plot    <- build_panel("5v5 Defense", "Shot Suppression",        "5v5 Defense")
  total_5v5_plot  <- build_panel("5v5 Total",   "Shot Share",              "5v5 Total")
  result_5v5_plot <- build_panel("5v5 Results", "Goals Scored Above Exp.", "5v5 Results")
  off_5v4_plot    <- build_panel("5v4 Offense", "Shot Generation",         "5v4 Offense")
  def_4v5_plot    <- build_panel("4v5 Defense", "Shot Suppression",        "4v5 Defense")
  result_st_plot  <- build_panel("ST Results",  "Goals Scored Above Exp.", "Special Teams Results")

  ###### arrange plots on dashboard
  
  set_null_device("png")
  
  
  teamdash <-
    
    plot_grid(
      off_5v5_plot,
      off_5v4_plot,
      def_5v5_plot,
      def_4v5_plot,
      total_5v5_plot,
      result_st_plot +
        theme(legend.position = "none"),
      result_5v5_plot,
      text_grob(
        "The good and bad reference lines are at 1 and -1 standard deviations respectively for each measure.\nThe bar length is the z-score relative to all 31 NHL teams so far this season.\nThe orange dot represents the measure over the previous ten games.\nThe gray dot represents the measure over the ten games before that.",
        size = 14,
        family = "Trebuchet MS"
      ),
      nrow = 4,
      ncol = 2,
      heights = c(3, 3, 2, 2)
    )
  
  
  annotate_figure(
    teamdash,
    top = text_grob(
      paste0(verbose_team, " Team Performance\n"),
      face = "bold",
      size = 28,
      family = "Trebuchet MS"
    ),
    bottom = text_grob(
      "All data via naturalstattrick.com, chart by @loserpoints",
      hjust = 1.1,
      x = 1,
      face = "italic",
      size = 18,
      family = "Trebuchet MS"
    )
  )
  
  
  ###### save plot
  
  ggsave(paste0("Viz/team_dash_", Sys.Date(), ".jpg"),
         width = 21.333,
         height = 10.667)
  
}


###### generate team chart using function defined below

generate_team_dashboard()
