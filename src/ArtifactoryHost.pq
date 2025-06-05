/*
    ArtifactoryHost (Global Parameter)

    This parameter defines the base URL for your JFrog Artifactory instance.

    ==============================================================================
    IMPORTANT: You MUST edit the 'Current Value' of this parameter in the
               Power Query Editor (or directly in this file) to point to your
               own Artifactory server address.
    ==============================================================================

    All functions in the 'powerquery-artifactory-utils' toolkit depend on this
    parameter to connect to the correct API endpoint.

    Example Value: "https://mycompany.jfrog.io"
*/

// Replace the placeholder URL below with your actual Artifactory host address.
"https://your-artifactory-host.com" meta [
    IsParameterQuery = true,
    IsParameterQueryRequired = true,
    Type = type text
]
