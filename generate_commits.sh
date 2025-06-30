#!/bin/bash

# Check for start and end dates as arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <start_date> <end_date>"
    echo "Dates should be in YYYY-MM-DD format."
    exit 1
fi

start_date=$1
end_date=$2

# Create or clear a file to commit
echo "Initial content" > file.txt
git add file.txt
git commit -m "Initial commit"

# Convert start and end dates to seconds for easier calculations
start_seconds=$(date -d "$start_date" +%s)
end_seconds=$(date -d "$end_date" +%s)

# Loop through months from start to end date
current_seconds=$start_seconds
while [ "$current_seconds" -le "$end_seconds" ]; do
    # Get the first day of the current month
    first_day=$(date -d "@$current_seconds" +%Y-%m-01)

    # Generate 6 random days for commits in the current month
    for ((j=0; j<6; j++)); do
        # Calculate last day of the month
        last_day=$(date -d "$first_day +1 month -1 day" +%d)
        random_day=$((RANDOM % last_day + 1))

        # Create the commit date
        commit_date=$(date -d "$first_day + $random_day - 1 day" +%Y-%m-%d)

        # Check if the commit date is within the end date
        if [[ "$commit_date" > "$end_date" ]]; then
            continue
        fi

        # Update the file
        echo "Update for $commit_date" >> file.txt
        git add file.txt
        git commit -m "Commit for $commit_date"

        # Amend the commit date to simulate the actual date
        git commit --amend --no-edit --date "$commit_date"
    done

    # Move to the next month
    current_seconds=$(date -d "$first_day + 1 month" +%s)
done