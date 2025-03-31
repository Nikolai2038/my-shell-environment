#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_print_color_message.sh"

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
. "../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "./_constants.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_echo.sh" || _n2038_return "$?" || return "$?"
. "../shell/_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"
. "../string/_n2038_escape_sed.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Print a colored text.
#
# Usage: _n2038_print_color_message [color] [text]
_n2038_print_color_message() {
  [ "$#" -gt 0 ] && { __n2038_main_color="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_main_color=""
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_text=""

  # Replaces the special string with the __n2038_text color
  # (don't forget to escape the first color character with an additional backslash)
  if [ -n "${__n2038_main_color}" ]; then
    __n2038_text="$(echo "${__n2038_text}" | sed -E "s/${c_return}/\\${__n2038_main_color}/g")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    __n2038_text="$(echo "${__n2038_text}" | sed -E "s/${c_return}//g")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi
  __n2038_text="${__n2038_main_color}${__n2038_text}${c_reset}"

  # shellcheck disable=SC2320,SC3037
  _n2038_echo -e "$@" "${__n2038_text}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  unset __n2038_main_color __n2038_text
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
