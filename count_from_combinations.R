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
valuesCol <- as.vector(c(111, 4, 31, 14, 10))
stringsCol <- c("string1, string2", "string1", 
             "string2, string3, string4, string5", 
             "string4, string5", 
             "string5")
df <- cbind(valuesCol, stringsCol) %>% 
        as.data.table()

reshape_colofdelimitedvalues <- function(df, valuesCol, stringsCol) {
    #Remove whitespace
    df$stringsCol <- as.data.table(gsub(" ", "", df$stringsCol, fixed = TRUE))
    
    #Find number of strings in the longest row
    longest_combo <- df$stringsCol %>% 
                       as.character() %>% 
                       strsplit(',') %>%
                       sapply(length) %>%
                       max()
    
    #split strings on delimiter in individual columns
    df2 <- separate(data = df, col = stringsCol, into = paste0('x', 1:longest_combo), 
             sep = ',', fill = 'right', convert = TRUE) 

    #After splitting it, the data format to:
    #    values      x1       x2       x3       x4
    # 1:    111 string1  string2       NA       NA
    # 2:      4 string1       NA       NA       NA
    # 3:     31 string2  string3  string4  string5
    # 4:     14 string4  string5       NA       NA
    # 5:     10 string5       NA       NA       NA
    
    
    #how long will the new long table be?  
    #(Num non-NA cells) - (cells with values) = (num rows in new table)
    df.seprows <- sum(!is.na(df2)) - nrow(df2)
    
    #initialize a new data table 2 cols wide, and as long as it will need to be.
    df.separated <- data.table(matrix(ncol = 2, nrow = df.seprows))
    #name the columns "values" and "strings".
    colnames <- c("values","strings")
    names(df.separated) <- colnames
    df.separated$values <- as.numeric(df.separated$values)
    df.separated$strings <- as.character(df.separated$strings)
    
    k = 1                                 #k will be the kth row of our new table
    for (i in 1:length(df2$valuesCol)) {   #For each row,
      for (j in 2:sum(!is.na(df2[i,]))) {  #For each column containing a string,
        df.separated[k,1] <- as.numeric(df2[i, 1, with = FALSE])  #assign the value to [k,1]
        df.separated[k,2] <- as.character(df2[i, j, with = FALSE])  #assign the jth string to [k,2]
        k <- k + 1                        #move on to the next string in the row.
      }
    }
    
    # df.separated now looks like!
    # values  strings
    # 111     string1
    # 111     string2
    # 4       string1
    # 31      string2
    # 31      string3
    # 31      string4
    # 31      string5
    # 14      string4
    # 14      string5
    # 10      string5

    df.separated$strings <- as.factor(df.separated$strings)
    
    df3 <- df.separated %>%
      group_by(strings) %>%
      summarise(stringVar = sum(values))
    
    # Voila!!  df2 now looks like:  
    # # A tibble: 5 x 2
    # strings stringVar
    # <fctr>     <dbl>
    # string1       115
    # string2       142
    # string3        31
    # string4        45
    # string5        55

    return(df3)
}

#to run our fake set, run: reshape_colofdelimitedvalues(df, values, strings)
testtest <- reshape_colofdelimitedvalues(df, values, strings)
