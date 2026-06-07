# Copyright (C) 2026 Egidijus01
#
# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

PKG_NAME:=webshell
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Egidijus01/webshell.git
PKG_SOURCE_DATE:=2026-06-07
PKG_SOURCE_VERSION:=HEAD

PKG_MAINTAINER:=Egidijus01
PKG_LICENSE:=GPL-2.0-only

PKG_BUILD_DEPENDS:=rust/host cargo/host
PKG_BUILD_PARALLEL:=1
PKG_ASLR_PIE_REGULAR:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/rust.mk

define Package/webshell/default
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Web Servers/Proxies
	TITLE:=WebShell - Web-based shell access
endef

define Package/webshell
	$(Package/webshell/default)
	DEPENDS:=+libcrypt
endef

define Package/webshell/description
	WebShell is a web-based shell interface providing terminal access over HTTP/HTTPS,
	similar to shellinabox. It allows secure remote shell access through a web browser.
endef

define Build/Compile
	cd $(PKG_BUILD_DIR) && \
	$(CARGO) build \
		--release \
		--target=$(RUST_TARGET) \
		--manifest-path=Cargo.toml
endef

define Package/webshell/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/target/$(RUST_TARGET)/release/webshell $(1)/usr/sbin/webshell
	$(INSTALL_BIN) ./files/webshell.init $(1)/etc/init.d/webshell
	$(INSTALL_CONF) ./files/webshell.config $(1)/etc/config/webshell
endef

define Package/webshell/conffiles
	/etc/config/webshell
endef

$(eval $(call BuildPackage,webshell))
