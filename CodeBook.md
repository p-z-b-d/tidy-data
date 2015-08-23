The following codebook captures the tables, variables represented, and row and column meanings for the dataset. The script ("run_analysis.r") condensed seven files into one.

This file describes how the original files were transformed and what information is contained in each dataset. Two of those files were only logging the activities. One for the test data and one for the training data. Two of those files were just keeping track of which subject (AKA "volunteers") performed each activity. Another two files contained the actual measurements from all of the activities. The remaining file is the list of variables that were measured.

There were 561 time and frequency domain variables in the features.txt file.

ytest: ytest has 2947 rows and 1 column. The column represents an activity. 
ytrain: ytrain has 7352 rows and 1 column. The column represents an activity.

This codebook describes the variables, the data, and any transformations or work that you performed to clean up the data.
I worked with 7 tables that contain information about the activities performed (y_test.txt, y_train.txt), the subjects that performed said activities (subject_test.txt, subject_train.txt) and the measurements that were collected during these activities (X_test.txt, X_train.txt). The last table contains the list of 561 variables that were examined during the experiment (features.txt). The 561 columns in the (X_test.txt, X_train.txt) files represent measurements for these time and frequency domain variables.
More detaits on each of the variables is provided by the features_info.txt:

"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean"

Also, from the README.txt we know that all features are normalized and bounded within [-1,1].

In my script, I read all the tables for the test period and form the testDataset. Similarly, all the tables from the training period form the trainDataset. They both have 563 columns. The first one is for the activity performed in each line, the second column is for the subject that performs the activity in that line and the next 561 columns describe the variables explained above.
Then I combine these datasets to create fullDataset. The same number of columns and same variables are represented in this one.

After that, I use the features.txt to rename the columns in the dataset with more descriptive variables. I also properly name the first two columns "Activity" and "Subject" respectively.

Then, I extract the columns that have the information about the activity, subject and the variables for the mean and standard deviation for each measurement. The resulting dataset is called extractedDataset.

Then, I changed the activity codes with the proper descriptive activity names. So (1,2,3,4,5,6) were replaced by ("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING").

In the end I formed tidyDataset.
tidyDataset <- extractedDataset %>% group_by(Activity,Subject) %>% summarise_each(funs(mean))
tidyDataset has 180 rows, one for each activity by each subject. It also has 81 columns. The first one is for the activity, the second for the subject. The following 79 columns are for the same variables as described above (variables for the mean and standard deviation for each measurement). Each row, expresses the average of the measurements for each activity and each subject.
