library(reshape)
library(dplyr)


root<-'~/git/data_visualization/r_shiny_world_development_indicator/'
file_le<-paste(root,'API_SP.DYN.LE00.IN_DS2_en_csv_v2/API_SP.DYN.LE00.IN_DS2_en_csv_v2.csv',sep='')
file_fertility<-paste(root,'API_SP.DYN.TFRT.IN_DS2_en_csv_v2/API_SP.DYN.TFRT.IN_DS2_en_csv_v2.csv',sep='')
file_meta<-paste(root,'API_SP.DYN.TFRT.IN_DS2_en_csv_v2/Metadata_Country_API_SP.DYN.TFRT.IN_DS2_en_csv_v2.csv',sep='')

########################

get_data<-function(filepath){
  # clean data, remove NAs, remove useless cols
  
  data<-read.csv(filepath, skip=4)
  
  names(data)<-append(names(data)[1:4],1960:2017)
  data<-data[,1:59]
  data<-data[complete.cases(data),]  
  return(data)
}

get_meta_table<-function(){
  # get meta_table, remove useless cols
  meta_table<-read.csv(file_meta,header = TRUE,na.strings = c('','NA'))
  meta_table<-meta_table[,1:3]
  return(meta_table)
}

get_merged_data<-function(){
  # return two dataframe in a list
  
  # get table- data_le, data_fertility, meta_table
  data_le<-get_data(file_le)
  data_fertility<-get_data(file_fertility)
  meta_table<-get_meta_table()
  # merge Region cols into data_le, data_fertility
  df_fertility<-merge(data_fertility, meta_table, by='Country.Code')
  df_le<-merge(data_le,meta_table, by='Country.Code')
  # drop unnecessary cols (Indicator.Name, Indicator.Code, ..)
  df_le<-df_le[,c(-3,-4, -61)]
  df_fertility<-df_fertility[,c(-3,-4, -61)] 
  results<-list(df_le,df_fertility)
  return(results)
}

melt_table<-function(df_le, df_fertility){
  melted_le<-melt(df_le, id=c('Country.Code','Country.Name','Region'))
  melted_le<-dplyr::rename(melted_le, Year=variable, Life.Expectancy=value)
  melted_fertility<-melt(df_fertility, id=c('Country.Code','Country.Name','Region'))
  melted_fertility<-dplyr::rename(melted_fertility, Year=variable,Fertility.Rate=value)
  results<-list(melted_le,melted_fertility)
  return(results)
}

main<-function(){
  results<-get_merged_data()
  df_le<-results[[1]]
  df_fertility<-results[[2]]
  
  melted_le<-melt_table(df_le, df_fertility)[[1]]
  melted_fertility<-melt_table(df_le, df_fertility)[[2]]
  
  super_data<-merge(melted_le, melted_fertility, on=c('Country.Code','Country.Name','Region', 'Year'))
  super_data<-super_data[complete.cases(super_data), ]
  super_data$Region <- as.factor(super_data$Region)
  # saveRDS(super_data, file='super_data.rds')
  # write.csv(super_data_path)
  return(super_data)
}




###########################
# for testing
make_plot<-function(yr){
  library(ggplot2)
  g<-ggplot(subset(super_data, Year==yr), aes(Life.Expectancy, Fertility.Rate, color=Region))
  g+geom_point()
}
# make_plot(1960)
############################

data<-main()
