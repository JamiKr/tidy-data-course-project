# Codebook for the Tidy Smartphone Dataset Derived from the v1 Human Activity Recognition Using Smartphones Dataset

## Prior Processing

It is important to understand that the data used in our script was derived from another, the v1 [Human Activity Recognition Using Smartphones Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  There is documentation packaged with the original zipped contents which describes the acquisition of the original dataset.  Here is an excerpt from `UCI Har Dataset/features_info.txt`:

```
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.
```

## The Tidy Codes

Important: Each datapoint in our tidy dataset is produced by averaging groups of mean and standard deviation data which correspond to participant and physical activity.

The original dataset consisted of 10,299 sets of measurements across 561 variables.  I have selected only the mean and standard deviation variables from the 561 total (listed below), which when merged with the participant and physical activity variables totals to 50 variables for our `final` dataframe.

There are 30 partipants and 6 physical activities, which produces a total of 180 groups.  So, our final tidy dataset consists of 10,299 / 180 tidy datapoints = 57 or 58 averaged means and standard deviations per tidy datapoint.

### Group Variables

`person` - participant identification number (1 - 30)
`physicalActivity` - participant activity; one of "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", or "LAYING"

### Time Domain Signals

`BodyAccelerometerXMeanTimeDomain` - X-axial mean body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerYMeanTimeDomain` - Y-axial mean body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerZMeanTimeDomain` - Z-axial mean body component of the accelerometer, averaged per participant and activity combination

`BodyAccelerometerXStandardDeviationTimeDomain` - Mean standard deviation of the X-axial body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerYStandardDeviationTimeDomain` - Mean standard deviation of the Y-axial body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerZStandardDeviationTimeDomain` - Mean standard deviation of the Z-axial body component of the accelerometer, averaged per participant and activity combination

`GravityAccelerometerXMeanTimeDomain` - X-axial mean gravity component of the accelerometer, averaged per participant and activity combination
`GravityAccelerometerYMeanTimeDomain` - Y-axial mean gravity component of the accelerometer, averaged per participant and activity combination
`GravityAccelerometerZMeanTimeDomain` - Z-axial mean gravity component of the accelerometer, averaged per participant and activity combination

`GravityAccelerometerXStandardDeviationTimeDomain` - Mean standard deviation of the X-axial gravity component of the accelerometer, averaged per participant and activity combination
`GravityAccelerometerYStandardDeviationTimeDomain` - Mean standard deviation of the Y-axial gravity component of the accelerometer, averaged per participant and activity combination
`GravityAccelerometerZStandardDeviationTimeDomain` - Mean standard deviation of the Z-axial gravity component of the accelerometer, averaged per participant and activity combination

`BodyAccelerometerJerkSignalXMeanTimeDomain` - X-axial mean body jerk signal computed from the accelerometer data, averaged per participant and activity combination
`BodyAccelerometerJerkSignalYMeanTimeDomain` - Y-axial mean body jerk signal computed from the accelerometer data, averaged per participant and activity combination
`BodyAccelerometerJerkSignalZMeanTimeDomain` - Z-axial mean body jerk signal computed from the accelerometer data, averaged per participant and activity combination

`BodyAccelerometerJerkSignalXStandardDeviationTimeDomain` - Mean standard deviation of the X-axial body jerk computed from accelerometer data, averaged per participant and activity combination
`BodyAccelerometerJerkSignalYStandardDeviationTimeDomain` - Mean standard deviation of the Y-axial body jerk computed from accelerometer data, averaged per participant and activity combination
`BodyAccelerometerJerkSignalZStandardDeviationTimeDomain` - Mean standard deviation of the Z-axial body jerk computed from accelerometer data, averaged per participant and activity combination

`BodyGyroscopeXMeanTimeDomain` - X-axial mean body component of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeYMeanTimeDomain` - Y-axial mean body component of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeZMeanTimeDomain` - Z-axial mean body component of the gyroscope, averaged per participant and activity combination

`BodyGyroscopeXStandardDeviationTimeDomain` - Mean standard deviation of the X-axial body component of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeYStandardDeviationTimeDomain` - Mean standard deviation of the Y-axial body component of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeZStandardDeviationTimeDomain` - Mean standard deviation of the Z-axial body component of the gyroscope, averaged per participant and activity combination

`BodyGyroscopeJerkSignalXMeanTimeDomain` - X-axial mean body jerk signal computed from the gyroscope data, averaged per participant and activity combination
`BodyGyroscopeJerkSignalYMeanTimeDomain` - Y-axial mean body jerk signal computed from the gyroscope data, averaged per participant and activity combination
`BodyGyroscopeJerkSignalZMeanTimeDomain` - Z-axial mean body jerk signal computed from the gyroscope data, averaged per participant and activity combination

`BodyGyroscopeJerkSignalXStandardDeviationTimeDomain` - Mean standard deviation of the X-axial body jerk computed from gyroscope data, averaged per participant and activity combination
`BodyGyroscopeJerkSignalYStandardDeviationTimeDomain` - Mean standard deviation of the Y-axial body jerk computed from gyroscope data, averaged per participant and activity combination
`BodyGyroscopeJerkSignalZStandardDeviationTimeDomain` - Mean standard deviation of the Z-axial body jerk computed from gyroscope data, averaged per participant and activity combination

### Frequency Domain Signals

`BodyAccelerometerXMeanFrequencyDomain` - Mean frequency domain signal of the X-axial body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerYMeanFrequencyDomain` - Mean frequency domain signal of the Y-axial body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerZMeanFrequencyDomain` - Mean frequency domain signal of the Z-axial body component of the accelerometer, averaged per participant and activity combination

`BodyAccelerometerXStandardDeviationFrequencyDomain` - Mean frequency domain signal of the standard deviation of the X-axial body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerYStandardDeviationFrequencyDomain` - Mean frequency domain signal of the standard deviation of the Y-axial body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerZStandardDeviationFrequencyDomain` - Mean frequency domain signal of the standard deviation of the Z-axial body component of the accelerometer, averaged per participant and activity combination

`BodyAccelerometerJerkSignalXMeanFrequencyDomain` - Mean frequency domain signal of the X-axial mean body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerJerkSignalYMeanFrequencyDomain` - Mean frequency domain signal of the Y-axial mean body component of the accelerometer, averaged per participant and activity combination
`BodyAccelerometerJerkSignalZMeanFrequencyDomain` - Mean frequency domain signal of the Z-axial mean body component of the accelerometer, averaged per participant and activity combination

`BodyAccelerometerJerkSignalXStandardDeviationFrequencyDomain` - Mean frequency domain signal of the X-axial body jerk signal standard deviation computed from the accelerometer data, averaged per participant and activity combination
`BodyAccelerometerJerkSignalYStandardDeviationFrequencyDomain` - Mean frequency domain signal of the Y-axial body jerk signal standard deviation computed from the accelerometer data, averaged per participant and activity combination
`BodyAccelerometerJerkSignalZStandardDeviationFrequencyDomain` - Mean frequency domain signal of the Z-axial body jerk signal standard deviation computed from the accelerometer data, averaged per participant and activity combination

`BodyGyroscopeXMeanFrequencyDomain` - Mean frequency domain signal of the X-axial body component of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeYMeanFrequencyDomain` - Mean frequency domain signal of the Y-axial body component of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeZMeanFrequencyDomain` - Mean frequency domain signal of the Z-axial body component of the gyroscope, averaged per participant and activity combination

`BodyGyroscopeXStandardDeviationFrequencyDomain` - Mean frequency domain signal of the X-axial body component standard deviation of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeYStandardDeviationFrequencyDomain` - Mean frequency domain signal of the Y-axial body component standard deviation of the gyroscope, averaged per participant and activity combination
`BodyGyroscopeZStandardDeviationFrequencyDomain` - Mean frequency domain signal of the Z-axial body component standard deviation of the gyroscope, averaged per participant and activity combination
