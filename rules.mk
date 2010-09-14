HOMEDIR := $(HOME)
INSTALL_DESTDIR_MODE ?= 775
INSTALL_FILES_MODE ?= 664
INSTALL_COMMAND_PREFIX ?=

ifeq ($(DESTDIR),)
  DESTPATH := $(HOMEDIR)/.
  INSTALL_DESTDIR := 
else
  DESTPATH := $(HOMEDIR)/$(DESTDIR)/
  INSTALL_DESTDIR ?= yes
endif

normd = $1
norms = $(subst $(DESTPATH),$(CURDIR)/,$1)
DESTFILES := $(patsubst %,$(DESTPATH)%,$(FILES))

.PHONY: $(DESTFILES) $(FILES) banner install_destdir

BANNER := 

ifeq ($(COMMAND),)
 ifeq ($(INSTALL_TYPE),link)
   BANNER := "Using soft link for target $(CURDIR)..."
   COMMAND =  rm -rf $$_d; ln -sf $$_s $$_d
 else
   BANNER := "Using install for target $(CURDIR)..."
   COMMAND = rm -rf $$_d; install --mode=$(INSTALL_FILES_MODE) $$_s $$_d
 endif
else
BANNER := "Using custom $$COMMAND for target $(CURDIR)..."
endif

default: banner install_destdir $(DESTFILES)

$(DESTFILES): $(FILES)
	@_d=$(call normd,$@); \
	_s=$(call norms,$@); \
	echo -n " * $$_s => $$_d: "; \
	if [ -f $$_d -o -h $$_d ] && [ -n "$$(diff -ur $$_d $$_s)" ]; then \
		echo " ==> differ"; \
		diff -ur $$_d $$_s > $${_s}.local-diff; \
		INSTALL=y;\
	else \
		if [ -f $$_d -o -h $$_d ]; then \
			INSTALL=\
			echo " ==> similar"; \
		else \
			INSTALL=y; \
			echo " is not a file or symlink"; \
		fi;\
	fi; \
	if [ -n "$(DO_INSTALL)" ] && [ -n "$$INSTALL" ]; then \
		echo " ==> replacing"; \
		$(COMMAND); \
	fi; \

banner:
	@echo "$(BANNER)"

install_destdir:
	@if [ -n "$(INSTALL_DESTDIR)" ] && [ -n "$(DO_INSTALL)" ] && [ ! -d $(DESTPATH) ]; then \
		echo -n "* installing $(DESTPATH) ... "; \
		$(INSTALL_COMMAND_PREFIX) mkdir -p --mode="$(INSTALL_DESTDIR_MODE)" "$(DESTPATH)"; \
		echo "done"; \
	fi
