library(dplyr)

## Ensures that the dataset is downloaded. If a folder named "UCI HAR Dataset" is
## not found, the zip file hosted on Cloudfront is downloaded, extracted, and
## then removed. Does nothing if the aformentioned directory exists.
ensure_downloaded <- function() {
  if (!dir.exists("UCI HAR Dataset")) {
    # Download the data if it doesn't already exist in the working dir
    zipFile <- "data.zip"
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zipFile)
    
    unzip(zipFile)
    
    # Clean up
    file.remove(zipFile)
  }
}

## Loads part of the dataset. Assumes there are files at the given locations:
##
##   - ${base_dir}/${name}/y_${name}.txt
##   - ${base_dir}/${name}/X_${name}.txt
##   - ${base_dir}/${name}/subject_${name}.txt
##
## For example, if the name was "foo", this function would attempt to load
## subject_foo.txt, X_foo.txt, and y_foo.txt from the "UCI HAR Dataset/foo"
## directory.
##
## @param name The name of this portion of the data. For this dataset, this value
##             should either be "train" or "test"
## @param features A character vector. Should have the same length as the number
##                 of columns in "X_${name}.txt".
## @param activities A factor of activities. For this dataset, these should be
##                   loaded from "UCI HAR Dataset/activity_labels.txt".
## @param feature_pattern A regular expression. Only columns whose names match
##                        this expression will be included. Defaults to a regex
##                        that matches a string if it contains the string
##                        "mean()" or the string "std()"
## @param base_dir The directory to which all files will be read from. Defaults
##                 to "UCI HAR Dataset".
load_partial_dataset <- function(name, activities, features,
                                 feature_pattern = "(mean|std)\\(\\)",
                                 base_dir = "UCI HAR Dataset") {
  
  part_base <- file.path(base_dir, name)
  
  X <- read.table(file.path(part_base, paste0("X_", name, ".txt")))
  y <- read.table(file.path(part_base, paste0("y_", name, ".txt")))$V1
  performed_activities <- activities[y]
  subject <- read.table(file.path(part_base, paste0("subject_", name, ".txt")))$V1
  
  # Mash the three files together
  dataset_part <- cbind(subject = subject, activity = performed_activities, X = X)
  
  # Find the columns that match the feature pattern. Add 2 to all indicies
  # because we're adding two "features" of our own to the very left of the table
  # that are automatically included.
  wanted_features <- grep(feature_pattern, features)
  column_indicies <- append(1:2, wanted_features + 2)
  
  # Set the names for the dataset. "subject" and "feature" are added to the
  # left, followed by all the included features.
  names(dataset_part) <- append(features, c("subject", "activity"), after = 0)
  dataset_part[, column_indicies]
}

## Reads the test and training data and merges it into one dataset using the
## provided. Only includes the mean and standard deviation features.
merge_orignal_dataset <- function() {
  # Make sure we actually have the data
  ensure_downloaded()
  
  # Read the activity labels and features
  act_labels <- read.table("UCI HAR Dataset/activity_labels.txt")$V2
  features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)$V2
  
  # Load each section of the dataset
  partial_datasets <- lapply(c("train", "test"), load_partial_dataset, activities = act_labels, features = features)
  
  # Combine the test and training data into the whole dataset. Call rbind using
  # do.call() so that we can dynamicaly specify the paramters. Equivalent to
  # rbind(partial_datasets[1], partial_datasets[2], ..., partial_datasets[N])
  dataset <- do.call(rbind, partial_datasets)
  dataset
}

## Performs sequential replacements on a vector of data frame names. For each
## element in the replacements list, the first value will be used as the regex
## and the second will be used as the replacement.
create_names <- function(df, replacements = list()) {
  n <- names(df)
  for (repl in replacements) {
    n <- sub(repl[1], repl[2], n)
  }
  
  n
}

# Prepares and merges the orignal dataset and then creates a new, tidy dataset.
run_analysis <- function() {
  original <- merge_orignal_dataset()
  
  names(original) <- create_names(original, list(
    # Make features that strt with "f" start with "frequency"
    c("^f", "frequency"),
    # Same thing for "t" and "time"
    c("^t", "time"),
    # Remove parenthesis from mean() and std()
    c("\\(\\)", "")
  ))
  
  original %>%
    # Group by each activity and subject
    group_by(activity, subject) %>%
    # Summarize all the other features by taking their mean
    summarize_all(mean)
}

# Only run the script if being run non-interactively so that sourcing this file
# isn't computationally expensive. To call in an R shell (e.g. the R command
# line or in R studio), source this file then run the run_analysis function.
if (!interactive()) {
  tidy <- run_analysis()
  
  # Save the new dataset to disk as a CSV file
  out_path <- file.path(normalizePath("."), "tidy.csv")
  write.csv(tidy, out_path, row.names = FALSE)
  
  # Let the user know
  message(paste0("Wrote tidy dataset to ", out_path))
}
