Here’s a `README.md` file for the provided script, which outlines its purpose, usage, and instructions for setup:

```markdown
# CircleCI Usage Export Script

This Bash script automates the process of creating usage export jobs for multiple organizations in CircleCI. It retrieves usage data for specified organizations over a defined date range and downloads the resulting files.

## Prerequisites

- **CircleCI Personal API Token**: You need a CircleCI personal API token with the necessary permissions to access usage data.
- **jq**: This script uses `jq` for parsing JSON. Ensure that `jq` is installed on your system. You can install it using your package manager. For example, on Ubuntu, you can run:
  ```bash
  sudo apt-get install jq
  ```

## Setup

1. **Clone or Download the Script**: Save the script to a file named `circleci_usage_export.sh`.

2. **Make the Script Executable**:
   ```bash
   chmod +x circleci_usage_export_multi_org.sh
   ```

3. **Set Environment Variables**:
   Open the script in your favorite text editor and replace the placeholder values with your actual CircleCI token, organization IDs, and date range.

   ```bash
   CIRCLE_TOKEN="REPLACE_WITH_CCI_PERSONAL_API_TOKEN"
   ORG_IDS=("REPLACE_WITH_ORG1_ID" "REPLACE_WITH_ORG2_ID" "REPLACE_WITH_ORG3_ID") # Add a list of org IDs
   START_DATE="2025-02-01T00:00:00Z" # Replace with start date in this format
   END_DATE="2025-02-28T00:00:00Z" # Replace with end date in this format
   ```

## Usage

1. **Run the Script**:
   Execute the script by running:
   ```bash
   source ./circleci_usage_export_multi_org.sh
   ```

2. **Script Functionality**:
   - The script loops through each organization ID provided in the `ORG_IDS` array.
   - It creates a usage export job for each organization and checks the job status.
   - Once the job is completed, it downloads the files and unzips them, renaming them according to the specified date range and organization ID.

## Output

- The script will print the status of each job, including any errors encountered during execution.
- Downloaded files will be renamed in the format:
  ```
  START_DATE_to_END_DATE_ORG_ID.csv
  ```

## Example

Here’s an example of how to set the environment variables:

```bash
CIRCLE_TOKEN="my_circleci_token"
ORG_IDS=("org1_id" "org2_id" "org3_id")
START_DATE="2025-02-01T00:00:00Z"
END_DATE="2025-02-28T00:00:00Z"
```

## Notes

- Ensure that you have the necessary permissions for the API token.
- Monitor the output for any errors or issues with the API calls.
- Adjust the sleep duration in the script if needed to accommodate for longer processing times.

## License

This script is provided as-is. Use it at your own risk.
```

### Summary of the README.md

- **Title**: Clearly states the purpose of the script.
- **Prerequisites**: Lists requirements for running the script.
- **Setup**: Provides detailed instructions on how to prepare the script for execution.
- **Usage**: Explains how to run the script and what to expect.
- **Example**: Gives a practical example of how to set environment variables.
- **Notes**: Offers additional information and considerations.
- **License**: A disclaimer regarding the use of the script.

Feel free to customize the content further based on your specific needs or organizational guidelines!
