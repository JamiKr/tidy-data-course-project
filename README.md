# Tidy Smartphone Dataset Derived from the v1 Human Activity Recognition Using Smartphones Dataset

## Summary

The purpose of this script is to process the Human Activity Recognition Using Smartphones Dataset into a tidy dataset of means for 180 total groups, split by study participant and physical activity.  The original test and train datasets were merged, only the average and standard deviation columns were summarized, descriptive column names were applied, and physical activity codings were replaced with descriptive labels.

The original dataset was split into multiple files: The participant id's (which I call `person`), the activities they are doing at the time of data acquisition (`physicalActivity`), and the processed mean and standard deviation accelerometer and gyroscope data (`tBodyAcc-XYZ`, `tGravityAcc-XYZ`, `tBodyAccJerk-XYZ`, etc) for both test and train datasets were merged into one single dataframe.  Then, means were calculated for each combination of person and physicalActivity.

I believe that this constitutes a "tidy" dataset because each individual row now corresponds to a particular piece of data which would be of interest to smartphone developers who might be creating software libraries which identify and react to these "fuzzy" physical states.  When presented in this format, the developers can witness for themselves what sort of differences exist per person for each of the states of physical activity.

## How to Run the Script

To replicate the results of my work, first clone the repository to your own local drive.  It is recommended that you start with a fresh R session to minimize namespace conflicts between packages.  Then, use `setwd()` to change to that directory.  And from inside of the repository on your local drive, run the following command:

> source("run_analysis.R")

The script will download the Human Activity Recognition Using Smartphones Dataset for you and begin processing it.  When it is done, it will display the results with `View()` and save the result to `tidy-smartphone-data.txt`.

## How to View the Results

You need not run the script to view the results.  I have saved a copy of the final tidy dataset in `tidy-smartphone-data-result.txt`, so you can view the results with:

> ts <- read.table("tidy-smartphone-data-result.txt", header = TRUE)
> View(ts)

## The Files

The script should take care of downloading and unzipping [the source data files](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) for you.  What follows is the list of files that the script requires to be present on the drive once the files are downloaded and uncompressed by the script:

`run_analysis.R` - This script converts the Human Activity Recognition Using Smartphones Dataset to a tidy dataset.

