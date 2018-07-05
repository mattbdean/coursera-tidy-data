# coursera-tidy-data

This script operates on the UCI Human Activity Recognition Using Smartphones dataset.

This script:

 1. Downloads and extracts the dataset
 1. Merges the test and training data back into one dataset. This is a machine learning dataset, so about 30% of the data are excluded to test the accuracy of the trained model.
 2. Extracts only the mean and standard deviation features
 3. Creates a new, tidy dataset in the form of a CSV file in the current directory.

## Requirements

 - dplyr (tested with 0.7.6)

## Running

To run from the command line:

```sh
$ Rscript run_analysis.R
```

If everything works correctly, there will be a file called `tidy.csv` in the current directory.

To read these data in R:

```R
tidy_dataset <- read.csv("tidy.csv")
```

To run from an interactive R shell (e.g. RStudio):

```R
source("run_analysis.R")
tidy_dataset <- run_analysis()
```

No CSV file will be created if run in this manner.

## Output

The output of the `run_analysis.R` script or the `run_analysis()` function is tabular data with 68 variables and 180 observations. Each observation contains the subject's ID (1-30), the activity (`LAYING`, `WALKING`, etc.), and 62 measured features. Only the average of those features are present in the new dataset.

### Code book

The following is a more in-depth glance of all the features of the dataset created by the `run_analysis()` function.

#### Identity features

Each unique combination of these features defines a single observation. There are no rows that have the same subject and the same activity.

 - `subject` - The subject ID (1-30). Each subject is between 19 and 48 years old.
 - `activity` - What activity the subject was performing. Values include: `WALKING`, `WALKING_UPSTAIRS`, `WALKING_DOWNSTAIRS`, `SITTING`, `STANDING`, and `LAYING`.

#### Measured features

Each measured field consists of a name (e.g. `timeBodyAcc`), a function (either "mean" or "std"), and optionally, an axis ("X", "Y", or "Z"). Each feature has been normalized to be in the range of [-1, 1].

 - `timeBodyAcc.mean.X`
 - `timeBodyAcc.mean.Y`
 - `timeBodyAcc.mean.Z`
 - `timeBodyAcc.std.X`
 - `timeBodyAcc.std.Y`
 - `timeBodyAcc.std.Z`
 - `timeGravityAcc.mean.X`
 - `timeGravityAcc.mean.Y`
 - `timeGravityAcc.mean.Z`
 - `timeGravityAcc.std.X`
 - `timeGravityAcc.std.Y`
 - `timeGravityAcc.std.Z`
 - `timeBodyAccJerk.mean.X`
 - `timeBodyAccJerk.mean.Y`
 - `timeBodyAccJerk.mean.Z`
 - `timeBodyAccJerk.std.X`
 - `timeBodyAccJerk.std.Y`
 - `timeBodyAccJerk.std.Z`
 - `timeBodyGyro.mean.X`
 - `timeBodyGyro.mean.Y`
 - `timeBodyGyro.mean.Z`
 - `timeBodyGyro.std.X`
 - `timeBodyGyro.std.Y`
 - `timeBodyGyro.std.Z`
 - `timeBodyGyroJerk.mean.X`
 - `timeBodyGyroJerk.mean.Y`
 - `timeBodyGyroJerk.mean.Z`
 - `timeBodyGyroJerk.std.X`
 - `timeBodyGyroJerk.std.Y`
 - `timeBodyGyroJerk.std.Z`
 - `timeBodyAccMag.mean`
 - `timeBodyAccMag.std`
 - `timeGravityAccMag.mean`
 - `timeGravityAccMag.std`
 - `timeBodyAccJerkMag.mean`
 - `timeBodyAccJerkMag.std`
 - `timeBodyGyroMag.mean`
 - `timeBodyGyroMag.std`
 - `timeBodyGyroJerkMag.mean`
 - `timeBodyGyroJerkMag.std`
 - `frequencyBodyAcc.mean.X`
 - `frequencyBodyAcc.mean.Y`
 - `frequencyBodyAcc.mean.Z`
 - `frequencyBodyAcc.std.X`
 - `frequencyBodyAcc.std.Y`
 - `frequencyBodyAcc.std.Z`
 - `frequencyBodyAccJerk.mean.X`
 - `frequencyBodyAccJerk.mean.Y`
 - `frequencyBodyAccJerk.mean.Z`
 - `frequencyBodyAccJerk.std.X`
 - `frequencyBodyAccJerk.std.Y`
 - `frequencyBodyAccJerk.std.Z`
 - `frequencyBodyGyro.mean.X`
 - `frequencyBodyGyro.mean.Y`
 - `frequencyBodyGyro.mean.Z`
 - `frequencyBodyGyro.std.X`
 - `frequencyBodyGyro.std.Y`
 - `frequencyBodyGyro.std.Z`
 - `frequencyBodyAccMag.mean`
 - `frequencyBodyAccMag.std`
 - `frequencyBodyBodyAccJerkMag.mean`
 - `frequencyBodyBodyAccJerkMag.std`
 - `frequencyBodyBodyGyroMag.mean`
 - `frequencyBodyBodyGyroMag.std`
 - `frequencyBodyBodyGyroJerkMag.mean`
 - `frequencyBodyBodyGyroJerkMag.std`
