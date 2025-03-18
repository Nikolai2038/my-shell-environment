#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/n2038_print_colors.sh"

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
. "./_constants.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_echo.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Print colored lines with message colors names.
#
# Usage: _n2038_print_colors
n2038_print_colors() {
  _n2038_echo -e "${c_info}c_info${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_success}c_success${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_highlight}c_highlight${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_warning}c_warning${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_error}c_error${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_text}c_text${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_border_usual}c_border_usual${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_border_root}c_border_root${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  _n2038_echo -e "${c_border}c_border${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  return 0
}

# Required after function
_n2038_required_after_function || _n2038_return "$?" || return "$?"