`UCI HAR Dataset/features.txt` - This is a list of the variable names for the gyroscope and accelerometer outputs.  Our dataset corresponds to only the mean and standard deviation outputs of this dataset.  For more information on what these values mean, see my [Codebook](http://) provided in this repository.

`UCI HAR Dataset/test/X_test.txt` - Gyroscope and accelerometer data for the test dataset

`UCI HAR Dataset/test/Y_test.txt` - Physical activities that correspond to the test dataset

`UCI HAR Dataset/test/subject_test.txt` - Participant data that corresponds to the test dataset

`UCI HAR Dataset/train/X_train.txt` - Gyroscope and accelerometer data for the train dataset

`UCI HAR Dataset/train/Y_train.txt` - Physical activities that correspond to the train dataset

`UCI HAR Dataset/train/subject_train.txt` - Participant data that corresponds to the test dataset

Note: `run_analysis.R` does not actually use the raw data provided by the Human Activity Recognition Using Smartphones Dataset (the data in directories named `UCI HAR Dataset/Inertial Signals/`).

## The Script

You can learn more about what my script does by reading the comments which are embedded into it:

```
print("Installing packages and loading libraries ...")

install.packages(c("plyr", "dplyr", "data.table"))

library(plyr)
library(dplyr)
library(data.table)

print("Downloading and unzipping the Human Activity Recognition Using Smartphones Dataset ...")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip", mode = "wb")
unzip("data.zip")
setwd("UCI HAR Dataset/")

print("Extracting the desired variable names ...")

rawFeatures <- read.table("features.txt", sep = " ")
features <- grep("^.*-(mean|std)\\(\\)-[XYZ]$", rawFeatures$V2)
featureNames <- rawFeatures[grepl("^.*-(mean|std)\\(\\)-[XYZ]$", rawFeatures$V2), 2]

# rawFeatures = 561 variables
# features = 48 variables (just the means and standard deviations)
# Note that the last few variables are different from the others in that
# they appear to describe the angles:
# 555 angle(tBodyAccMean,gravity)
# 556 angle(tBodyAccJerkMean),gravityMean)
# 557 angle(tBodyGyroMean,gravityMean)
# 558 angle(tBodyGyroJerkMean,gravityMean)
# 559 angle(X,gravityMean)
# 560 angle(Y,gravityMean)
# 561 angle(Z,gravityMean)

print("Reading all relevant tables ...")

rawxTest <- read.table("./test/X_test.txt")
rawyTest <- read.table("./test/Y_test.txt")
rawxTrain <- read.table("./train/X_train.txt")
rawyTrain <- read.table("./train/Y_train.txt")
rawSubjectTest <- read.table("./test/subject_test.txt")
rawSubjectTrain <- read.table("./train/subject_train.txt")

# TRAIN:
# rawxTrain = 7352 obs. of 561 variables
# rawyTrain = 7352 obs. of 1 variable
# rawSubjectTrain = 7352 obs. of 1 variable

# TEST:
# rawxTest = 2947 obs. of 561 variables
# rawyTest = 2947 obs. of 1 variable
# rawSubjectTest = 2947 obs. of 1 variable

# So, there are 7352 observations for train and 2947 observations for test.
# The subject_test.txt and subject_train.txt files contain encodings for
# the smartphoneData$person, which is an integer from 1 to 30.  So, since
# this data should appear in our table for each observation, person should
# be its own column.

# Similarly, the Y_test.txt and Y_train.txt files contain encodings for the 
# smartphoneData$physicalActivity, which is an integer from 1 to 6 that
# corresponds to a physical activity.  So, since this data should appear in
# our table for each observation, activity should be its own column
# and instead of encoding the activity from 1 to 6, we should apply the text 
# labels as factors.

# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

# In order to merge the train and test datasets, we will need to create 
# another column smartphoneData$dataGroup, which will be assigned values of
# "TEST" or "TRAIN", depending on which dataset the datapoint originated in.

# Add the dataGroup column designating "TEST" or "TRAIN" for each measurement:

train <- rawxTrain[, features]
colnames(train) <- featureNames
dtTrain <- tbl_df(train)
dtTrain <- mutate(dtTrain, dataGroup = "TRAIN")

test <- rawxTest[, features]
colnames(test) <- featureNames
dtTest <- tbl_df(test)
dtTest <- mutate(dtTest, dataGroup = "TEST")

# Now bind the person column for both data tables:

print("Binding the person column ...")

names(rawSubjectTrain) <- c("person")
dtTrain <- cbind(rawSubjectTrain, dtTrain)
names(rawSubjectTest) <- c("person")
dtTest <- cbind(rawSubjectTest, dtTest)

# Next, let's apply descriptive labels for our activity column, and bind
# to our data table:

print("Applying descriptive labels for physical activity ...")

transformToActivityLabel <- function(n) {
    c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")[n]
}

yTrain <- rawyTrain
colnames(yTrain) <- c("physicalActivity")
dtyTrain <- tbl_df(yTrain)
dtyTrain <- mutate(dtyTrain, physicalActivity = transformToActivityLabel(physicalActivity))
dtTrain <- cbind(dtyTrain, dtTrain)

yTest <- rawyTest
colnames(yTest) <- c("physicalActivity")
dtyTest <- tbl_df(yTest)
dtyTest <- mutate(dtyTest, physicalActivity = transformToActivityLabel(physicalActivity))
dtTest <- cbind(dtyTest, dtTest)

# We are now ready to bind by rows, and let's move the dataGroup column to
# the first position:

print("Binding the test and train datasets ...")

smartphoneData <- rbind(dtTest, dtTrain)
smartphoneData <- smartphoneData %>% select(dataGroup, everything())

# Now we need to label the smartphoneData table with descriptive variable 
# names.  My name replacements:

print("Replacing the variable names with more descriptive labels ...")

names(smartphoneData) <- gsub("Acc", "Accelerometer", names(smartphoneData))
names(smartphoneData) <- gsub("Gyro", "Gyroscope", names(smartphoneData))
names(smartphoneData) <- gsub("Jerk", "JerkSignal", names(smartphoneData))
names(smartphoneData) <- gsub("^t(.*)$", "\\1TimeDomain", names(smartphoneData))
names(smartphoneData) <- gsub("^f(.*)$", "\\1FrequencyDomain", names(smartphoneData))
names(smartphoneData) <- gsub("mean\\(\\)-([XYZ])", "\\1Mean", names(smartphoneData))
names(smartphoneData) <- gsub("std\\(\\)-([XYZ])", "\\1StandardDeviation", names(smartphoneData))
names(smartphoneData) <- gsub("-", "", names(smartphoneData))

# Copy the table contents, so that we can create a tidy dataset.  Remove the 
# first column, dataGroup - which is not mentioned in the instructions for
# calculating the tidy table means, so we will fully collapse the TEST and 
# TRAIN datasets into one.  And swap the first two columns, so that we display
# person before their physicalActivity:

print("Preparing the tidy dataset ...")

improved <- copy(smartphoneData)
set(improved, j=c(1L), value=NULL)
tn <- names(improved)
tn[1] <- c("person")
tn[2] <- c("physicalActivity")
setcolorder(improved, tn)

# The final step can be done in more than one way.  I am going to use the 
# ddply function, which is described at https://www.r-bloggers.com/
# say-it-in-r-with-by-apply-and-friends/.  ddply splits the data frame,
# applies a function and returns the results in a data frame.  The second
# argument supplied to ddply is the vector string of variables to split the 
# data frame by.  Since we are applying a mean to all of this grouped column
# data, we must first make sure that we are not applying the mean function to
# our group columns, person and physicalActivity.  So, we first apply a subset
# before we apply the mean function.  The second argument to apply is the 
# margin, which indicates either row (1) or column (2).

final <- ddply(improved, c("person", "physicalActivity"),
               function(x) {
                   y <- subset(x, select = -c(person, physicalActivity))
                   apply(y, 2, mean)
               }
         )

# Now we have a tidy dataset:

print("Done!  The result is a data frame stored in the variable final.  A copy of the data frame has also been saved to tidy-smartphone-data.txt.")
View(final)
write.table(final, "../tidy-smartphone-data.txt")

```
