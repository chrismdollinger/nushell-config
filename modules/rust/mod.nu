# Customizations for Rust

export-env {
    $env.PATH = ( $env.PATH | append ( $env.HOME + "/.cargo/bin" ) )
    $env.RUSTC_WRAPPER = "sccache"
}
