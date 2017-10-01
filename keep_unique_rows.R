# Clean list so it only contains unique values; keeping the rows with first 
#occurrence of any duplicated values.
# c(1, 2, 3, 3, 4, 5, 6, 7, 7, 8) becomes c(1, 2, 3, 4, 5, 6, 7, 8).

#Sample data
sample_name <- c("apple", "banana", "cocoa", "coco.a", "danno", "dann.o", "d.a.nno")
sample_key <- c("APPLE", "BANANA", "COCOA", "COCOA", "DANNO", "DANNO", "DANNO")
sample_df <- as.data.frame(cbind(sample_name, sample_key))

#expected output: 4 obs, 2 vars.
keep_unique_rows <- function(df, unique_col) {
    dup_ind <- duplicated(df[, unique_col]) # indicates rows with duplicated key
    df <- df[!dup_ind, ] #remove rows with that dup key
    return(df)
}

keep_unique_rows(sample_df, "sample_key")

#same as: sample_df[!duplicated(sample_df[,"sample_key"]), ]
