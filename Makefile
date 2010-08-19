BASEDIR := $(CURDIR)

MAKEFLAGS := --no-print-directory

COMPONENTS-desktop	?= awesome xsession git ssh
COMPONENTS-laptop	?= awesome xsession git ssh
COMPONENTS-public	?= awesome
COMPONENTS-all		?= awesome xsession git ssh irssi



default: print-all
	@echo "run make check-group to check differences between installed and current configs"
	@echo "run make install-group to install symlinks"

print-group-%:
	@echo $*: $(COMPONENTS-$*)

print-all: print-group-desktop print-group-laptop print-group-public print-group-all

icheck-component-%:
	$(MAKE) check -C $* BASEDIR=$(BASEDIR)

check-%:
	@for c in $(COMPONENTS-$*); do \
		$(MAKE) icheck-component-$$c;\
	done

iinstall-component-%:
	$(MAKE) check -C $* BASEDIR=$(BASEDIR) DO_INSTALL=1; \

install-%:
	@for c in $(COMPONENTS-$*); do \
		$(MAKE) iinstall-component-$$c; \
	done
