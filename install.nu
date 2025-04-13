# Installs this repository's configuration by sourcing its `config.nu` in Nushell's configured config-path.
def main [--force (-f)] {
    "source " + (
        $env.FILE_PWD | path join "config.nu"
    ) | save --force=$force $nu.config-path
}
