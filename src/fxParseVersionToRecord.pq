/*
  fxParseVersionToRecord

  Parses a single build-version string into a structured record containing its
  constituent parts.

  This function assumes the version is in the format: "major.yyyymmdd.hhmmss-hash".

  @param      versionText     (text) The single version string to parse.

  @return     (record) A record with fields [version, major, datetime, hash].
              Fields will be null if parsing fails for any component.

  @example
              fxParseVersionToRecord("1.20250530.101919-c0b55fee")
              // returns [
              //      version = "1.20250530.101919-c0b55fee",
              //      major = "1",
              //      datetime = #datetime(2025, 5, 30, 10, 19, 19),
              //      hash = "c0b55fee"
              // ]
*/
(versionText as text) as record =>
    let
        // Use a 'try...otherwise' block to gracefully handle any string
        // that does not match the expected format (e.g., missing delimiters).
        ParsedRecord =
            try
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
                            null
                in
                    // Assemble the parsed parts into a structured record
                    [
                        version = versionText,
                        major = major,
                        datetime = dateTimeValue,
                        hash = hash
                    ]
                otherwise
                // If parsing fails completely, return a record with a predictable shape
                [
                    version = versionText,
                    major = null,
                    datetime = null,
                    hash = null
                ]
    in
        ParsedRecord
