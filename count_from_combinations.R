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
values <- c(111, 4, 31, 14, 10)
strings <- c("string1, string2", "string1", 
             "string2, string3, string4, string5", 
             "string4, string5", 
             "string5")


dummy <- cbind(values, strings)
