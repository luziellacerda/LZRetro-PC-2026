################################################################################
#
# librsvg
#
################################################################################

LIBRSVG_VERSION_MAJOR = 2.56
LIBRSVG_VERSION = $(LIBRSVG_VERSION_MAJOR).3
LIBRSVG_SITE = https://download.gnome.org/sources/librsvg/$(LIBRSVG_VERSION_MAJOR)
LIBRSVG_SOURCE = librsvg-$(LIBRSVG_VERSION).tar.xz
LIBRSVG_INSTALL_STAGING = YES

LIBRSVG_CONF_ENV = \
	LIBS=$(TARGET_NLS_LIBS) \
	RUST_TARGET=$(RUSTC_TARGET_NAME)

LIBRSVG_CONF_OPTS = \
	--disable-pixbuf-loader \
	--disable-tools

HOST_LIBRSVG_CONF_OPTS = --enable-introspection=no --disable-tools
	--enable-introspection=no

LIBRSVG_DEPENDENCIES = \
	cairo \
	host-gdk-pixbuf \
	gdk-pixbuf \
	host-rustc \
	libglib2 \
	libxml2 \
	pango \
	$(TARGET_NLS_DEPENDENCIES)

HOST_LIBRSVG_DEPENDENCIES = \
	host-cairo \
	host-gdk-pixbuf \
	host-libglib2 \
	host-libxml2 \
	host-pango \
	host-rustc

LIBRSVG_LICENSE = LGPL-2.1+
LIBRSVG_LICENSE_FILES = COPYING.LIB
LIBRSVG_CPE_ID_VENDOR = gnome

LIBRSVG_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBRSVG_CONF_OPTS += --enable-introspection
LIBRSVG_DEPENDENCIES += gobject-introspection
else
LIBRSVG_CONF_OPTS += --disable-introspection
endif


# Force Cargo to use Buildroot cache instead of /home/pc/.cargo

# Cargo cache and host RPATH fix
LIBRSVG_MAKE_ENV = \
	CARGO_HOME=$(BR2_DL_DIR)/br-cargo-home

HOST_LIBRSVG_MAKE_ENV = \
	CARGO_HOME=$(BR2_DL_DIR)/br-cargo-home \
	RUSTFLAGS="-C link-args=-Wl,-rpath,$(HOST_DIR)/lib"


# Remove host rsvg-convert because Buildroot rejects it without proper RPATH
define HOST_LIBRSVG_REMOVE_RSVG_CONVERT
	rm -f $(HOST_DIR)/bin/rsvg-convert
endef
HOST_LIBRSVG_POST_INSTALL_HOOKS += HOST_LIBRSVG_REMOVE_RSVG_CONVERT

$(eval $(autotools-package))
$(eval $(host-autotools-package))
