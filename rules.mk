HOMEDIR := $(HOME)

ifeq ($(DESTDIR),)
DESTPATH := $(HOMEDIR)/.
else
DESTPATH := $(HOMEDIR)/$(DESTDIR)/
endif

normd = $1
norms = $(subst $(DESTPATH),$(CURDIR)/,$1)
DESTFILES := $(patsubst %,$(DESTPATH)%,$(FILES))

.PHONY: $(DESTFILES) $(FILES)

BANNER := 

ifeq ($(COMMAND),)
 ifeq ($(if $(INSTALL_TYPE),$(INSTALL_TYPE),link),link)
   BANNER := "Using soft link for target $(CIRDIR)..."
   COMMAND =  rm -rf $$_d; ln -sf $$_s $$_d
 endif
else
BANNER := "Using custom $$COMMAND for target $(CURDIR)..."
endif

default: banner $(DESTFILES)

$(DESTFILES): $(FILES)
	@_d=$(call normd,$@); \
	_s=$(call norms,$@); \
	echo -n " * $$_s => $$_d: "; \
	if [ -f $$_d -o -h $$_d ] && [ -n "$$(diff -ur $$_d $$_s)" ]; then \
		echo " ==> differ"; \
		diff -ur $$_d $$_s > $${_s}.local-diff; \
	else \
		[ -f $$_d -o -h $$_d ] && echo " ==> similar"; break;\
		[ -f $$_d -o -h $$_d ] || echo " is not a file or symlink";\
	fi; \
	if [ -n "$(DO_INSTALL)" ]; then \
		echo " ==> replacing"; \
		$(COMMAND); \
	fi; \

banner:
	@echo "$(BANNER)"
