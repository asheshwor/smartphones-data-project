CodeBook - Getting and Cleaning Data - Smartphones data preparation
=========

## Introduction

This codebook is for the tidy data output created for Getting and Cleaning Data Coursera course project. The description of the code and data source is available in the ```README.md``` file.

## Raw Data
The raw data used for this exercise was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##Tidy dataset

The original variables were selected from the raw data based on the variable names as listed in ```features.txt``` file. The variable names contain commas, hyphens, and parentheses which is removed by a series of ```chartr``` and ```gsub``` functions. The acceleration data has 561 columns. In order to extract the columns containing the mean and standard deviations, the words ```mean```, ```Mean```, and ```std``` are matched to the column names (variable names) to see if they contain data on mean and standard deviations. For this exercise, **all the columns matching the words are assumed to have information on either the mean or standard deviation**. The ```tidy.txt``` dataset is a text file and contains the variables as listed in the table below.

| SN |            Variable name            |
|----|-------------------------------------|
|  1 | Activity                            |
|  2 | Subject                             |
|  3 | tBodyAcc_mean_X                     |
|  4 | tBodyAcc_mean_Y                     |
|  5 | tBodyAcc_mean_Z                     |
|  6 | tGravityAcc_mean_X                  |
|  7 | tGravityAcc_mean_Y                  |
|  8 | tGravityAcc_mean_Z                  |
|  9 | tBodyAccJerk_mean_X                 |
| 10 | tBodyAccJerk_mean_Y                 |
| 11 | tBodyAccJerk_mean_Z                 |
| 12 | tBodyGyro_mean_X                    |
| 13 | tBodyGyro_mean_Y                    |
| 14 | tBodyGyro_mean_Z                    |
| 15 | tBodyGyroJerk_mean_X                |
| 16 | tBodyGyroJerk_mean_Y                |
| 17 | tBodyGyroJerk_mean_Z                |
| 18 | tBodyAccMag_mean                    |
| 19 | tGravityAccMag_mean                 |
| 20 | tBodyAccJerkMag_mean                |
| 21 | tBodyGyroMag_mean                   |
| 22 | tBodyGyroJerkMag_mean               |
| 23 | fBodyAcc_mean_X                     |
| 24 | fBodyAcc_mean_Y                     |
| 25 | fBodyAcc_mean_Z                     |
| 26 | fBodyAcc_meanFreq_X                 |
| 27 | fBodyAcc_meanFreq_Y                 |
| 28 | fBodyAcc_meanFreq_Z                 |
| 29 | fBodyAccJerk_mean_X                 |
| 30 | fBodyAccJerk_mean_Y                 |
| 31 | fBodyAccJerk_mean_Z                 |
| 32 | fBodyAccJerk_meanFreq_X             |
| 33 | fBodyAccJerk_meanFreq_Y             |
| 34 | fBodyAccJerk_meanFreq_Z             |
| 35 | fBodyGyro_mean_X                    |
| 36 | fBodyGyro_mean_Y                    |
| 37 | fBodyGyro_mean_Z                    |
| 38 | fBodyGyro_meanFreq_X                |
| 39 | fBodyGyro_meanFreq_Y                |
| 40 | fBodyGyro_meanFreq_Z                |
| 41 | fBodyAccMag_mean                    |
| 42 | fBodyAccMag_meanFreq                |
| 43 | fBodyBodyAccJerkMag_mean            |
| 44 | fBodyBodyAccJerkMag_meanFreq        |
| 45 | fBodyBodyGyroMag_mean               |
| 46 | fBodyBodyGyroMag_meanFreq           |
| 47 | fBodyBodyGyroJerkMag_mean           |
| 48 | fBodyBodyGyroJerkMag_meanFreq       |
| 49 | angle_tBodyAccMean_gravity          |
| 50 | angle_tBodyAccJerkMean_gravityMean  |
| 51 | angle_tBodyGyroMean_gravityMean     |
| 52 | angle_tBodyGyroJerkMean_gravityMean |
| 53 | angle_X_gravityMean                 |
| 54 | angle_Y_gravityMean                 |
| 55 | angle_Z_gravityMean                 |
| 56 | tBodyAcc_std_X                      |
| 57 | tBodyAcc_std_Y                      |
| 58 | tBodyAcc_std_Z                      |
| 59 | tGravityAcc_std_X                   |
| 60 | tGravityAcc_std_Y                   |
| 61 | tGravityAcc_std_Z                   |
| 62 | tBodyAccJerk_std_X                  |
| 63 | tBodyAccJerk_std_Y                  |
| 64 | tBodyAccJerk_std_Z                  |
| 65 | tBodyGyro_std_X                     |
| 66 | tBodyGyro_std_Y                     |
| 67 | tBodyGyro_std_Z                     |
| 68 | tBodyGyroJerk_std_X                 |
| 69 | tBodyGyroJerk_std_Y                 |
| 70 | tBodyGyroJerk_std_Z                 |
| 71 | tBodyAccMag_std                     |
| 72 | tGravityAccMag_std                  |
| 73 | tBodyAccJerkMag_std                 |
| 74 | tBodyGyroMag_std                    |
| 75 | tBodyGyroJerkMag_std                |
| 76 | fBodyAcc_std_X                      |
| 77 | fBodyAcc_std_Y                      |
| 78 | fBodyAcc_std_Z                      |
| 79 | fBodyAccJerk_std_X                  |
| 80 | fBodyAccJerk_std_Y                  |
| 81 | fBodyAccJerk_std_Z                  |
| 82 | fBodyGyro_std_X                     |
| 83 | fBodyGyro_std_Y                     |
| 84 | fBodyGyro_std_Z                     |
| 85 | fBodyAccMag_std                     |
| 86 | fBodyBodyAccJerkMag_std             |
| 87 | fBodyBodyGyroMag_std                |
| 88 | fBodyBodyGyroJerkMag_std            |

##Units

The ```Activity``` column has the following six character labels ```WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, and LAYING```. The subject identifiers in the ```Subject``` column are numeric variables ranging from ```1``` to ```30``` representing the 30 volunteers who contributed for the experiment. The variables from column 3 to 88 are numeric variables (double precision). **As all the variables in the tidy dataset from columns ```3``` to ```88``` contains either the mean or the standard deviation, the original units from the raw dataset are preserved.**