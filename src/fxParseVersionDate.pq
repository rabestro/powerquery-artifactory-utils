/*
    fxParseVersionDate

    Parses a single version string to extract its embedded date. This function
    is a building block for more complex transformations.

    It assumes the date is the 8 characters immediately following the first
    dot in the version string (format: yyyymmdd).

    @param      version  (text) The version string to parse.
                         Handles formats like "1.20250603..." and "7.20250520-release-..."

    @return     (date) A date object, or null if the version string could not be parsed.

    @example
                fxParseVersionDate("1.20250603.134420-06cd97c9")
                // returns #date(2025, 6, 3)
*/
let
    fxParseVersionDate = (version as text) =>
        let
            parsedDate =
                try
                    let
                        textAfterDot = Text.AfterDelimiter(version, "."),
                        dateAsText = Text.Start(textAfterDot, 8)
                    in
                        Date.FromText(dateAsText, [Format = "yyyyMMdd", Culture = "en-US"])
                    otherwise null
        in
            parsedDate
in
    fxParseVersionDate
