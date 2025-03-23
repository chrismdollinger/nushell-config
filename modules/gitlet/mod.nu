# Gitlet - wrapper for running `git` and `gstat` on multiple repositories at once
# Defaults to `gitlet list` is no subcommands are specified
export def main [
    filter?: glob # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    glob -> table
    list<glob> -> table
    nothing -> table
] {
    $in | each { $in | list $filter }
}

# List all git repositories filtered by a glob received from the pipeline
# If no glob is received, default to $env.REPO_HOME/* or $env.PWD/*
export def list [
    filter?: glob # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    glob -> table
    nothing -> table
] {
    let search_path: glob = (
        $in | default $env.REPO_HOME | default $env.PWD
    ) + '/' + (
        $filter | default '*'
    )
    glob $search_path --no-file --exclude [ **/.git/** ] |
        wrap "path" |
        insert repo {|row| $row.path | path basename }
}

# Gitlet Status - check all of your repositories' statuses at once
export def status [
    filter?: glob # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    glob -> table
    list<glob> -> table
    nothing -> table
] {
    $in | each { $in | list $filter }
}

# Gitlet Pull - run a `git pull` and check all of your repositories' statuses at once
# If no glob is received, default to $env.REPO_HOME/* or $env.PWD/*
export def pull [
    filter?: glob # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    glob -> table
    list<glob> -> table
    nothing -> table
] {
    let in_pipe = $in
    $in_pipe | each { $in | list $filter } | each { git -C $in.path pull --prune }
    $in_pipe | status $filter
}

