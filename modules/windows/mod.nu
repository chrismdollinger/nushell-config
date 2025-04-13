#!/usr/bin/env nu

# Using the default Visual Studio Buildtools location, find the latest verison of MSVC tools to add to the path
# Doesn't throw an error if MSVC isn't found, just returns null
def llvm-search [
    vs_path?: string
] {
    $vs_path | default (
        $env | select "ProgramFiles(x86)" | values | first | path join "Microsoft Visual Studio" "2022" "BuildTools"
    ) | try {
        ls ( $in | path join "VC" "Tools" "Llvm" )
    } catch {
        return null
    } |
    select name | values | flatten | sort --reverse | first |
    path join "bin"
}

export-env {
    $env.config.shell_integration.osc133 = false
    $env.HOME = ( $env.HOMEDRIVE + $env.HOMEPATH )
    $env.JAVA_BASE = $env.ProgramFiles | path join "Java"
    $env.PATH = $env.PATH | append ( llvm-search ) # Find clang for nvim-treesitter
}
