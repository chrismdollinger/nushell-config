# config.nu
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
const config_repo = ('/Users/chris/source/repos/nushell-config/config.nu' | path dirname)
use ( $config_repo + '/modules/' + $nu.os-info.family )
