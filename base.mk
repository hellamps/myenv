MAKEFLAGS := --no-print-directory
BASEDIR := $(CURDIR)
include .makeinc/gmsl/gmsl

targets := $(subst TARGET_,,$(filter TARGET_%,$(.VARIABLES)))

TARGET_all := $(call uniq,$(foreach target,$(targets),$(TARGET_$(value target)) ))

default: print-all
	@echo "Usage:"
	@echo "\trun make check-<target> to check differences between installed and current configs"
	@echo "\trun make install-<target> to install components"

print-target-%:
	@echo "\t$*: $(TARGET_$*)"

print-all:
	@echo "Defined targets are:"
	@for c in $(targets); do \
		$(MAKE) print-target-$$c;\
	done

icheck-component-%:
	@$(MAKE) -C $* BASEDIR=$(BASEDIR)

check-%:
	@for c in $(TARGET_$*); do \
		$(MAKE) icheck-component-$$c;\
	done
	@echo "Checking commenced. Run git status to see if there are"
	@echo "any .local-diff files."

iinstall-component-%:
	@$(MAKE) -C $* BASEDIR=$(BASEDIR) DO_INSTALL=1; \

install-%:
	@for c in $(TARGET_$*); do \
		$(MAKE) iinstall-component-$$c; \
	done

