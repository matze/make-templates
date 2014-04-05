#
# c.mk - Generic Makefile for Linux toy applications
#
# Required variables:
#
#   - $(SRC): C source files
#   - $(BIN): filename of linked binary
#
# Optional variables:
#
# 	- $(PKG_DEPS): List of pkg-config compatible packages
# 	- $(CFLAGS), $(LDFLAGS), GNU compliant directories
#
# Example Makefile:
#
#   PKG_DEPS = glib-2.0
#   SRC = foo.c
#   BIN = bar
#
#   include c.mk
#

OBJS = $(patsubst %.c,%.o,$(SRC))

#  Determine C flags and ld flags
ifdef PKG_DEPS
	PKG_CFLAGS = $(shell pkg-config --cflags $(PKG_DEPS))
	PKG_LDFLAGS = $(shell pkg-config --libs $(PKG_DEPS))
else
	PKG_CFLAGS =
	PKG_LDFLAGS =
endif

CFLAGS ?= -Wall -Werror -std=c99 -O2
CFLAGS += $(PKG_CFLAGS)
LDFLAGS += $(PKG_LDFLAGS)

# GNU-compliant install directories
prefix ?= /usr/local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin

# Targets
.PHONY: clean

all: $(BIN)

%.o: %.c
	@echo " CC $@"
	$(CC) -c $(CFLAGS) -o $@ $<

$(BIN): $(OBJS)
	@echo " LD $@"
	@$(CC) $(OBJS) -o $@ $(LDFLAGS)

clean:
	rm -f $(BIN) $(OBJS)

install: $(BIN)
	install -D -m 755 $(BIN) $(DESTDIR)$(bindir)/$(BIN)
