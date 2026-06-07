#
# Copyright (C) 2024 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

# This file provides variables and macros for building Rust packages
# in OpenWrt using Cargo.

# Rust build needs to find the C toolchain
RUST_MAKEDEPS = rust cargo

# Environment variables for Rust cross-compilation
RUST_CC = $(TARGET_CC)
RUST_CXX = $(TARGET_CXX)
RUST_AR = $(TARGET_AR)
RUST_RUSTFLAGS ?= -C target-feature=+crt-static

# Set up rustflags for optimization
ifdef RUST_RUSTFLAGS
  RUST_RUSTFLAGS += $(TARGET_CFLAGS)
else
  RUST_RUSTFLAGS = $(TARGET_CFLAGS)
endif

# Default Cargo build options
RUST_CARGO_OPTS ?= --release
RUST_CARGO_PROFILE ?= release

# Setup the Cargo environment
define Rust/Configure
	# This is a no-op as Cargo.toml files typically handle configuration
endef

# Default Rust build command
define Rust/Compile
	$(CARGO) build \
		--manifest-path=$(PKG_BUILD_DIR)/Cargo.toml \
		--target=$(RUST_TARGET) \
		$(RUST_CARGO_OPTS) \
		$(RUST_CARGO_COMPILE_ARGS)
endef

# Default Rust install command
define Rust/Install
	$(CARGO) install \
		--root=$(PKG_INSTALL_DIR) \
		--no-track \
		--path=$(PKG_BUILD_DIR) \
		$(RUST_CARGO_OPTS) \
		$(RUST_CARGO_INSTALL_ARGS)
endef

# Allow override of build/install procedures
Rust/Build/Default = $(Rust/Compile)
Rust/Install/Default = $(Rust/Install)

Rust/Build = $(Rust/Build/Default)
Rust/Install = $(Rust/Install/Default)

# Helper function to add cargo as a build dependency
rust_build_dep = $(if $(filter rust,$(RUST_MAKEDEPS)),,RUST_MAKEDEPS += rust)

# Initialize cargo environment
define RustSetupEnv
	export RUST_BACKTRACE=1; \
	export CC="$(RUST_CC)"; \
	export CXX="$(RUST_CXX)"; \
	export AR="$(RUST_AR)"; \
	export RUSTFLAGS="$(RUST_RUSTFLAGS)"; \
	export CARGO_BUILD_TARGET=$(RUST_TARGET); \
	$(if $(CONFIG_RUST_ENABLE),export PATH="$(STAGING_DIR_HOST)/bin:$$PATH";)
endef
