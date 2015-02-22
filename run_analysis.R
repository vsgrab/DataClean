##R that does the following. 
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names. 
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

library("data.table")
library("reshape2")

##-----------------Heading Data
activity_labels <- read.table("./activity_labels.txt")[,2]
features <- read.table("./features.txt")[,2]
# Extract only the measurements on the mean and standard deviation for each measurement.
useful_features <- features[features %like% "std|mean"]

##-----------------Test Data 
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
names(x_test) = features

##-----------------Train Data

x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")
names(x_train) = features


##subset useful features & rename once again
x_test =  x_test[,useful_features]
names(x_test) = useful_features

x_train = x_train[,useful_features]
names(x_train) = useful_features

##Add activity Labels & names
y_test[,2]=activity_labels[y_test[,1]]
y_test<-data.frame(y_test[,2])
y_train[,2]=activity_labels[y_train[,1]]
y_train<-data.frame(y_train[,2])
names(y_test) = c("Activity_Label")
names(subject_test) = "subject"
names(y_train) = c( "Activity_Label")
names(subject_train) = "subject"

##-----------------Combine All Into 1 Frame
test_data <- cbind(subject_test, y_test, x_test)
train_data <- cbind(subject_train, y_train, x_train)
data = rbind(test_data, train_data)

##-----------------Creating tidy dataset for assignment
melt_data = melt(data, id =  c("subject", "Activity_Label"), measure.vars = useful_features)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
