##
##  NOTE TO GRADER
##  I PREFERED TO WORK FROM EVERYTHING BEING UNZIPPED FROM THE PROVIDED DATA, AND USE THE WORKING DIRECTORY ABOVE THAT
##  THIS IS BECAUSE I DIDN'T WANT TO MOVE THE FILES AROUND FROM THE DATA WE WERE GIVEN - SEEMED TO BREAK THE CONCEPT
##  OF REPEATABILITY (I.E. SOMEONE ELSE WOULD HAVE TO MOVE THE DATA FILES AROUND TOO)
##  SO THIS WON'T WORK IF THE SAMSUNG DATA IS YOUR WORKING DIRECTORY, BUT I DON'T CARE...!
##
##

# Load the features
# Reads in the meaning of each observed measurement, i.e. everything that was captured by the phone
getFeatures <- function() {
  features <- read.table("UCI HAR Dataset/features.txt", col.names=c("id", "feature"))
  features
}

# 
# Load the activities
# This is the names we give to each thing a person was doing, e.g. walking, lying etc.
getActivities <- function() {
  activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("activity_id", "activity_text"), stringsAsFactors = FALSE)  
  activities
}

# Load in a given dataset
# Observations file contains the information collected by the phone
# Activities file contains what the person was doing when that observation was collected
# Subjects file identifies the subject on whom the data was collected
# 
# Each file is combined into a single data.frame

loadDataset <- function(features, observations, activities, subjects) {

  dataset <- read.table(observations, col.names=make.names(features[,"feature"]))  
  labels <- read.table(activities, col.names=c("activity"), colClasses=c("factor"))
  subjects <- read.table(subjects, col.names=c("subject_id"), colClasses=c("factor"))
  
  cbind(subjects, labels, dataset)
}

# Load the training data
loadTraining <- function(features) {
  loadDataset(features, observations = "UCI HAR Dataset/train/X_train.txt", activities = "UCI HAR Dataset/train/y_train.txt", 
              subjects="UCI HAR Dataset/train/subject_train.txt")  
}

# Load the test data
loadTest <- function(features) {
  loadDataset(features, observations = "UCI HAR Dataset/test/X_test.txt", activities = "UCI HAR Dataset/test/y_test.txt", 
              subjects="UCI HAR Dataset/test/subject_test.txt")    
}

# Merge the train and test data
# Returns the subject and activities, along with all the "mean" and "standard deviation" type measurements

mergeData <- function(test, train) {
  
  # Put the datasets together
  merged <- rbind(test, train)
  
  # Pull out the columns we want from the merged dataset
  # That's the first and second (i.e. subjects and activity ids) and every column that has "mean" or "std" in it
  required_data <-  merged[,c(1,2,grep("mean|std", names(merged)))]
  
  # Keep the column names to make it easy to eliminate the "activity id"
  col_names <- names(required_data)
  
  # Convert the activity id to the activity name
  # This function gets the text for the activity id
  activityToText <- function(activity_id) {
    activities$activity_text[which(activities$activity_id == activity_id)]
  }
  # Insert the activity name columnf
  required_data$activity_name <- as.factor(unlist(lapply(required_data$activity, activityToText)))
  
  # Now return all the columns except for "activity id" which we don't need any more
  required_data[, c("subject_id", "activity_name", col_names[3:length(col_names)])]
  
}

# Load the supporting information
activities <- getActivities()
features <- getFeatures()

# Then train and test data
training <- loadTraining(features)
test <- loadTest(features)

# Merge, get the columns we want out
merged <- mergeData(training, test)

# And calculate the grouped means
means <- aggregate(merged[,3:ncol(merged)], by=list(merged$subject_id, merged$activity_name), mean)

# Reset the column names so they're meaningful again
names(means)[names(means)=="Group.1"] <- "subject_id"
names(means)[names(means)=="Group.2"] <- "activity_name"

# Write out the result
write.table(means, file = "means.txt", row.name=FALSE)
