# Customizations for Rust

export-env {
    $env.PATH = $env.PATH + ( char esep ) + $env.HOME + "/.cargo/bin"
    $env.RUSTC_WRAPPER = "sccache"
}
