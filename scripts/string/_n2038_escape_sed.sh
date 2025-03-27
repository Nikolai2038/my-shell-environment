#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/string/_n2038_escape_sed.sh"

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

# Imports
# ...

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Escapes the specified text for use in the sed command.
# If you will pass the result of this command to "sed" or "grep" - please, add "-E" if you will also add it to them.
# This is because, the escaping depends on condition if extended regular expressions will be used.
#
# Usage: _n2038_escape_sed [-E] [text]
_n2038_escape_sed() {
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_text=""
  [ "$#" -gt 0 ] && { __n2038_arg="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_arg=""

  # "-E" can be as first argument or as second, so we switch them, if necessary
  if [ "${__n2038_text}" = "-E" ]; then
    __n2038_text="${__n2038_arg}"
    __n2038_arg="-E"
  fi

  if [ "${__n2038_arg}" = "-E" ]; then
    # For "sed -E"
    echo "${__n2038_text}" | sed -e 's/[]\/#$&*.^;|{}()[]/\\&/g' || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    # For "sed"
    echo "${__n2038_text}" | sed -e 's/[]\/#$&*.^;[]/\\&/g' || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
