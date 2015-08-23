library(dplyr)

#Load all the test datasets
ytest <- read.table("./dataset/test/y_test.txt")
xtest <- read.table("./dataset/test/X_test.txt")
subjecttest <- read.table("./dataset/test/subject_test.txt")

#Load all the training datasets
ytrain <- read.table("./dataset/train/y_train.txt")
xtrain <- read.table("./dataset/train/X_train.txt")
subjecttrain <- read.table("./dataset/train/subject_train.txt")

#Merge the datasets
testDataset <- cbind(ytest, subjecttest, xtest)
trainDataset <- cbind(ytrain, subjecttrain, xtrain)
fullDataset <- rbind(trainDataset, testDataset)

#Use the features table to create a vector for the new names of the dataset
features <- read.table("./dataset/features.txt")
featvector<-as.character(features[,2])
namevector<-c("Activity", "Subject", featvector)

#Change the column names to the names specified in "namevector"
colnames(fullDataset) <- namevector

#Extract only the measurements on the mean and standard deviation
extractedDataset <- fullDataset[,c("Activity","Subject", colnames(fullDataset)[grep("mean|std", colnames(fullDataset))])]

#Change the activity numbers to the proper activity names
extractedDataset$Activity = factor(extractedDataset$Activity, c(1,2,3,4,5,6), c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#Summarize and create the output file
tidyDataset <- extractedDataset %>% group_by(Activity,Subject) %>% summarise_each(funs(mean))
write.table(tidyDataset,"tidyDataset.txt",row.names=FALSE)
