# Installs this repository's configuration by sourcing its `config.nu` in Nushell's configured config-path.
def main [--force (-f)] {
    add_plugins
    "source " + (
        $env.FILE_PWD | path join "config.nu"
    ) | save --force=$force $nu.config-path
    print "Install complete - please restart your Nu shells"
}

def add_plugins [] {
    const plugins = [
        nu_plugin_inc
        nu_plugin_polars
        nu_plugin_gstat
        nu_plugin_formats
        nu_plugin_query
    ]
    $plugins | each { plugin add $in }
}
