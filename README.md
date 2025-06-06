# Power Query Artifactory Utils

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A toolkit of custom Power Query (M) functions designed to simplify data extraction from the JFrog Artifactory REST API.

This repository contains a set of helper functions that allow you to easily connect to your Artifactory instance and pull metadata about repositories, artifacts, versions, and more directly into your data models in **Power BI**, **Excel**, and **Dataflows**.

## Key Features

* **Simplified API Access:** No need to manually build `Web.Contents` calls. These functions handle the specifics of the Artifactory API endpoints.
* **Flexible & Powerful Search:** Use simple parameters or the full power of Artifactory Query Language (AQL).
* **Robust Parsing Utilities:** Includes helper functions to parse complex version strings into structured data.
* **Parameterized & Reusable:** Built with best practices to be easily configured and reused across multiple projects.

## Core Functions

Here are some of the key functions available in this toolkit:

### `fxSearchVersions`
Searches for all available versions of a specific Maven artifact by querying the 'versions' search API.
```m
(groupId as text, artifactId as text, optional repository as nullable text) as list
````

**Example:**

```m
fxSearchVersions("com.fasterxml.jackson.core", "jackson-databind")
```

### `fxSearchWithAQL`

Executes a raw Artifactory Query Language (AQL) search and returns the results as a dynamic table.

```m
(AqlQueryString as text) as table
```

**Example:**

```m
let
    MyQuery = "items.find({"repo":"releases"}).include("name", "path")"
in
    fxSearchWithAQL(MyQuery)
```

### `fxGetLatestReleasesByDate`

From a list of version strings, this function finds the latest release for each date, determined by the highest number immediately following "-release-".

```m
(versionList as list) as table
```

**Example:**

```m
let
    MyVersions = {"7.20240101-release-1", "7.20240101-release-2", "8.20240102-release-1"},
    Latest = fxGetLatestReleasesByDate(MyVersions)
in
    Latest
```

### `fxParseVersionToRecord`

Parses a single build-version string (e.g., `major.yyyymmdd.hhmmss-hash`) into a structured record containing its constituent parts.

```m
(versionText as text) as record
```

**Example:**

```m
fxParseVersionToRecord("1.20250530.101919-c0b55fee")
```

### `fxParseVersionDate`

Parses a single version string to extract its embedded date, supporting multiple common formats.

```m
(version as text) as nullable date
```

**Example:**

```m
fxParseVersionDate("1.20250603.134420-06cd97c9")
// returns #date(2025, 6, 3)
```

## Requirements

Before using these functions, you need to configure parameters in your Power Query environment.

1.  **A Power Query Environment:**

    * Power BI Desktop
    * Excel for Windows/Mac (with Power Query support)
    * Power Platform Dataflows

2.  **`ArtifactoryHost` Parameter (Required):**
    You **must** configure a text parameter that holds the base URL of your Artifactory instance.

    * **Name:** `ArtifactoryHost`
    * **Type:** `Text`
    * **Value:** `https://your-company.jfrog.io`

3.  **`ArtifactoryApiKey` Parameter (Optional):**
    For accessing private repositories, you **must** configure a text parameter for your API Key or Identity Token. This can be left blank for anonymous access.

    * **Name:** `ArtifactoryApiKey`
    * **Type:** `Text`
    * **Value:** `"<Your-Secret-API-Key>"`

## Installation & Usage

To use a function from this repository:

1.  **Create a New Blank Query:** In the Power Query Editor, right-click in the queries pane and select `New Query` \> `Blank Query`.

2.  **Copy the Code:** Open the `.pq` file for the function you want to use (e.g., `fxSearchVersions.pq`). Copy the entire M code.

3.  **Paste into the Advanced Editor:** In your new blank query, click on `Advanced Editor` and paste the code.

4.  **Rename the Query:** Rename the query to match the function's name (e.g., `fxSearchVersions`). This makes it easy to find and invoke.

5.  **Invoke the Function:** You can now use the function in other queries.

    ```m
    let
        // Example of how to call a function from this toolkit
        Source = fxSearchVersions("com.mycompany.group", "my-artifact-id")
    in
        Source
    ```

## Contributing

Contributions are welcome\! If you have ideas for new functions, find a bug, or have a suggestion for improvement, please feel free to:

* Open an [Issue](https://github.com/rabestro/powerquery-artifactory-utils/issues) to discuss the change.
* Submit a [Pull Request](https://github.com/rabestro/powerquery-artifactory-utils/pulls) with your proposed changes.

## License

This project is licensed under the MIT License. See the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

Copyright (c) 2025 Jegors Čemisovs
