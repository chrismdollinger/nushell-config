# config.nu
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#

$env.PATH = ( $env.PATH | split row ( char esep) )
$env.config.show_banner = false

export-env {
    $env.EDITOR = 'nvim'
    $env.REPO_HOME = ( $nu.home-path + '/source/repos' )
}
const config_repo = ( $nu.home-path + '/source/repos/nushell-config' )
use ( $config_repo + '/modules/' + $nu.os-info.name )
use ( $config_repo + '/modules/oracle' )
use ( $config_repo + '/modules/rust' )
use ( $config_repo + '/modules/javalet' )
use ( $config_repo + '/modules/dotnetlet' )

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
