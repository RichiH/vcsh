#!/bin/bash

test_description='External environment variables'

. ./test-lib.sh
. "$TEST_DIRECTORY/environment.bash"

# XXX writeme

# All of the following variables are used in vcsh.  Make sure that having
# cockamamie values for any of the ones that aren't supposed to affect the
# behavior of vcsh... doesn't.
#
# COLORING
# GIT_DIR
# GIT_DIR_NEW
# GIT_REMOTE
# GIT_VERSION
# GIT_VERSION_MAJOR
# GIT_VERSION_MINOR
# IFS
# OLDIFS
# OPTARG
# PATH
# PWD
# SELF
# SHELL
# STATUS
# TMPDIR
# VCSH_BASE
# VCSH_BRANCH
# VCSH_COMMAND
# VCSH_COMMAND_PARAMETER
# VCSH_COMMAND_RETURN_CODE
# VCSH_CONFLICT
# VCSH_DEBUG
# VCSH_GITATTRIBUTES
# VCSH_GITIGNORE
# VCSH_GIT_OPTIONS
# VCSH_HOOK_D
# VCSH_OPTION_CONFIG
# VCSH_OVERLAY_D
# VCSH_REPO_D
# VCSH_REPO_NAME
# VCSH_REPO_NAME_NEW
# VCSH_STATUS_TERSE
# VCSH_VERBOSE
# VCSH_WORKTREE
# VERSION
# XDG_CONFIG_HOME
# answer
# check_directory
# command_prefix
# commits_ahead
# commits_behind
# directory_component
# directory_opt
# exclude_standard_opt
# file
# files
# gitignore
# gitignores
# hook
# line
# new
# object
# output
# overlay
# ran_once
# remote_tracking_branch
# repo
# temp_file_others
# temp_file_untracked
# temp_file_untracked_copy
# tempfile

test_done
