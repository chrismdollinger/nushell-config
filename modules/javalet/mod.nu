# Customizations for Java SDK
# base command does nothing
export def main []: nothing -> nothing {
}

# glob search for JDK installations by the `release` file. Searches $env.JAVA_BASE by default
export def jdks []: [ string -> table, nothing -> table ] {
    $in | default $env.JAVA_BASE? |
        path join "*/release" | glob $in | wrap "release_file"
}

# return the contents of a JAVA_HOME's 'release' file as a table
export def releaseinfo [
    java_home?: string # Location of a JDK with a 'release' file. Defaults to $env.JAVA_HOME
]: [
    string -> table
    list<string> -> table
] {
    $in | # Initial input is from the pipeline
        default $java_home | # First fallback is the command's `java_home` parameter
        default $env.JAVA_HOME? | # Second fallback is the JAVA_HOME environment parameter
    each {
        $in | path join 'release' | open --raw | lines | parse '{key}="{value}"' | transpose --header-row --ignore-titles
    }
}


export-env {
    $env.JAVA_BASE = $env.JAVA_BASE? | default ( # Defer to any existing JAVA_BASE
        $env.HOME | path join ".local/java"
    )
    $env.JAVA_HOME = (
        jdks | $in.release_file | path dirname | sort-by --reverse {
            releaseinfo $in | $in.JAVA_VERSION
        }
    ).0
    $env.PATH = $env.PATH | append ( $env.JAVA_HOME | path join 'bin' )
}

