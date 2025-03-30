# Gitlet - wrapper for running `git` and `gstat` on multiple repositories at once
# Defaults to `gitlet status` is no subcommands are specified
export def main [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> table
    nothing -> table
] {
    $in | status $filter
}

# List all git repositories filtered by a glob expression received from the pipeline
# If no string is received, default to $env.REPO_HOME/* or $env.PWD/*
export def list [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> list<string>
    nothing -> list<string>
] {
    let search_path: string = $in | default $env.REPO_HOME | default $env.PWD
    let filter = $filter | default "**"
    let search_glob: string = $search_path | path join $filter ".git"

    glob $search_glob --no-file --no-symlink | each {
        path join ".." | path expand
    }
}

# Gitlet Status - check all of your repositories' statuses at once
export def status [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> table
    nothing -> table
] {
    let gstat_raw = ( $in | list $filter ) | each {
        gstat $in |
        insert staged ( $in.idx_added_staged + $in.idx_deleted_staged + $in.idx_renamed + $in.idx_type_changed + $in.idx_modified_staged ) |
        insert unstaged ( $in.wt_untracked + $in.wt_modified + $in.wt_deleted + $in.wt_type_changed + $in.wt_renamed )
    }
    $gstat_raw | select repo_name branch staged unstaged ignored conflicts ahead behind stashes
}

# Gitlet Pull - run a `git pull` and check all of your repositories' statuses at once
# If no string is received, default to $env.REPO_HOME/* or $env.PWD/*
export def pull [
    filter?: string # Optional extra filter, for when it is desired to use the default search *and* a filter
]: [
    string -> table
    nothing -> table
] {
    let main_in = $in
    $main_in | list $filter | each { git -C $in pull --prune }
    $main_in | status $filter
}

