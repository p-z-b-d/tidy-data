# tidy-data

This README file is created to explain what the run_analysis.R script does to create a tidy dataset.

The original source of data is the Human Activity Recognition Using Smartphones Dataset Version 1.0 from "Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. Smartlab - Non Linear Complex Systems Laboratory. DITEN - Università degli Studi di Genova. Via Opera Pia 11A, I-16145, Genoa, Italy. activityrecognition@smartlab.ws. www.smartlab.ws"

All data was stored in a location called "./dataset". The data included a README file that explains the experiment that was conducted. For this experiment, information was collected from 30 volunteers (hereafter referred to as "subjects"). The data is collected from smartphones attached to the subjects' waists, which recorded the subjects' activities over a period of time. Data included in the dataset were from six activities: 1.WALKING, 2.WALKING_UPSTARIS, 3.WALKING_DOWNSTAIRS, 4.SITTING, 5.STANDING, 6.LAYING.  Activites were coded by number. Also, the data was split into two parts. One was during testing; the second was during training. The first group of data was stored in a folder called "./dataset/test" and the second in a folder called "./dataset/train". As a result, there were two different groups of information. Each group's dataset was comprised of the activities that occured and their respective code ("./dataset/test/y_test.txt" and "./dataset/train/y_train.txt"). Additionally, a second dataset listed which subject performed the associated activities ("./dataset/test/subject_test.txt" and "./dataset/train/subject_train.txt"). Finally, a third dataset included all of the measurements that were produced ("./dataset/test/X_test.txt" and "./dataset/train/X_train.txt").

The data also includes a file ("./dataset/features.txt") which is the list of variables included, examined, and measured during the experiment. The exact variables examined and what they represent is explained in more detail in "./dataset/features_info.txt" file.

I created a script called "run_analysis.r". This script combines training and the test sets into one dataset, extracts only the measurements on the mean and standard deviation for each measurement, uses descriptive activity names for activities in the dataset, and labels the data set with descriptive variable names. 

First, I opened the files with the measurements and the respective activities and subjects for both test and train periods.
#Load all the test datasets
ytest <- read.table("./dataset/test/y_test.txt")
xtest <- read.table("./dataset/test/X_test.txt")
subjecttest <- read.table("./dataset/test/subject_test.txt")

#Load all the training datasets
ytrain <- read.table("./dataset/train/y_train.txt")
xtrain <- read.table("./dataset/train/X_train.txt")
subjecttrain <- read.table("./dataset/train/subject_train.txt")

Then I merged all the datasets to create the comprehensive "fullDataset"
#Merge the datasets
testDataset <- cbind(ytest, subjecttest, xtest)
trainDataset <- cbind(ytrain, subjecttrain, xtrain)
fullDataset <- rbind(trainDataset, testDataset)

The result is a dataset, whose first column contains the information about the activity, the second column contains the information about eh subject that performed the activity and the following 561 columns contain the respective measurements that were taken during each activity.
After that, I changed the names of the variables that was expressed in each columns, so that the name of each variable is more descriptive. Based, on the information above, I names the first column "Activity", the second column "Subject" and the following columns were named after the respective variable names in "./dataset.features.txt". Below is the code that I used to do that:
#Use the features table to create a vector for the new names of the dataset
features <- read.table("./dataset/features.txt")
featvector<-as.character(features[,2])
namevector<-c("Activity", "Subject", featvector)

#Change the column names to the names specified in "namevector"
colnames(fullDataset) <- namevector

After that, I formed the dataset called "extractedDataset", that extracted only the variables on the mean and standard deviation of each measurement. Of course, I also included the columns for the activity and subject as well. To do that, I subsetted fullDataset, using the grep() function:
#Extract only the measurements on the mean and standard deviation
extractedDataset <- fullDataset[,c("Activity","Subject", colnames(fullDataset)[grep("mean|std", colnames(fullDataset))])]

After that, I changed the activity codes (1,2,3,4,5,6) with the corresponding descriptive activity names:
#Change the activity numbers to the proper activity names
extractedDataset$Activity = factor(extractedDataset$Activity, c(1,2,3,4,5,6), c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

In the end, I summarized the data with the average of each variable for each activity and each subject, to create a tidy dataset, using the dplyr library, and created the "tidyDataset.txt" file, suing write.table() like so:
#Summarize and create the output file
tidyDataset <- extractedDataset %>% group_by(Activity,Subject) %>% summarise_each(funs(mean))
write.table(tidyDataset,"tidyDataset.txt",row.names=FALSE)
