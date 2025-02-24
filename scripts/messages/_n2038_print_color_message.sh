#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_print_color_message.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../shell/_n2038_is_shell_bash_compatible.sh" || _n2038_return "$?"
. "../string/n2038_escape_sed.sh" || _n2038_return "$?"
. "./_constants.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Print a colored text.
#
# Usage: _n2038_print_color_message [color] [text]
_n2038_print_color_message() {
  [ "$#" -gt 0 ] && { __n2038_main_color="${1}" && shift || return "$?"; } || __n2038_main_color=""
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || return "$?"; } || __n2038_text=""

  # Replaces the special string with the __n2038_text color
  # (don't forget to escape the first color character with an additional backslash)
  if [ -n "${__n2038_main_color}" ]; then
    __n2038_text="$(echo "${__n2038_text}" | sed -E "s/${c_return}/\\${__n2038_main_color}/g")" || return "$?"
  else
    __n2038_text="$(echo "${__n2038_text}" | sed -E "s/${c_return}//g")" || return "$?"
  fi
  __n2038_text="${__n2038_main_color}${__n2038_text}${c_reset}"

  if _n2038_is_shell_bash_compatible; then
    # Prepare colors in text.
    # Braces "\[" and "\]" are required, so "bash" can understand, that this is colors and not output.
    # If we do not use them, the shell will break when we try to navigate in commands' history.
    # "sh" does not have commands' history, and braces will result in just text, so we don't use them here
    for color in "${c_text}" "${c_info}" "${c_success}" "${c_highlight}" "${c_warning}" "${c_error}" "${c_border_usual}" "${c_border_root}" "${c_border}"; do
      __n2038_text="$(echo "${__n2038_text}" | sed -E "s/$(n2038_escape_sed -E "${color}")/$(n2038_escape_sed -E "\\[${color}\\]")/g")" || return "$?"
    done

    # shellcheck disable=SC2320,SC3037
    echo -e "${@}" "${__n2038_text}" || return "$?"
  else
    # "sh" does not have "-e"
    # shellcheck disable=SC2320
    echo "${@}" "${__n2038_text}" || return "$?"
  fi

  unset __n2038_main_color __n2038_text
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_function.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
