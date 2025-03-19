# Customizations and modules for dotnet

export-env {
    $env.PATH = $env.PATH | append (
        $nu.home-path | path join '.dotnet/tools'
    )
}
