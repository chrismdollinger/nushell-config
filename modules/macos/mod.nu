# Customizations specific to macOS

export-env {
    $env.HOMEBREW_CELLAR = '/opt/homebrew/Cellar'
    $env.HOMEBREW_REPOSITORY = '/opt/homebrew'
    $env.PATH = (
        $env.PATH |
        append [
            '/opt/homebrew/bin'
            '/opt/homebrew/sbin'
            '/usr/bin'
            '/bin'
            '/usr/sbin'
            '/sbin'
        ]
    )
}
