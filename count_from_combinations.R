library(data.table)
library(dplyr)
library(tidyr)
#Cleaning data formatted as counts of combinations; single-column.
# 111 "string1, string2"
# 4   "string1"
# 31  "string2, string3, string4, string5"
# 14  "string4, string5"
# 10  "string5"
# 
# into format:
# 115 string1
# 142 string2
# 31  string3
# 45  string4
# 55  string5


#Build fake dataset
values <- as.vector(c(111, 4, 31, 14, 10))
strings <- c("string1, string2", "string1", 
             "string2, string3, string4, string5", 
             "string4, string5", 
             "string5")


df <- cbind(values, strings) %>% 
        as.data.table()
#Find number of strings in the longest row
longest_combo <- max(sapply(strsplit(as.character(df$strings), ','), length))

longest_combo <- df$strings %>% 
                   as.character() %>% 
                   strsplit(',') %>%
                   sapply(length) %>%
                   max()

#split strings on delimiter in individual columns
separate(data = df, col = strings, into = paste0('x', 1:longest_combo), 
         sep = ',', fill = 'right', convert = TRUE) 

#After splitting it, the data format to:
#    values      x1       x2       x3       x4
# 1:    111 string1  string2       NA       NA
# 2:      4 string1       NA       NA       NA
# 3:     31 string2  string3  string4  string5
# 4:     14 string4  string5       NA       NA
# 5:     10 string5       NA       NA       NA


#for each row of df, fill in new table with cell 1 [value], 
#then for each column 'xn' create a new row with its df row's value.

df.separated <- data.frame()

for (i in 1:nrows(df$values)) {
  for (j in 2:sum(!is.na(df[i,]))) {
    #TODO - df.separated[i,1] <- df[i,(j-1)]
  }
}
  