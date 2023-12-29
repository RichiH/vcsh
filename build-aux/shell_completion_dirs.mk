COMPLETIONS_OUT_DIR = completions

if ENABLE_BASH_COMPLETION
bashcompletiondir = $(BASH_COMPLETION_DIR)
nodist_bashcompletion_DATA = $(COMPLETIONS_OUT_DIR)/$(TRANSFORMED_PACKAGE_NAME)
CLEANFILES += $(nodist_bashcompletion_DATA)
endif

# if ENABLE_FISH_COMPLETION
# fishcompletiondir = $(FISH_COMPLETION_DIR)
# nodist_fishcompletion_DATA = $(COMPLETIONS_OUT_DIR)/$(TRANSFORMED_PACKAGE_NAME).fish
# CLEANFILES += $(nodist_fishcompletion_DATA)
# endif

if ENABLE_ZSH_COMPLETION
zshcompletiondir = $(ZSH_COMPLETION_DIR)
nodist_zshcompletion_DATA = $(COMPLETIONS_OUT_DIR)/_$(TRANSFORMED_PACKAGE_NAME)
CLEANFILES += $(nodist_zshcompletion_DATA)
endif

# vim: ft=automake
