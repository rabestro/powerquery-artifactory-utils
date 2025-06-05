/*
    fxAddDateFromVersionString

    Converts a list of version strings into a table, adding a new column with
    the date parsed from each version string.

    This function assumes the date is the 8 characters immediately following
    the first dot in the version string (format: yyyymmdd).

    @param      versionList     (list) A list of version strings to process.
                                Handles formats like "1.20250603..." and "7.20250520-release-..."

    @return     (table) A table with [version, date] columns. The 'date' column
                will be null if a version string could not be parsed.

    @example
                let
                    MyVersions = {"1.20250603.134420-06cd97c9", "7.20250520-release-1-e3968def"},
                    VersionsWithDate = fxAddDateFromVersionString(MyVersions)
                in
                    VersionsWithDate
*/
let
    fxAddDateFromVersionString = (versionList as list) =>
        let
            RecordsList = List.Transform(
                versionList,
                (versionString as text) =>
                    let
                        parsedDate =
                            try
                                let
                                    textAfterDot = Text.AfterDelimiter(versionString, "."),
                                    dateAsText = Text.Start(textAfterDot, 8)
                                in
                                    Date.FromText(dateAsText, [Format="yyyyMMdd", Culture="en-US"])
                                otherwise null
                    in
                        [version = versionString, date = parsedDate]
            ),
            ResultTable = Table.FromRecords(RecordsList, type table [version = Text.Type, date = Date.Type])
        in
            ResultTable
in
    fxAddDateFromVersionString
