#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_print_color_message.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./_constants.sh" || _n2038_return "$?"
. "./_n2038_echo.sh" || _n2038_return "$?"
. "../shell/_n2038_get_current_shell_name.sh" || _n2038_return "$?"
. "../string/n2038_escape_sed.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

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
  _n2038_echo -e "${@}" "${__n2038_text}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
