/*
    fxSearchWithAQL

    Executes a JFrog Artifactory Query Language (AQL) search and returns the results.

    @param      AqlQueryString  (text) The AQL query to execute.

    @return     (table) A table containing the search results. Returns an empty
                table if the query has no results.

    @example
                let
                    MyQuery = "items.find({"repo":"releases"}).include("name", "path")"
                in
                    fxSearchWithAQL(MyQuery)

    @requires   A global parameter named 'ArtifactoryHost' must be defined.
*/
(AqlQueryString as text) =>
    let
        // Configuration
        BaseHost = ArtifactoryHost,
        AqlApiEndpoint = BaseHost & "/artifactory/api/search/aql",
        // Prepare and execute the API POST request
        BinaryAqlQuery = Text.ToBinary(AqlQueryString),
        ApiResponse = Web.Contents(
            AqlApiEndpoint, [
                Headers = [#"Content-Type" = "text/plain"],
                Content = BinaryAqlQuery
            ]
        ),
        // Process the JSON response
        ParsedJson = Json.Document(ApiResponse),
        ResultsList = Record.FieldOrDefault(ParsedJson, "results", {}),
        ResultTable = Table.FromList(ResultsList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
        ExpandedResults = Table.ExpandRecordColumn(
            ResultTable,
            "Column1",
            {"name", "repo", "path", "type", "size", "created", "modified"},
            {"Name", "Repo", "Path", "Type", "Size", "Created", "Modified"}
        )
    in
        ExpandedResults
