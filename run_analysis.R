#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Load packages
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
library(plyr)
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Read and merge data
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#Task 1: Merges the training and the test sets to create one data set.
#clear memory
#rm(list = ls())
##activity - 1-6
test.y <- read.fwf("./data/UCI HAR Dataset/test/y_test.txt", c(1), header = F, n=-1)
train.y <- read.fwf("./data/UCI HAR Dataset/train/y_train.txt", c(1), header = F, n=-1)
activity <- rbind(test.y, train.y)
#nrow(test.y) #2947
#nrow(train.y) #7352
#nrow(train.all) #10299

##subject - volunteer numbers
test.s <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=F)
train.s <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=F) 
subject <- rbind(test.s, train.s)
dat <- c(rep(1,nrow(test.s)), rep(2,nrow(train.s))) #1 for test; 2 for training
#combine training, subject and activity
comb <- cbind(dat, subject, activity)
names(comb) <- c("Data", "Subject", "Activity")
rm(list = c("test.y", "train.y", "activity", "test.s", "train.s", "subject", "dat"))

#head(dat2[,c(555:561)],10)
#head(dat2[,c(1:5)],10)
#dat2$V1[1] * 1000000000
##getting variable names from features
#read subject
feat <- read.table("./data/UCI HAR Dataset/features.txt", sep=" ", header=F)
feat$V3 <- chartr("-,)(", "____", feat$V2) #replace hyphen, comma and parenthes with underscore
feat$V4 <- gsub("__", "_", feat$V3) #replace double underscore with single underscore
feat$V4 <- gsub("__", "_", feat$V4) #replace double underscore with single underscore
feat$V4 <- gsub("_$", "", feat$V4) #remove _ from end of string
#tail(feat[,c(2,4)])
feat <- feat[,c(4)] #make a vector
## read acceleration data
widths <- rep(c(-1, 15),561)
buffer <- 500 #used ~5.6GB ram
test.x <- read.fwf("./data/UCI HAR Dataset/test/X_test.txt", widths, header = F, n=-1,
                   buffersize = buffer)
train.x <- read.fwf("./data/UCI HAR Dataset/train/X_train.txt", widths, header = F, n=-1,
                    buffersize = buffer)
##merge test and train acc data
accdata <- rbind(test.x, train.x)
rm(list=c("test.x", "train.x", "widths")) #remove
names(accdata) <- feat #transfer names from features
#head(accdata[,c(1:10)])
##merge with activity and subject data
accdata <- cbind(comb, accdata) #combined data
rm(list = c("comb", "feat")) #remove
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
#rm(list=c("sel1", "sel2", "sel3"))
accdata.sub <- accdata[,c(1:3, sel)] #subset
##write the file
write.csv(accdata.sub, file = "./data/UCI HAR Dataset/subset.csv",
            row.names=FALSE)
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Label dataset with descriptive activity names
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#Task 3: Uses descriptive activity names to name the activities in the data set
#alredy done
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
#tail(tidy)
#write tidy dataset to file
write.csv(tidy, file = "./data/UCI HAR Dataset/tidy.csv",
          row.names=FALSE)
#rm(list = ls())
#exporting variable names to a file
varlist <- data.frame(names(tidy))
