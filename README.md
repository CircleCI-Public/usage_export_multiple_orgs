
# CircleCI Usage Export Script

This script retrieves organization IDs from CircleCI and creates usage export jobs for each organization. It then polls the jobs for their status and downloads the resulting files.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [License](#license)
- [Contributing](#contributing)

## Prerequisites

Before running this script, ensure you have the following installed on your system:

- **curl**: For making HTTP requests.
- **jq**: For parsing JSON data. You can install it via package managers like `apt`, `brew`, or others depending on your OS.
- **bash**: This script is intended to run in a Bash environment.

## Setup

1. **Clone the repository**: 
   If you haven't already cloned the repository containing this script, do so using:
   ```bash
   git clone https://github.com/CircleCI-Public/usage_export_multiple_orgs.git
   cd usage_export_multiple_orgs
Create or Retrieve your CircleCI API Token: Ensure that you have a CircleCI API token generated, which you will use to authenticate API requests. You can read more about CircleCI personal API tokens here: https://circleci.com/docs/managing-api-tokens/#creating-a-personal-api-token

Edit the Script: Open the script and replace the placeholder REPLACE_WITH_CIRCLE_API_TOKEN with your actual CircleCI API token.

Make the script executable: Run the following command to make the script executable:

```
bash
chmod +x /circleci_usage_export_multi_orgs.sh
```
To execute the script, run the following command:

```
bash
./circleci_usage_export_multi_orgs.sh

```

Script Workflow:
The script authenticates with CircleCI using the provided API token.
It retrieves the list of unique organization IDs associated with your CircleCI account.
For each organization ID, it creates a usage export job with specified start and end dates.
The script polls the job status until completion and downloads the generated files.
Finally, it unzips the downloaded .csv.gz files and renames them to include the date range and organization ID.
Example:
```
bash
./circleci_usage_export.sh
```

Environment Variables
CIRCLE_TOKEN: Your CircleCI API token, used to authenticate requests. Ensure this is set correctly in the script.
START_DATE: The start date for the usage export in ISO 8601 format (e.g., 2025-02-01T00:00:00Z).
END_DATE: The end date for the usage export in ISO 8601 format (e.g., 2025-02-28T00:00:00Z).


Contributing
Contributions to this script are welcome! If you have suggestions for improvements or modifications, feel free to open an issue or submit a pull request.
