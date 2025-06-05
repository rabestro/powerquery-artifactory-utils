/*
    fxParseBuildVersions

    Parses a list of build-version strings into a structured table. This function assumes
    versions are in the format: "major.yyyymmdd.hhmmss-hash".

    @param      versionList     (list) A list of version strings to parse.

    @return     (table) A table with columns [version, major, datetime, hash].
                The 'datetime' column will be null if parsing fails for a specific version.

    @example
                fxParseBuildVersions({"1.20250530.101919-c0b55fee", "2.20250601.120000-abcdef12"})
*/
(versionList as list) =>
    let
        // Iterate over the input list and transform each version string into a record
        TransformedList = List.Transform(
            versionList,
            (versionText as text) =>
                let
                    // Split the version string into its constituent parts using delimiters
                    major = Text.BeforeDelimiter(versionText, "."),
                    restAfterMajor = Text.AfterDelimiter(versionText, "."),
                    dateString = Text.BeforeDelimiter(restAfterMajor, "."),
                    restAfterDate = Text.AfterDelimiter(restAfterMajor, "."),
                    timeString = Text.BeforeDelimiter(restAfterDate, "-"),
                    hash = Text.AfterDelimiter(restAfterDate, "-"),
                    // Attempt to parse the date and time parts into a single DateTime value
                    dateTimeValue =
                        try
                            DateTime.FromText(dateString & timeString, [Format = "yyyyMMddHHmmss", Culture = "en-US"])
                        otherwise
                            null,
                    // Assemble the parsed parts into a structured record
                    result = [
                        version = versionText,
                        major = Text.From(major),
                        datetime = dateTimeValue,
                        hash = hash
                    ]
                in
                    result
        ),
        // Convert the list of records into a final, typed table for stability and performance
        ResultTable = Table.FromRecords(
            TransformedList,
            type table [version = Text.Type, major = Text.Type, datetime = DateTime.Type, hash = Text.Type]
        )
    in
        ResultTable
