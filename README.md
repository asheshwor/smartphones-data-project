Getting and Cleaning Data - Smartphones data preparation
=========

## Introduction

This project is an exercise for Getting and Cleaning Data Coursera course project. The codes and the text presented here my own work, and I have appropriately cited all external sources that were used in the production of this work.

## Data source
The data used for this exercies was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The explaination of the data project through the data was collected is available at UCI Machine Learning Repository website [1] along with the links to the original datasets

## Data
The script assumes that the data has already been downloaded in the working directory and extracted in the data subfolder. The basic folder structure should look like this:
```{}
./data/UCI HAR Dataset --------main folder with the following items
  test --------------------------a folder
  train -------------------------a folder
  activity_labels.txt -----------a text file
  features.txt ------------------a text file
  features_info.txt -------------a text file
  README.txt --------------------a text file
```
The script outputs two files in the same directory so two new files will be added after running the script

Due to the large size of the dataset, the script takes a few minutes to run (>5 minutes). Please be patient. A buffersize of 500 is used to read the large data sets.Please change it to a smaller value if less RAM is available.

##Description

In order to merge the test and training datasets, the scrpit first reads the activity sets ```test.y``` and ```train.y``` using ```read.fwf``` command and merges them using ```rbind```. Next, the data that lists volunteer subjects are read (```test.s``` and ```train.s```) and merged using ```rbind```. An identifier column is also created to identify the source of the rows i.e. either ```1``` for test and ```2``` for training. As the activity sets, subject list, and identifier columns are fairly small files they are merged first to form a ```R``` dataframe.

The variable names for the acceleration data are then read from ```features.txt``` file. The variable names contain commas, hyphens, and parenthes which is removed by a series of ```chartr``` and ```gsub``` functions. To make the activities more descriptive in the dataset, the activities column is converted to a factor with six levels corrosponding to the six activities as listed in ```activity_labels.txt``` file. The identifier is also factorized into ```TEST DATA``` and ```TRAINING DATA``` levels.

The two large datasets on the accelerometer related data ```test.x``` and ```train.x``` are read using ```read.few``` command. As these are fairly large datasets, a buffersize of 500 rows is used instead of the default 2000 rows. The read data are merged using ```rbind``` function and then merged with the dataframe containing activity and subject information using ```cbind``` function. The cleaned variable names are then transfered to the newly created dataframe.

```{r}
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
feat$V3 <- chartr("-,)(", "____", feat$V2) #replace hyphen, comma and parenthes with underscore
feat$V4 <- gsub("__", "_", feat$V3) #replace double underscore with single underscore
feat$V4 <- gsub("__", "_", feat$V4) #replace double underscore with single underscore
feat$V4 <- gsub("_$", "", feat$V4) #remove _ from end of string
feat <- feat[,c(4)] #make a vector
## read acceleration data
widths <- rep(c(-1, 15),561) #561 columns in the text file
## use smaller buffer size if less than 8GB of RAM is available
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
```

###Extraction of mean and standard deviation columns

The accelaration data has 561 columns. In order to extract the columns containing the mean and standard deviations, the words ```mean```, ```Mean```, and ```std``` are matched to the column names (variable names) to see if they contain data on mean and standard deviations. For this exercise, **all the columns matching the words are assumed to have information on either the mean or standard deviation**. The output of this data is then saved as a csv file in the ```UCI HAR Dataset``` subfolder of the working directory.

```{r}
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
```

```{r}
accdata.sub$Activity <- factor(accdata.sub$Activity, levels=c(1:6),
                               labels=c("WALKING", "WALKING UPSTAIRS",
                                        "WALKING DOWNSTAIRS", "SITTING",
                                        "STANDING", "LAYING"))
accdata.sub$Data <- factor(accdata.sub$Activity, levels=c(1:2),
                               labels=c("TEST DATA","TRAINING DATA"))
```

###Tidy dataset with the average of each variable for each activity and each subject

To create the summary dataset with average of each variable for each activity and each subject, ```ddply``` function from the ```plyr``` package is used. The means of multiple columns are computed using the ```colMeans``` function. **Only the variables related to mean or standard deviation are used for this task.** The same code can be applied to get summary on all the 561 variables but for this exercise, only the columns related to mean or standard deviation is used. The new dataset is saved to the ```UCI HAR Dataset``` subfolder of the working directory as ```tidy.txt``` comma separated file format with ```.txt``` extention due to Coursera upload limitation.

```{r}
library(plyr)
tidy <- ddply(accdata.sub[,c(-1)], c("Activity", "Subject"),
              function(xdf) {
                xmeans <- colMeans(xdf[,c(-1,-2)])
                return(xmeans)
              })
#write tidy dataset to a csv file with .txt extention
write.csv(tidy, file = "./data/UCI HAR Dataset/tidy.txt",
          row.names=FALSE)
```

## References

1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012 [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]