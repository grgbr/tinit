EBUILDDIR     := $(CURDIR)/ebuild
PACKAGE       := tinit
EXTRA_CFLAGS  := -O2 -DNDEBUG
EXTRA_LDFLAGS := -O2

override PREFIX :=

export EXTRA_CFLAGS EXTRA_LDFLAGS PREFIX

include $(EBUILDDIR)/main.mk
