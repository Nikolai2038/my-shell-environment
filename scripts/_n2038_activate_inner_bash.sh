#!/bin/bash

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/_n2038_activate_inner_bash.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./shell/_n2038_get_timestamp.sh" || _n2038_return "$?" || return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

# ========================================
# NOTE: Bash constants must be defined outside function - if we define them in functions, they won't be changed outside of them.
# ========================================

# Before command
trap 'if [ "${_N2038_IS_COMMAND_EXECUTING}" = "0" ]; then _N2038_IS_COMMAND_EXECUTING=1; _N2038_LAST_TIME="$(_n2038_get_timestamp)"; fi' DEBUG

# After command
export PROMPT_COMMAND='_N2038_IS_COMMAND_EXECUTING=0'

export HISTSIZE=10000
export HISTFILESIZE=100000

# Don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL="ignoreboth"

# ========================================

_n2038_activate_inner_bash() {
  # If running not interactively, don't do anything
  [[ $- != *i* ]] && return 0

  # Fail command if any of pipeline blocks fail
  set -o pipefail || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # Do not exit the shell, when "exec" command fails
  shopt -s execfail || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # Append to the history file, don't overwrite it
  shopt -s histappend || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
  shopt -s checkwinsize || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # Ignore case when using TAB completion
  # Also, we redirect warning "bind: warning: line editing not enabled" to /dev/null because we always execute ".bashrc" in interactive sessions, but AltLinux thinks differently.
  bind "set completion-ignore-case on" 2> /dev/null || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # ========================================
  # Colors for man pages
  # ========================================
  export LESS_TERMCAP_mb
  LESS_TERMCAP_mb="$(
    tput bold
    tput setaf 2
  )" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # Options names
  export LESS_TERMCAP_md
  LESS_TERMCAP_md="$(
    tput bold
    tput setaf 2
  )" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  export LESS_TERMCAP_me
  LESS_TERMCAP_me="$(tput sgr0)" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # Footer and search selections
  export LESS_TERMCAP_so
  LESS_TERMCAP_so="$(
    tput bold
    tput setaf 7
    tput setab 4
  )" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  export LESS_TERMCAP_se
  LESS_TERMCAP_se="$(
    tput rmso
    tput sgr0
  )" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # Options values
  export LESS_TERMCAP_us
  LESS_TERMCAP_us="$(
    tput smul
    tput bold
    tput setaf 4
  )" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  export LESS_TERMCAP_ue
  LESS_TERMCAP_ue="$(
    tput rmul
    tput sgr0
  )" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_mr
  LESS_TERMCAP_mr="$(tput rev)" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_mh
  LESS_TERMCAP_mh="$(tput dim)" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZN
  LESS_TERMCAP_ZN="$(tput ssubm)" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZV
  LESS_TERMCAP_ZV="$(tput rsubm)" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZO
  LESS_TERMCAP_ZO="$(tput ssupm)" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZW
  LESS_TERMCAP_ZW="$(tput rsupm)" || { _n2038_unset_init "$?" && return "$?" || return "$?"; }

  # For Konsole and Gnome-terminal
  export GROFF_NO_SGR=1
  # ========================================

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
