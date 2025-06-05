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

    @requires   Global parameters 'ArtifactoryHost' and optionally 'ArtifactoryApiKey' must be defined.
*/
(AqlQueryString as text) as table =>
    let
        // Configuration
        BaseHost = ArtifactoryHost,
        AqlApiEndpoint = BaseHost & "/artifactory/api/search/aql",
        // Prepare and execute the API POST request
        BinaryAqlQuery = Text.ToBinary(AqlQueryString),
        BaseHeaders = [#"Content-Type"="text/plain"],
        AuthHeader = if ArtifactoryApiKey <> null and ArtifactoryApiKey <> ""
                     then [#"X-JFrog-Art-Api" = ArtifactoryApiKey]
                     else [], // Add the auth header only if the API key parameter has a value
        FinalHeaders = Record.Combine({BaseHeaders, AuthHeader}),
        ApiResponse = Web.Contents(
            AqlApiEndpoint, [
                Headers = FinalHeaders,
                Content = BinaryAqlQuery
            ]
        ),
        // Process the JSON response
        ParsedJson = Json.Document(ApiResponse),
        ResultsList = Record.FieldOrDefault(ParsedJson, "results", {}),
        ResultTable = Table.FromList(ResultsList, Splitter.SplitByNothing(), {"Column1"}, null, ExtraValues.Error),
        ExpandedResults = if Table.RowCount(ResultTable) > 0 then
            let
                SampleRecord = ResultTable{0}[Column1],
                FieldNames = Record.FieldNames(SampleRecord),
                ColumnNames = List.Transform(FieldNames, each Text.Proper(_))
            in
                Table.ExpandRecordColumn(ResultTable, "Column1", FieldNames, ColumnNames)
        else
            #table({}, {})
    in
        ExpandedResults
