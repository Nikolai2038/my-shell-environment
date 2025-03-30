#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_ps2_function.sh"

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
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_echo.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Print PS2 prompt.
#
# Usage: _n2038_ps2_function
_n2038_ps2_function() {
  __n2038_current_shell_name="$(_n2038_get_current_shell_name)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # - We don't use "\"-variables ("\w", "\u", "\h", etc.) here because they do not exist in "sh".
  # - Colors must be defined before PS1 and not inside it, otherwise the braces will be printed directly.
  #   Because of that, we can't call "_n2038_print_color_message" here.
  #   But we can specify colors here and replace them all colors with their values later.
  _n2038_echo -e "${c_border}├─[${c_success}${__n2038_current_shell_name}${c_return}]─> ${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
