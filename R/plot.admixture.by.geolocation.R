library ('rworldmap') #this library is needed to load higher reolution world map
library('ggmap') #we use ggmap only for geocoding functionality
library('mapplots') #to overlay pie charts on a map

#loading admixture data for K=7
admix7=read.table("../data/admixture/1kg_hgdp.7.Q")
# loading id and pop labels
labels=read.table("../data/panel/1kg_hgdp.lab",header = T)
# combining the two tables 
lab_admix=cbind(labels,admix7)
# loading information regarding geographic location corresponding to each 1kg population labels
lab_loc=read.table("../data/panel/1kg.lab.loc",header = T,sep="\t",stringsAsFactors=F)
# using geocode from ggmap package we retrieve lat/lon info using google map API for each location
lab_loc=cbind(lab_loc,geocode(lab_loc$loc))
# creating a table containing lat/lon and admixture proportions for each individual
lab_latlon_admix=merge(lab_loc,lab_admix,by="label")[,c("label","lat","lon","V1","V2","V3","V4","V5","V6","V7")] #

#calculating average admixture proportion for each population
x=aggregate(lab_latlon_admix[,2:10],by=list(lab_latlon_admix$label),FUN=mean)

# fetching world map
mp=getMap(resolution='high')
# chosing the color for filling the countries on the map
colourPalette=rep("grey50",7)
# ploting the map
mapCountryData(mp,colourPalette=colourPalette,addLegend=F,mapTitle='1KG Admix Proportions')

# overlay pie charts of admixture proportions corresponding to each population
for (i in 1:nrow(x)){
add.pie(z=as.numeric(x[i,4:10]),y=x[i,]$lat,x=x[i,]$lon,radius=3,labels=x[i,1],col=c(1,2,3,4,5,6,7),label.dist = 2,cex=0.8)
}
#adding the legend  
legend(x=-10,y=-50,col=c(1,2,3,4,5,6,7),legend=c("K1","K2","K3","K4","K5","K6","K7"),pch=15,horiz=T)
