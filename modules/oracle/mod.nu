# Cusomizations for Oracle related tools

export-env {
    $env.ORACLE_BASE = $env.HOME + '/.local/oracle'
    $env.SQLPATH = $env.ORACLE_BASE + '/sql'
    $env.TNS_ADMIN = $env.ORACLE_BASE + '/network/admin'
    $env.PATH = (
        $env.PATH | append [
            ( $env.ORACLE_BASE + '/product/sqlcl/bin' )
        ]
    )
}
