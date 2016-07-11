setwd("C:/coursera/getcleandata/week4")

# read the activity labels and features files and give the columns the names for the activity and features numbers
# and the activity and feature descriptions. The features file contains the features in the same order as the columns
# of measurements in the test and training measurement files.
act_tbl <- read.table("Activity_Labels.txt",col.names=c("ActNum","ActDesc"))
features <- read.table("features.txt",col.names=c("feature_num","feature_desc"))

# Use the grepl function to create logical vectors of the columns that have mean ("mean") or standard deviation ("std")
# measures. A vector is creates separately for each and then the "or" logic is used to create a vector with TRUE values
# for mean or standard deviation
fetch_mean <- grepl("mean()",features$feature_desc)
fetch_std <- grepl("std()",features$feature_desc)
fetch_all <- fetch_mean | fetch_std

# Select only the features with mean or std
kept_features <- features[fetch_all,]

# Read in the main test and training files of measurements
testdata <- read.table("X_test.txt")
traindata <- read.table("X_train.txt")

# Read in the files of the subject and activity numbers for each row in the test and training files
testsubj <- read.table("subject_test.txt",col.names=c("SubjectNum"))
trainsubj <- read.table("subject_train.txt",col.names=c("SubjectNum"))

testactvty <- read.table("y_test.txt",col.names=c("ActvtyNum"))
trainactvty <- read.table("y_train.txt",col.names=c("ActvtyNum"))

# Select only the columns with mean or std measures by using the logical vector "fetch_all" as the column index
# for test data & traininf data
test_mnstd <- testdata[,fetch_all]
train_mnstd <- traindata[,fetch_all]
colnames(test_mnstd) <- kept_features$feature_desc
colnames(train_mnstd) <- kept_features$feature_desc

# Add columns to each of the test and training data frames of the activity number and the subject
test_mnstd$ActvtyNum <- testactvty[[1]]
train_mnstd$ActvtyNum <- trainactvty[[1]]
test_mnstd$SubjectNum <- testsubj[[1]]
train_mnstd$SubjectNum <- trainsubj[[1]]

# Combine the test and training files into a single data frame
cmbnd <- rbind(test_mnstd,train_mnstd)

# Merge the main measurement data frame with the activity name file by the activity number to get the activity
# description on the data frame
cmbnd2 <- merge(cmbnd,act_tbl,by.x="ActvtyNum",by.y="ActNum",all=TRUE)

# These dplyr functions group_by and summarize_all create a 2nd tidy dataset with the means of all the measures by
# Subject and activity group
SbjctActGrp <- group_by(cmbnd2,SubjectNum,ActDesc)
SbjctActGrp_Mean <- summarize_all(SbjctActGrp,mean)






