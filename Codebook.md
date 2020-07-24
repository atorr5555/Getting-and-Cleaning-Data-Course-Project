# Codebook

## Raw Data

All the information about the raw data is in the following page: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones# and in the `features.txt` and `features_info.txt` files in the data.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern: 
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

FEATURE VARIABLES
-----------------

### Time signals

-   tBodyAcc-XYZ
-   tGravityAcc-XYZ
-   tBodyAccJerk-XYZ
-   tBodyGyro-XYZ
-   tBodyGyroJerk-XYZ
-   tBodyAccMag
-   tGravityAccMag
-   tBodyAccJerkMag
-   tBodyGyroMag
-   tBodyGyroJerkMag

### Frequency domain signals

-   fBodyAcc-XYZ
-   fBodyAccJerk-XYZ
-   fBodyGyro-XYZ
-   fBodyAccMag
-   fBodyAccJerkMag
-   fBodyGyroMag
-   fBodyGyroJerkMag

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

* gravityMean
* tBodyAccMean
* tBodyAccJerkMean
* tBodyGyroMean
* tBodyGyroJerkMean

## Resulting Tidy Set

The data set contains the average of each variable for each activity and each subject. The resulting data consists of 81 columns:

* **Subject**: Indicates the number of the subject that helped in the experiment
* **Activity**: Indicates the activity the subject was doing when the measurement was taken
* The other 79 columns are the means of the measurements taken by the accelerometer (units in m/s² ) and a gyroscope (units in °/s) registered in the raw data for each activity and each subject, the names have important parts that indicate information about the variable:
  * If the name starts with a 't', then they are in the time domain
  * If the name starts with an 'f', then the measure is in the frequency domain, these measurements were obtained applying the FFT (Fast Fourier Transform)
  * If the name includes the word mean, then is the mean of the measures
  * If the name includes the string std, then is the standard deviation of the measurement
  * If the name name ends with an 'X', then the measure is from the X axis of the accelerometer or gyroscope
  * If the name name ends with an 'Y', then the measure is from the Y axis of the accelerometer or gyroscope
  * If the name name ends with an 'Z', then the measure is from the Z axis of the accelerometer or gyroscope
  * If the name contains the string 'Acc' then it is a register from the accelerometer and its units are m/s²
  * If the name contains the string 'Gyro' then it is a register from the gyroscope and its units are °/s