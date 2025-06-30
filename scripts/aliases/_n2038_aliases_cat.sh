#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/aliases/_n2038_aliases_cat.sh"

# Required before imports
if ! type _n2038_required_before_imports > /dev/null 2>&1; then
  # If we have not initialized the shell environment, but has it (for example, when starting "dash" from "bash"), then we will try to initialize it.
  if [ -n "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    # shellcheck disable=SC1091
    _N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED=0 . "${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"
  else
    echo "\"my-bash-environment\" is not initialized. Please, initialize it first." >&2 && return 1 2> /dev/null || exit 1
  fi
fi
_n2038_required_before_imports || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || _n2038_return "${__n2038_return_code}" || return "$?"; }

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
. "../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
# ...

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

unalias cat > /dev/null 2>&1 || true
# Alias for "cat".
# - "bat" is colorized "cat", so we use it, if it is installed.
#
# Usage: cat [arg...]
# Where:
# - "arg": Extra argument to the "cat"/"bat" command.
cat() {
  # Binary can be called "batcat"
  if { { ! which bat; } && which batcat; } > /dev/null 2>&1; then
    batcat --style='plain' --paging=never --theme='Visual Studio Dark+' "$@" || return "$?"
    return 0
  fi

  # If "bat" is installed, use it
  if which bat > /dev/null 2>&1; then
    bat --style='plain' --paging=never --theme='Visual Studio Dark+' "$@" || return "$?"
    return 0
  fi

  # If "bat" is not installed, just use "cat"
  cat "$@" || return "$?"

  return 0
}

unalias c > /dev/null 2>&1 || true
# Alias for "cat".
#
# Usage: c [arg...]
# Where:
# - "arg": Extra argument to the "cat"/"bat" command.
c() {
  cat "$@" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
