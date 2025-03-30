# Gitlet - quickly perform actions on multiple git repositories at once
# Defaults to `gitlet status` is no subcommands are specified
export def main [
    subglob?: string@subglob_completor # Optional extra subglob, defaults to "**"
]: [
    string -> table
    nothing -> table
] {
    $in | status $subglob
}

# List all git repositories found by glob expression
# If no glob expression is received from the pipeline, default to $env.REPO_HOME/* or $env.PWD/*
export def list [
    subglob?: string@subglob_completor # Optional extra subglob, defaults to "**"
]: [
    string -> list<string>
    nothing -> list<string>
] {
    let search_path: string = $in | default $env.REPO_HOME | default $env.PWD
    let subglob = $subglob | default "**"
    let search_glob: string = $search_path | path join $subglob ".git"

    glob $search_glob --no-file --no-symlink | each {
        path join ".." | path expand
    }
}

# Gitlet Status - summarize the status of multiple repositories at once
# Accepts a glob expression to pass to `gitlet list`, and returns a short status of each repository found
export def status [
    subglob?: string@subglob_completor # Optional extra subglob, defaults to "**"
]: [
    string -> table
    nothing -> table
] {
    let gstat_raw = ( $in | list $subglob ) | each {
        gstat $in |
        insert staged ( $in.idx_added_staged + $in.idx_deleted_staged + $in.idx_renamed + $in.idx_type_changed + $in.idx_modified_staged ) |
        insert unstaged ( $in.wt_untracked + $in.wt_modified + $in.wt_deleted + $in.wt_type_changed + $in.wt_renamed )
    }
    $gstat_raw | select repo_name branch staged unstaged ignored conflicts ahead behind stashes
}

# Gitlet Pull - run a `git pull` before `gitlet status`
export def pull [
    subglob?: string@subglob_completor # Optional extra subglob, defaults to "**"
]: [
    string -> table
    nothing -> table
] {
    let main_in = $in
    $main_in | list $subglob | each { git -C $in pull --prune }
    $main_in | status $subglob
}

# Quick completor for the `subglob` parameter - in case you only want to run a gitlet on a single repository
def subglob_completor [] {
    {
        options: {
            case_sensitive: false,
            completion_algorithm: prefix,
            positional: false,
            sort: false,
        },
        completions: ( $in | list | path basename )
    }
}
