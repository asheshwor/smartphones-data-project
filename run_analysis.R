#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Notes
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
##Date: 2014-05-23
##Submission for coursera Getting and cleaning data course - May 5 - June 2
##  2014
## See README.md for further explanation
# github url: https://github.com/asheshwor/smartphones-data-project

#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Obtaining data
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
# data link:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## The script assumes that the data has already been downloaded in the 
#   working directory and extracted in the data subfolder
#   ./data/{extract here}
#   The basic folder structure should look like this
#   ./data/UCI HAR Dataset --------main folder with the following items
#   test --------------------------a folder
#   train -------------------------a folder
#   activity_labels.txt -----------a text file
#   features.txt ------------------a text file
#   features_info.txt -------------a text file
#   README.txt --------------------a text file
#
# The script outputs two files in the same directory so two new files 
#   will be added after running the script
#
# **** Warning ****
# Due to the large size of the dataset, the script takes a few minutes to
# run (>6 minutes). Please be patient.
# A buffersize of 500 is used to read the large data sets.
# Please change it to a smaller value if less RAM is available.

#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Load packages
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
library(plyr)

#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Read and merge data
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#Task 1: Merges the training and the test sets to create one data set.
#clear memory if needed.
#rm(list = ls()) #commented to prevent accidental clearing of workspace vars
##activity - 1-6
test.y <- read.fwf("./data/UCI HAR Dataset/test/y_test.txt", c(1),
                   header = F, n=-1) #read test activities list
train.y <- read.fwf("./data/UCI HAR Dataset/train/y_train.txt", c(1),
                    header = F, n=-1) #read training activities list
activity <- rbind(test.y, train.y)
#nrow(test.y) #2947
#nrow(train.y) #7352
#nrow(train.all) #10299

##  subject - volunteer numbers
test.s <- read.table("./data/UCI HAR Dataset/test/subject_test.txt",
                     header=F) #read test subjects
train.s <- read.table("./data/UCI HAR Dataset/train/subject_train.txt",
                      header=F) ##read training subjects
subject <- rbind(test.s, train.s) #combine subjects
#create identifier for training/subject
dat <- c(rep(1,nrow(test.s)), rep(2,nrow(train.s))) #1 for test; 2 for training
#combine training, subject and activity
comb <- cbind(dat, subject, activity)
names(comb) <- c("Data", "Subject", "Activity")
#remove temporary variables from memory
rm(list = c("test.y", "train.y", "activity", "test.s", "train.s", "subject", "dat"))

##getting variable names from features
#read subject
feat <- read.table("./data/UCI HAR Dataset/features.txt", sep=" ", header=F)
#clean variable names as they contain the following characters:
# comma, hyphen, parentheses
feat$V3 <- chartr("-,)(", "____", feat$V2) #replace hyphen, comma and parenthesis with underscore
feat$V4 <- gsub("__", "_", feat$V3) #replace double underscore with single underscore
feat$V4 <- gsub("__", "_", feat$V4) #replace double underscore with single underscore
feat$V4 <- gsub("_$", "", feat$V4) #remove _ from end of string
feat <- feat[,c(4)] #make a vector
## read acceleration data
widths <- rep(c(-1, 15),561) #561 columns in the text file
## use smaller buffer size if less than 8GB of RAM is available
#   (it used ~4.6GB out of 8GB in my machine with burrersize set to 500)
buffer <- 500 #used ~5.6GB ram
test.x <- read.fwf("./data/UCI HAR Dataset/test/X_test.txt", widths, header = F, n=-1,
                   buffersize = buffer)
train.x <- read.fwf("./data/UCI HAR Dataset/train/X_train.txt", widths, header = F, n=-1,
                    buffersize = buffer)
##merge test and train acc data
accdata <- rbind(test.x, train.x)
rm(list=c("test.x", "train.x", "widths")) #remove
names(accdata) <- feat #transfer names from features
##merge with activity and subject data
accdata <- cbind(comb, accdata) #combined data
rm(list = c("comb", "feat")) #remove variables from memory
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Extract mean and standard deviations only
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#Task 2: Extracts only the measurements on the mean and standard deviation
##       for each measurement.
## select the variables with the names containing mean or std
vars <- names(accdata)
sel1 <- grep("mean", vars) #lower case mean
sel2 <- grep("Mean", vars) #mean with capital first letter
sel3 <- grep("std", vars) #std
sel <- unique(c(sel1,sel2,sel3))
rm(list=c("sel1", "sel2", "sel3")) #remove variables from memory
accdata.sub <- accdata[,c(1:3, sel)] #subset
##write the file
write.csv(accdata.sub, file = "./data/UCI HAR Dataset/subset.csv",
            row.names=FALSE)
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Label dataset with descriptive activity names
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#Task 3: Uses descriptive activity names to name the activities in the data set
#   already done in above code [Task 1] while transferring names of variables
#   from features.

#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Label dataset with descriptive activity names
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#Task 3: Appropriately labels the data set with descriptive activity names.
##convert Activity column to factor
accdata.sub$Activity <- factor(accdata.sub$Activity, levels=c(1:6),
                               labels=c("WALKING", "WALKING UPSTAIRS",
                                        "WALKING DOWNSTAIRS", "SITTING",
                                        "STANDING", "LAYING"))
accdata.sub$Data <- factor(accdata.sub$Activity, levels=c(1:2),
                               labels=c("TEST DATA","TRAINING DATA"))

#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Create a tidy data set
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#Task 6: Creates a second, independent tidy data set with the average of each
##       variable for each activity and each subject. 
tidy <- ddply(accdata.sub[,c(-1)], c("Activity", "Subject"),
              function(xdf) {
                xmeans <- colMeans(xdf[,c(-1,-2)])
                return(xmeans)
              })
#write tidy dataset to a csv file with .txt extension
write.csv(tidy, file = "./data/UCI HAR Dataset/tidy.txt",
          row.names=FALSE)

##### fin *****
