BIN_DIR := $(HOME)/.local/bin
MAN_DIR := $(HOME)/.local/man
CMP_DIR := $(HOME)/.local/share/bash-completion/completions

.PHONEY: install uninstall

install:
	mkdir -p $(CMP_DIR)
	mkdir -p $(BIN_DIR)
	mkdir -p $(MAN_DIR)/man1
	ln --symbolic -T $(PWD)/recycle.sh $(BIN_DIR)/recycle
	ln --symbolic -T $(PWD)/recycle.1 $(MAN_DIR)/man1/recycle.1
	ln --symbolic -T $(PWD)/recycle $(CMP_DIR)/recycle

uninstall:
	rm $(BIN_DIR)/recycle $(MAN_DIR)/man1/recycle.1 $(CMP_DIR)/recycle
