/*
    fxSearchVersions

    Searches for all available versions of a specific Maven artifact in Artifactory
    by querying the 'versions' search API.

    @param      groupId         (text) The group ID of the artifact (e.g., "org.springframework.boot").
    @param      artifactId      (text) The artifact ID (e.g., "spring-boot-starter-web").
    @param      repository      (nullable text) Optional. The specific repository to search in. Defaults to "releases".

    @return     (list) A list of text values, where each value is a version string (e.g., {"2.7.0", "2.7.1", "3.0.0"}).
                Returns an empty list if the artifact is not found.

    @example
                fxSearchVersions("com.fasterxml.jackson.core", "jackson-databind")

    @requires   A global parameter named 'ArtifactoryHost' must be defined, holding the base URL
                of your Artifactory instance (e.g., "https://mycompany.jfrog.io").
*/
(groupId as text, artifactId as text, optional repository as nullable text) as list =>
    let
        // Use the required parameter for the base URL.
        BaseHost =
            if ArtifactoryHost <> null and ArtifactoryHost <> "" then
                ArtifactoryHost
            else
                error "ArtifactoryHost parameter is required and must be a valid URL",
        // Set the target repository, defaulting to "releases" if a value isn't provided.
        TargetRepo = repository ?? "releases",
        // Define the query parameters for the API call.
        QueryParameters = [
            g = groupId,
            a = artifactId,
            repos = TargetRepo
        ],
        // Fetch the data from the API.
        ApiResponse = Web.Contents(
            BaseHost,
            [
                RelativePath = "/artifactory/api/search/versions",
                Query = QueryParameters,
                Headers = [#"Accept" = "application/json"]
            ]
        ),
        // Parse the JSON response from the API.
        ParsedJson = Json.Document(ApiResponse),
        // Access the "results" list, defaulting to an empty list if not found to prevent errors.
        ResultsList = Record.FieldOrDefault(ParsedJson, "results", {}),
        // Transform the list of records to extract and type-cast the "version" field in a single pass.
        ListOfVersions = List.Transform(
            ResultsList,
            each
                let
                    versionValue = Record.FieldOrDefault(_, "version", null)
                in
                    if versionValue <> null then
                        Text.From(versionValue)
                    else
                        null
        ),
        // Remove any nulls that may have resulted from missing "version" fields.
        CleanedListOfVersions = List.RemoveNulls(ListOfVersions)
    in
        CleanedListOfVersions
