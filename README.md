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

###Extraction of mean and standard deviation columns

The accelaration data has 561 columns. In order to extract the columns containing the mean and standard deviations, the words ```mean```, ```Mean```, and ```std``` are matched to the column names (variable names) to see if they contain data on mean and standard deviations. For this exercise, **all the columns matching the words are assumed to have information on either the mean or standard deviation**. The output of this data is then saved as a csv file in the ```UCI HAR Dataset``` subfolder of the working directory.

###Tidy dataset with the average of each variable for each activity and each subject

To create the summary dataset with average of each variable for each activity and each subject, ```ddply``` function from the ```plyr``` package is used. The means of multiple columns are computed using the ```colMeans``` function. **Only the variables related to mean or standard deviation are used for this task.** The same code can be applied to get summary on all the 561 variables but for this exercise, only the columns related to mean or standard deviation is used. The new dataset is saved to the ```UCI HAR Dataset``` subfolder of the working directory as ```tidy.txt``` comma separated file format with ```.txt``` extention due to Coursera upload limitation.

## References

1. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012 [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones]