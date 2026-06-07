include $(TOPDIR)/rules.mk

PKG_NAME:=rust
PKG_VERSION:=1.78.0

PKG_SOURCE_URL:=https://github.com/rust-lang/rust/archive/refs/tags/
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)

PKG_HASH:=skip

HOST_BUILD_PARALLEL:=1
HOST_BUILD_DIR:=$(BUILD_DIR_TOOLCHAIN)/$(PKG_SOURCE_SUBDIR)

include $(INCLUDE_DIR)/toolchain-build.mk

# Custom Rust configuration
define Host/Prepare
	$(call Host/Prepare/Default)
	ln -snf $(notdir $(HOST_BUILD_DIR)) $(BUILD_DIR_TOOLCHAIN)/$(PKG_NAME)
endef

define Host/Configure
	(cd $(HOST_BUILD_DIR); \
		./configure \
		--prefix=$(TOOLCHAIN_DIR) \
		--host=$(GNU_HOST_NAME) \
		--target=$(REAL_GNU_TARGET_NAME) \
		--enable-extended \
		--enable-tools=cargo,rustdoc \
		--disable-docs \
		--release \
	)
endef

define Host/Compile
	$(MAKE) -C $(HOST_BUILD_DIR) \
		$(HOST_MAKE_FLAGS)
endef

define Host/Install
	$(MAKE) -C $(HOST_BUILD_DIR) \
		$(HOST_MAKE_FLAGS) \
		DESTDIR=$(TOOLCHAIN_DIR) \
		install
	# Create symlinks for convenience
	ln -snf $(TOOLCHAIN_DIR)/bin/rustc $(TOOLCHAIN_DIR)/bin/rust-gcc
endef

define Host/Clean
	rm -rf \
		$(HOST_BUILD_DIR) \
		$(BUILD_DIR_TOOLCHAIN)/$(PKG_NAME) \
		$(TOOLCHAIN_DIR)/rust
endef

$(eval $(call HostBuild))
