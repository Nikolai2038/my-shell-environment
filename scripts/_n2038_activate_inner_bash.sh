#!/bin/bash

# NOTE: This file will not be skipped if it was already sourced. This is because we need to source it in "n2038_my_shell_environment" every activation. See "_n2038_required_before_imports" for the skip logic.

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/_n2038_activate_inner_bash.sh"

# Required before imports
# shellcheck disable=SC1091
if [ "${_N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED}" != "1" ]; then
  # If we have not initialized the shell environment, but has it (for example, when starting "dash" from "bash"), then we will try to initialize it.
  if [ -n "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    . "${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"
  else
    echo "\"my-bash-environment\" is not initialized. Please, initialize it first." >&2 && return 1 2> /dev/null || exit 1
  fi
fi
_n2038_required_before_imports || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || _n2038_return "${__n2038_return_code}" || return "$?"; }

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
. "../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "./shell/_n2038_get_timestamp.sh" || _n2038_return "$?" || return "$?"
. "./string/_n2038_tput.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

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
  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating inner bash script..." >&2
  fi

  # If running not interactively, don't do anything
  [[ $- != *i* ]] && return 0

  # Fail command if any of pipeline blocks fail
  set -o pipefail || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Do not exit the shell, when "exec" command fails
  shopt -s execfail || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Append to the history file, don't overwrite it
  shopt -s histappend || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
  shopt -s checkwinsize || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Ignore case when using TAB completion
  # Also, we redirect warning "bind: warning: line editing not enabled" to /dev/null because we always execute ".bashrc" in interactive sessions, but AltLinux thinks differently.
  bind "set completion-ignore-case on" 2> /dev/null || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # ========================================
  # Colors for man pages
  # ========================================
  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating color for man pages..." >&2
  fi

  export LESS_TERMCAP_mb
  LESS_TERMCAP_mb="$(
    _n2038_tput bold
    _n2038_tput setaf 2
  )" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Options names
  export LESS_TERMCAP_md
  LESS_TERMCAP_md="$(
    _n2038_tput bold
    _n2038_tput setaf 2
  )" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  export LESS_TERMCAP_me
  LESS_TERMCAP_me="$(_n2038_tput sgr0)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Footer and search selections
  export LESS_TERMCAP_so
  LESS_TERMCAP_so="$(
    _n2038_tput bold
    _n2038_tput setaf 7
    _n2038_tput setab 4
  )" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  export LESS_TERMCAP_se
  LESS_TERMCAP_se="$(
    _n2038_tput rmso
    _n2038_tput sgr0
  )" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Options values
  export LESS_TERMCAP_us
  LESS_TERMCAP_us="$(
    _n2038_tput smul
    _n2038_tput bold
    _n2038_tput setaf 4
  )" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  export LESS_TERMCAP_ue
  LESS_TERMCAP_ue="$(
    _n2038_tput rmul
    _n2038_tput sgr0
  )" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  export LESS_TERMCAP_mr
  LESS_TERMCAP_mr="$(_n2038_tput rev)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_mh
  LESS_TERMCAP_mh="$(_n2038_tput dim)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZN
  LESS_TERMCAP_ZN="$(_n2038_tput ssubm)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZV
  LESS_TERMCAP_ZV="$(_n2038_tput rsubm)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZO
  LESS_TERMCAP_ZO="$(_n2038_tput ssupm)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  export LESS_TERMCAP_ZW
  LESS_TERMCAP_ZW="$(_n2038_tput rsupm)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # For Konsole and Gnome-terminal
  export GROFF_NO_SGR=1

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating color for man pages: success" >&2
  fi
  # ========================================

  # ========================================
  # Imitate "sudo" command for Windows
  # ========================================
  if [ "${_N2038_CURRENT_OS_TYPE}" = "${_N2038_OS_TYPE_WINDOWS}" ]; then
    # shellcheck disable=SC2317
    sudo() {
      temp_file="$(mktemp --suffix ".sh")" || return "$?"
      echo "temp file: ${temp_file}"

      while [ "$#" -gt 0 ]; do
        arg="$1" && shift
        echo -n "\"${arg}\" " >> "${temp_file}" || return "$?"
      done
      echo "" >> "${temp_file}" || return "$?"
      echo "rm \"${temp_file}\"" >> "${temp_file}" || return "$?"
      echo "sleep 2" >> "${temp_file}" || return "$?"

      echo "========================================"
      cat "${temp_file}" || return "$?"
      echo "========================================"

      powershell.exe -Command "Start-Process -FilePath 'C:\Program Files\Git\git-bash.exe' -Verb RunAs -ArgumentList '-f', '${temp_file}'" || return "$?"

      while [ -f "${temp_file}" ]; do
        sleep 1
      done

      return 0
    }
    # Export function, if we are in Bash. This way, MINGW will be able to see main functions when executing files.
    # shellcheck disable=SC3045
    export -f sudo 2> /dev/null || true
  fi
  # ========================================

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating inner bash script: success!" >&2
  fi

  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
