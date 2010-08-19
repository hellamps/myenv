HOMEDIR := $(HOME)

ifeq ($(DESTDIR),)
DESTPATH := $(HOMEDIR)/.
else
DESTPATH := $(HOMEDIR)/$(DESTDIR)/
endif

normd = $1
norms = $(subst $(DESTPATH),$(CURDIR)/,$1)
DESTFILES := $(patsubst %,$(DESTPATH)%,$(FILES))

$(DESTFILES): $(FILES)
	@_d=$(call normd,$@); \
	_s=$(call norms,$@); \
	echo -n " * $$_s => $$_d: "; \
	if [ ! -L $$_d ]; then \
		echo "file"; \
		if [ ! -f $$_d -o -n "$$(diff -ur $$_d $$_s)" ]; then \
			echo " ==> differ"; \
			diff -ur $$_d $$_s > $${_s}.local-diff; \
		fi; \
		if [ -n "$(DO_INSTALL)" ]; then \
			echo " ==> replacing"; \
			rm -rf $$_d; ln -sf $$_s $$_d; \
		fi; \
	else \
		echo "symlink"; \
	fi

check: $(DESTFILES)
	@echo "Checking commenced. Run git status to see if there are"
	@echo "any .local-diff files."


