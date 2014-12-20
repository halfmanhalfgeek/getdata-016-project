getdata-016-project
===================

Course project for the Coursera course "getting and cleaning data"

See [https://github.com/halfmanhalfgeek/getdata-016-project/blob/master/brief.md](ttps://github.com/halfmanhalfgeek/getdata-016-project/blob/master/brief.md "the project brief") for details on the problem posed for this project.

The code works from the data at [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) Unzip this so that the folder "UCI HAR Dataset" is in your working folder.

The script works by:

- reading the activities in "UCI HAR Dataset/activity_labels.txt"
- reading the features in "UCI HAR Dataset/features.txt"
- loading the data in from the test and train folders, combining:
 - the X data (the observations) 
 - the Y data (what the subject was doing)
 - the subject (which subject was performing the activity)
- subsetting the merged data, pulling out all the columns which collected mean and standard deviations from the observed data
- calculating the mean of the observations, grouped by subject and activity

This is then output to the file called "means.txt"

See "code_book.md" for details of the data.