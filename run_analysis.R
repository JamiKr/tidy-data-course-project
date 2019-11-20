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
# Note that the last few variables are different from the others in that they appear to describe the angles:
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
# The subject_test.txt and subject_train.txt files contain encodings for the smartphoneData$person,
# which is an integer from 1 to 30.  So, since this data should appear in our table
# for each observation, person should be its own column.

# Similarly, the Y_test.txt and Y_train.txt files contain encodings for the smartphoneData$physicalActivity,
# which is an integer from 1 to 6 that corresponds to a physical activity.  So, since this
# data should appear in our table for each observation, activity should be its own column
# and instead of encoding the activity from 1 to 6, we should apply the text labels as factors.

# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

# In order to merge the train and test datasets, we will need to create another column
# smartphoneData$dataGroup, which will be assigned values of "TEST" or "TRAIN", depending on which
# dataset the datapoint originated in.

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

# Next, let's apply descriptive labels for our activity column, and bind to our data table:

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

# We are now ready to bind by rows, and let's move the dataGroup column to the first position:

print("Binding the test and train datasets ...")

smartphoneData <- rbind(dtTest, dtTrain)
smartphoneData <- smartphoneData %>% select(dataGroup, everything())

# Now we need to label the smartphoneData table with descriptive variable names.  My name replacements:

print("Replacing the variable names with more descriptive labels ...")

names(smartphoneData) <- gsub("Acc", "Accelerometer", names(smartphoneData))
names(smartphoneData) <- gsub("Gyro", "Gyroscope", names(smartphoneData))
names(smartphoneData) <- gsub("Jerk", "JerkSignal", names(smartphoneData))
names(smartphoneData) <- gsub("^t(.*)$", "\\1TimeDomain", names(smartphoneData))
names(smartphoneData) <- gsub("^f(.*)$", "\\1FrequencyDomain", names(smartphoneData))
names(smartphoneData) <- gsub("mean\\(\\)-([XYZ])", "\\1Mean", names(smartphoneData))
names(smartphoneData) <- gsub("std\\(\\)-([XYZ])", "\\1StandardDeviation", names(smartphoneData))
names(smartphoneData) <- gsub("-", "", names(smartphoneData))

# Copy the table contents, so that we can create a tidy dataset.  Remove the first column,
# dataGroup - which is not mentioned in the instructions for calculating the tidy table means,
# so we will fully collapse the TEST and TRAIN datasets into one.  And swap the first two columns,
# so that we display person before their physicalActivity:

print("Preparing the tidy dataset ...")

improved <- copy(smartphoneData)
set(improved, j=c(1L), value=NULL)
tn <- names(improved)
tn[1] <- c("person")
tn[2] <- c("physicalActivity")
setcolorder(improved, tn)

# The final step can be done in more than one way.  I am going to use the ddply function, which is
# described at https://www.r-bloggers.com/say-it-in-r-with-by-apply-and-friends/.  ddply splits the
# data frame, applies a function and returns the results in a data frame.  The second argument
# supplied to ddply is the vector string of variables to split the data frame by.  Since we are
# applying a mean to all of this grouped column data, we must first make sure that we are not applying
# the mean function to our group columns, person and physicalActivity.  So, we first apply a subset
# before we apply the mean function.  The second argument to apply is the margin, which indicates
# either row (1) or column (2).

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
