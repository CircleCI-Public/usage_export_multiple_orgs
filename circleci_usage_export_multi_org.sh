#!/bin/bash

# First script to retrieve unique organization IDs
# Replace with your CircleCI API token
CIRCLE_TOKEN="REPLACE_WITH_CIRCLE_API_TOKEN"

# API endpoint to get collaborations: https://circleci.com/docs/api/v2/index.html#tag/User/operation/getCollaborations
url="https://circleci.com/api/v2/me/collaborations"

# Make the API request
response=$(curl --silent --request GET \
  --url "$url" \
  --header "Circle-Token: $CIRCLE_TOKEN")

# Check if the request was successful
if [[ $? -ne 0 ]]; then
  echo "Failed to retrieve collaborations."
  exit 1
fi

# Use jq to extract unique organization IDs
unique_ids=$(echo "$response" | jq -r '.[].id' | sort -u)

# Print the extracted unique organization IDs in the requested format
ORG_IDS=()
for id in $unique_ids; do
    ORG_IDS+=("$id")
done

# Set environment variables
START_DATE="2025-02-01T00:00:00Z" # REPLACE WITH START DATE IN THIS FORMAT
END_DATE="2025-02-28T00:00:00Z"   # REPLACE WITH END DATE IN THIS FORMAT

# Loop through each organization ID
for ORG_ID in "${ORG_IDS[@]}"; do
  echo "Processing organization ID: $ORG_ID"

  # Make the first API call to create the usage export job
  usage_export_job_id=$(curl --silent --request POST \
    --url "https://circleci.com/api/v2/organizations/${ORG_ID}/usage_export_job" \
    --header "Circle-Token: ${CIRCLE_TOKEN}" \
    --header 'Content-Type: application/json' \
    --data "{\"start\":\"${START_DATE}\",\"end\":\"${END_DATE}\",\"shared_org_ids\":[\"${ORG_ID}\"]}" | jq -r .usage_export_job_id)

  # Check if the job ID was retrieved successfully
  if [ -z "$usage_export_job_id" ]; then
    echo "Failed to create usage export job for organization ID: $ORG_ID."
    continue  # Move to the next organization ID
  fi

  echo "Usage export job created with ID: $usage_export_job_id"

  # Initialize variables for polling
  max_attempts=10
  attempt=0
  job_state="processing"

  # Poll for job status until it's no longer "processing" or max attempts reached
  while [[ "$job_state" == "processing" && $attempt -lt $max_attempts ]]; do
    # Make the second API call to get the status of the usage export job
    job_status=$(curl --silent --request GET \
      --url "https://circleci.com/api/v2/organizations/${ORG_ID}/usage_export_job/${usage_export_job_id}" \
      --header "Circle-Token: ${CIRCLE_TOKEN}")

    # Output the job status
    echo "Job status:"
    echo "$job_status" | jq

    # Extract the value of the 'state' key
    job_state=$(echo "$job_status" | jq -r .state)
    echo "Job state: $job_state"

    # Increment the attempt counter
    attempt=$((attempt + 1))

    # Sleep for a while before the next check
    if [[ "$job_state" == "processing" ]]; then
      echo "Job is still processing. Waiting for 30 seconds before checking again..."
      sleep 30
    fi
  done

  # Check if the job has completed
  if [[ "$job_state" == "completed" ]]; then
    echo "Job has completed for organization ID: $ORG_ID. Downloading files..."

    # Extract download URLs
    download_urls=$(echo "$job_status" | jq -r '.download_urls[]')

    # Download each file
    for url in $download_urls; do
      echo "Downloading $url..."
      curl -L -O "$url"
    done

    echo "All files downloaded successfully."

    # Unzip the downloaded .csv.gz file and rename it
    for file in *.csv.gz; do
      if [[ -f "$file" ]]; then
        echo "Unzipping $file..."
        gunzip -c "$file" > "${START_DATE}_to_${END_DATE}_${ORG_ID}.csv"
        echo "Renamed to ${START_DATE}_to_${END_DATE}_${ORG_ID}.csv"
      fi
    done
  else
    echo "Job has finished with state: $job_state for organization ID: $ORG_ID"
    if [[ "$job_state" == "processing" ]]; then
      echo "Max attempts reached. Job is still processing."
    fi
  fi
done
