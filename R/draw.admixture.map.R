# TO DO: Explain here what this script does, and how to use it.
library(ggplot2)
library(maps)

# SCRIPT PARAMETERS
# -----------------
k <- 1
map.data.file <- "../data/mapdata.admixture.K=11.ancestry.txt"

# Read the map data.
locs <- read.table(map.data.file,sep = " ",header = TRUE,
                   stringsAsFactors = FALSE)
locs <- transform(locs,K = factor(K))
locs <- transform(locs,OR = cut(pmin(OR,999),breaks = c(0,1,2,10,100,1000)))

# Keep only map data for the selected population.
locs <- subset(locs,K == 2)

# Display the World map.
dev.new(height = 6,width = 13.5)
print(ggplot() + theme_minimal() +
      theme(plot.title = element_text(size = 10)) + 
      
      # Shows the country borders.
      geom_path(data = map_data("world"),aes(x = long,y = lat,group = group),
                colour = "gray",size = 0.25) +

      # Plot a circle for each location, in which the area of the
      # circle is proportional to the number of tree entries at that
      # location, and the colour corresponds to the odds ratio.
      geom_point(data = locs,aes(x=x,y=y,size=sqrt(n1),color=OR)) +
      scale_size(range = c(1,4)) +
      scale_alpha_discrete(range = c(0.75,1)) + 
      
      # Specifies the plotting parameters.
      scale_color_manual(values=c("lightskyblue","dodgerblue","darkorange",
                           "red","darkred")) +
      coord_cartesian(xlim = c(-180,190),ylim = c(-55,80)) +
      scale_x_continuous(breaks = NULL) + 
      scale_y_continuous(breaks = NULL) + 
      theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()))
