# Gitlet - wrapper for running `git` and `gstat` on multiple repositories at once
# Defaults to `gitlet list` is no subcommands are specified
export def main [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> table
    list<string> -> table
    nothing -> table
] {
    $in | each { $in | list $filter }
}

# List all git repositories filtered by a glob expression received from the pipeline
# If no string is received, default to $env.REPO_HOME/* or $env.PWD/*
export def list [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> table
    nothing -> table
] {
    let search_path: string = $in | default $env.REPO_HOME | default $env.PWD
    let filter = $filter | default "**"
    let search_glob: string = $search_path | path join $filter ".git"

    glob $search_glob --no-file --no-symlink | each {
            path join ".." | path expand
        } | wrap "path" | insert repo {|row|
            $row.path | path basename
        }
}

# Gitlet Status - check all of your repositories' statuses at once
export def status [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> table
    list<string> -> table
    nothing -> table
] {
    $in | each { $in | list $filter }
}

# Gitlet Pull - run a `git pull` and check all of your repositories' statuses at once
# If no string is received, default to $env.REPO_HOME/* or $env.PWD/*
export def pull [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> table
    list<string> -> table
    nothing -> table
] {
    let in_pipe = $in
    $in_pipe | each { $in | list $filter } | each { git -C $in.path pull --prune }
    $in_pipe | status $filter
}

