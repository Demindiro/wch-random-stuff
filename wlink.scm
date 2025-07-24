(use-modules
  (guix packages)
  (guix download)
  (guix build-system cargo)
  ((guix licenses) #:prefix license:)
  (gnu packages pkg-config)
  (gnu packages libusb)
  (gnu packages crates-apple)
  (gnu packages crates-io)
  (gnu packages crates-shell)
  (gnu packages linux))

(define-public rust-io-kit-sys-0.4
  (package
    (name "rust-io-kit-sys")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "io-kit-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ysy5k3wf54yangy25hkj10xx332cj2hb937xasg6riziv7yczk1"))))
	(build-system cargo-build-system)
	(home-page "https://lib.rs/crates/io-kit-sys")
    (synopsis "Bindings to IOKit for macOS")
    (description "Bindings to IOKit for macOS.")
    (license (list license:expat))))

(define-public rust-unescaper-0.1
  (package
    (name "rust-unescaper")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unescaper" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09hzbayg38dvc298zygrx7wvs228bz197winnjl34i3alpii47f0"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/hack-ink/unescaper")
    (synopsis "Unescape strings with escape sequences written out as literal characters")
    (description
     "Unescape strings with escape sequences written out as literal characters.")
    (license (list license:expat))))

(define-public rust-libudev-0.3
  (package
    (name "rust-libudev")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libudev" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1q1my5alvdwyi8i9pc9gn2mcx5rhbsssmz5cjnxzfpd65laj9cvq"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/dcuddeback/libudev-rs")
    (synopsis "Rust wrapper for libudev")
    (description
     "This crate provides a safe wrapper around the native libudev library.")
    (license (list license:expat))))

(define-public rust-bitfield-0.17
  (package
    (name "rust-bitfield")
    (version "0.17.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bitfield" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1q4n13japrj852yzidhjfcq702yxkvrpv5mhmacsliz5az8x567p"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/dzamlo/rust-bitfield")
    (synopsis "Macros to generate bitfield-like struct")
    (description
     "This Rust crate provides macros to generate bitfield-like struct.")
    (license (list license:expat license:asl2.0))))

(define-public rust-serialport-4
  (package
    (name "rust-serialport")
    (version "4.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serialport" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0aqaig121lm034irzal6j9dyg7jpf4hczrjlmf5yzxka9ycbrc6d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-cfg-if" ,rust-cfg-if-1)
        ("rust-scopeguard" ,rust-scopeguard-1)
        ("rust-unescaper" ,rust-unescaper-0.1)
        ("rust-core-foundation" ,rust-core-foundation-0.10)
        ("rust-io-kit-sys" ,rust-io-kit-sys-0.4)
		("rust-mach2" ,rust-mach2-0.4)
        ("rust-libudev" ,rust-libudev-0.3)
        ("rust-libudev-sys" ,rust-libudev-sys-0.1))))
    (inputs (list eudev pkg-config))
    (home-page
     "https://github.com/serialport/serialport-rs")
    (synopsis "A cross-platform serial port library in Rust")
    (description
     "serialport-rs is a general-purpose cross-platform serial port library for Rust. It provides a blocking I/O interface and port enumeration on POSIX and Windows systems.")
    (license license:expat)))

(define-public rust-nu-pretty-hex-0.100
  (package
    (name "rust-nu-pretty-hex")
    (version "0.100.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nu-pretty-hex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1alqadx31r5gf914blrjaw93iqisnjx0p94z08mc7qbnpdjdncz7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-nu-ansi-term" ,rust-nu-ansi-term-0.50))
       #:cargo-development-inputs
       (("rust-heapless" ,rust-heapless-0.8)
        ("rust-rand" ,rust-rand-0.8))))
    (home-page
     "https://github.com/nushell/nushell/tree/main/crates/nu-pretty-hex")
    (synopsis "Pretty hex dump of bytes slice in the common style")
    (description
     "This package provides pretty hex dump of bytes slice in the common style.")
    (license license:expat)))

(define-public wlink
  (package
    (name "wlink")
    (version "0.1.1")
    (source
      (origin
        (method url-fetch)
        (uri "https://github.com/ch32-rs/wlink/archive/refs/tags/v0.1.1.tar.gz")
        (file-name "v0.1.1.tar.gz")
        (sha256
          (base32 "18x9an5ik9b7vz9b9jnmddkfv5aln2w8lsgyki43v27iipvdyyl1"))
        (modules '((guix build utils)))))
    (build-system cargo-build-system)
    (arguments
     `(#:install-source? #f
       #:cargo-inputs
        (("rust-anyhow" ,rust-anyhow-1)
         ("rust-bitfield" ,rust-bitfield-0.17)
         ("rust-clap" ,rust-clap-4)
         ("rust-hex" ,rust-hex-0.4)
         ("rust-ihex" ,rust-ihex-3)
         ("rust-log" ,rust-log-0.4)
         ("rust-nu-pretty-hex" ,rust-nu-pretty-hex-0.101)
         ("rust-rusb" ,rust-rusb-0.9)
         ("rust-simplelog" ,rust-simplelog-0.12)
         ("rust-thiserror" ,rust-thiserror-2)
         ("rust-object" ,rust-object-0.36)
         ("rust-indicatif" ,rust-indicatif-0.17)
         ("rust-serialport" ,rust-serialport-4)
         ("rust-libloading" ,rust-libloading-0.8)
         ("rust-chrono" ,rust-chrono-0.4)
         ("rust-clap-verbosity-flag" ,rust-clap-verbosity-flag-2))))
    (inputs (list eudev pkg-config libusb))
    (home-page "https://git.tozt.net/rbw")
    (synopsis "Unofficial WCH-Link command line tool")
    (description "This package is an unofficial command line tool for use with WCH-Link.
NOTE: This tool is still in development and not ready for production use.")
    (license license:expat)))

wlink
