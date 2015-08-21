#This script is designed to satisfy the requirements for the programming assignment
#for the Coursera Course: Getting and Cleaning Data

#Set working directory - This will likely change based on the computer running the script
  #setwd("C:\\Scratch\\_coursera\\Class3")

#Install package as needed and download Zip file for analysis
 # install.packages("downloader")
 # require(downloader)
 # url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 # download(url, "Dataset.zip")
 # unzip("Dataset.zip")

 #If you have an error and did not restructure the data files, see below
 #Import Training Set
  subjectTrain = read.table(".\\subject_train.txt")
  XTrain = read.table(".\\X_train.txt")
  YTrain = read.table(".\\Y_train.txt")

#Import Test Set     
  subjectTest = read.table(".\\subject_test.txt")
  XTest = read.table(".\\X_test.txt")
  YTest = read.table(".\\Y_test.txt")

 #Import other tables
  features  = read.table(".\\features.txt")
  activityLabels  = read.table(".\\activity_labels.txt")
 
##Uncomment and run this if you left the data in the folder structure
##Import Training Set
  #subjectTrain = read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
  #XTrain = read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
  #YTrain = read.table(".\\UCI HAR Dataset\\train\\Y_train.txt")
  #subjectTest = read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
  #XTest = read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
  #YTest = read.table(".\\UCI HAR Dataset\\test\\Y_test.txt")
  #features  = read.table(".\\UCI HAR Dataset\\features.txt")
  #activityLabels  = read.table(".\\UCI HAR Dataset\\activity_labels.txt")
## End Uncomment and run this if you left the data in the folder sturcture

  
#Merge Datasets - Insturction 1
  subject <- rbind(subjectTrain, subjectTest)
  X <- rbind(XTrain, XTest)
  Y <- rbind(YTrain, YTest) 
 
#Rename variables to meaningful and human readable  - Insturction 3
  names(activityLabels)[1] <- "Activity_ID"
  names(activityLabels)[2] <- "Activity"
  names(subject)[1] <- "Subject_ID"
  names(Y)[1] <- "Activity_ID"
#Assign names to the variables as given in the original dataset  - Insturction 4
  names(X) <- features[,2]

#Merge Activities
  activities<-merge(Y, activityLabels, by="Activity_ID")
  
 #Extract only measurements(columns) on the mean and standard deviation then bind to activities  - Insturction 2
  TidyDataSubset <- cbind(subject,activities,X[grepl("mean", names(X))],X[grepl("std", names(X))])
 
#Would not normally take an average of averages but this is how I interpreted the instructions given in Insturction 5
  TidyDataSummary<-aggregate(TidyDataSubset[, 4:82], list(TidyDataSubset$Subject_ID,TidyDataSubset$Activity), mean)
#Rename variables to meaningful and human readable  
  names(TidyDataSummary)[1] <- "Subject_ID"
  names(TidyDataSummary)[2] <- "Activity"
  TidyDataSummary<-TidyDataSummary[order(TidyDataSummary[1], TidyDataSummary[3]),]
 
#Write output file
  write.table(TidyDataSummary, "TidyDataSummary.txt",row.name=FALSE )

