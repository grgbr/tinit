bins              := shutlinux

shutlinux-objs    := shutlinux.o
shutlinux-cflags  := $(EXTRA_CFLAGS) -Wall -Wextra -D_GNU_SOURCE
shutlinux-ldflags := $(EXTRA_LDFLAGS)
shutlinux-path    := $(LIBEXECDIR)/tinit/shutlinux

scripts := sysinit shutdown

install: $(addprefix $(DESTDIR)$(LIBEXECDIR)/tinit/,$(scripts)) \
         $(addprefix $(DESTDIR)$(LIBEXECDIR)/tinit/,common) \
         $(DESTDIR)$(SBINDIR)/init

$(addprefix $(DESTDIR)$(LIBEXECDIR)/tinit/,$(scripts)): \
	$(DESTDIR)$(LIBEXECDIR)/tinit/%: $(SRCDIR)/%
		$(call install_recipe,-m755,$(<),$(@))

$(DESTDIR)$(LIBEXECDIR)/tinit/common: $(SRCDIR)/common
	$(call install_recipe,-m644,$(<),$(@))

# Create $(1) link pointing to $(2) filesystem entry. Link target will be
# relative to directory containing $(1)
# This is needed to cope with cpio archiver which refuses to include dangling
# symlinks...
lnrel_recipe = $(call ln_recipe, \
                      $(shell realpath --relative-to=$(dir $(2)) $(1)), \
                      $(2))

$(DESTDIR)$(SBINDIR)/init: $(DESTDIR)$(LIBEXECDIR)/tinit/sysinit
	$(call lnrel_recipe,$(<),$(@))

uninstall: $(addprefix uninstall-,$(scripts) common) uninstall-sbin_init

.PHONY: $(addprefix uninstall-,$(scripts) common)
$(addprefix uninstall-,$(scripts) common):
	$(call uninstall_recipe, \
	       $(DESTDIR)$(LIBEXECDIR)/tinit, \
	       $(subst uninstall-,,$(@)))

.PHONY: uninstall-sbin_init
uninstall-sbin_init:
	$(call uninstall_recipe,$(DESTDIR)$(SBINDIR),init)
