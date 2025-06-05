/*
    ArtifactoryApiKey (Global Parameter)

    This parameter holds your secret API Key or Identity Token for authenticating
    with the JFrog Artifactory API.

    IMPORTANT: You MUST edit the value below with your personal API key. This
               value is a secret and should be handled securely. Do not commit
               your real key to a public repository.

    The key is used to add the 'X-JFrog-Art-Api' authentication header to API
    requests. This parameter can be left blank if you are only accessing
    public or anonymous repositories.
*/

// Paste your secret API key or identity token here.
// This can be left blank for anonymous access.
"" meta [
    IsParameterQuery = true,
    IsParameterQueryRequired = false,
    Type = type text
]
