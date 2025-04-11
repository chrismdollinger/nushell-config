#!/usr/bin/env nu
export-env {
    $env.config.shell_integration.osc133 = false
    $env.HOME = ( $env.HOMEDRIVE + $env.HOMEPATH )
    $env.JAVA_BASE = $env.ProgramFiles | path join "Java"
}
