/*
    fxGetLatestReleasesByDate

    From a list of version strings, this function finds the latest release for each date.
    "Latest" is determined by the highest number immediately following "-release-".

    @param      versionList     (list) A list of version strings to process.
                                Expected format: "major.yyyymmdd-release-N-hash"

    @return     (table) A table with [version, date] columns, containing the latest
                release version for each date found in the list.

    @example
                let
                    MyVersions = {"7.20240101-release-1", "7.20240101-release-2", "8.20240102-release-1"},
                    Latest = fxGetLatestReleasesByDate(MyVersions)
                in
                    Latest
*/
let
    fxGetLatestReleasesByDate = (versionList as list) =>
        let
            // Step 1: Filter the incoming list to only include items containing "-release-".
            FilterToReleaseOnly = List.Select(versionList, each Text.Contains(_, "-release-")),
            // Step 2: Transform the list into a table with parsed date and release number.
            ParsedTable = Table.FromRecords(
                List.Transform(
                    FilterToReleaseOnly,
                    (versionString) =>
                        let
                            dateAsText = Text.BeforeDelimiter(Text.AfterDelimiter(versionString, "."), "-"),
                            parsedDate =
                                try
                                    Date.FromText(dateAsText, [Format = "yyyyMMdd", Culture = "en-US"])
                                otherwise
                                    null,
                            // Extract the number after "-release-" and before the next hyphen.
                            releaseNumAsText = Text.BeforeDelimiter(
                                Text.AfterDelimiter(versionString, "-release-"), "-"
                            ),
                            parsedReleaseNum = try Number.FromText(releaseNumAsText) otherwise null
                        in
                            [version = versionString, date = parsedDate, releaseNumber = parsedReleaseNum]
                ),
                type table [version = Text.Type, date = Date.Type, releaseNumber = Int64.Type]
            ),
            // Step 3: Group the table by date. For each date group, find the record with the highest releaseNumber.
            GroupedByDate = Table.Group(
                ParsedTable,
                {"date"},
                {
                    {
                        "LatestVersionRecord",
                        // For each sub-table (all rows for a given date), sort by releaseNumber descending and take the first record.
                        each Table.First(Table.Sort(_, {{"releaseNumber", Order.Descending}})),
                        type record
                    }
                }
            ),
            // Step 4: Expand the record column to get the full version string.
            ExpandedData = Table.ExpandRecordColumn(GroupedByDate, "LatestVersionRecord", {"version"}, {"version"}),
            // Step 5: Select and reorder the final columns for a clean output.
            FinalTable = Table.SelectColumns(ExpandedData, {"version", "date"})
        in
            FinalTable
in
    fxGetLatestReleasesByDate
