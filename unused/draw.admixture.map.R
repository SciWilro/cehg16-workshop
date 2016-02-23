# This script plots population-associated ancestral birth location
# data on a world map. Before running this script, you need to specify
# two parameters:
#
#   k: index of ancestral population (1-11).
#
#   map.data.file: space-delimited text file containing map data
#   (sample counts, latitudes, longitudes and odds ratios).
#
library(ggplot2)
library(maps)

# SCRIPT PARAMETERS
# -----------------
k             <- 2
map.data.file <- "../data/mapdata.admixture.K=11.ancestry.txt"

# READ MAP DATA
# -------------
# Here, I keep only map data for the selected population, and I bin
# the odds ratios (OR) for a more attractive plot.
locs <- read.table(map.data.file,sep = " ",header = TRUE,
                   stringsAsFactors = FALSE)
locs <- transform(locs,
                  K  = factor(K),
                  OR = cut(pmax(0.1,pmin(OR,999)),
                           breaks = c(0,1,2,10,100,1000)))
locs <- subset(locs,K == k)

# PLOT DATA ON WORLD MAP
# ----------------------
dev.new(height = 6,width = 13.5)
print(ggplot() + theme_minimal() +
      
      # Shows the country borders.
      geom_path(data = map_data("world"),aes(x = long,y = lat,group = group),
                colour = "gray",size = 0.25) +

      # Plot a circle for each location, in which the area of the
      # circle is proportional to the number of ancestral birth
      # annotations at that location, and the colour corresponds to
      # the odds ratio.
      geom_point(data = locs,aes(x=x,y=y,size=sqrt(n1),color=OR)) +
      scale_size(range = c(1,4)) +
      
      # Specifies the plotting parameters. Uncomment this line here to
      # colour the map locations based on odds ratio.
      #
      #   scale_color_manual(values=c("lightskyblue","dodgerblue",
      #                               "darkorange","red","darkred")) +
      #
      scale_color_manual(values = rep("blue",5)) + 
      coord_cartesian(xlim = c(-180,190),ylim = c(-55,80)) +
      scale_x_continuous(breaks = seq(-180,190,10)) + 
      scale_y_continuous(breaks = seq(-55,80,10)) + 
      theme(panel.grid.major = element_line(color = "lightskyblue",size = 0.1),
            panel.grid.minor = element_blank(),
            plot.title       = element_text(size = 9),
            axis.text.x      = element_text(size = 8,angle = 45),
            axis.text.y      = element_text(size = 8,hjust = 0)) +
      labs(title = paste("file = ",map.data.file,", K = ",k,sep=""),
           x = "", y = ""))
