#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_ps1_function.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../messages/_constants.sh" || _n2038_return "$?"
. "../messages/_n2038_echo.sh" || _n2038_return "$?"
. "./_n2038_get_current_shell.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

_n2038_ps1_function() {
  [ "$#" -gt 0 ] && { __n2038_return_code="${1}" && shift || return "$?"; }

  __n2038_return_code_formatted="$(printf '%03d' "${__n2038_return_code#0}")" || return "$?"

  __n2038_date="$(date +'%Y-%m-%d]─[%a]─[%H:%M:%S')" || return "$?"

  # There is warning about "$HOSTNAME" being undefined in POSIX "sh", so just in case, we use "hostname" command to get it, if it is installed.
  # Also, "hostname" command is used in WSL (to get Windows hostname), where is no "$HOSTNAME".
  __n2038_hostname="$(hostname)" || return "$?"

  __n2038_user="$(whoami)" || return "$?"

  __n2038_current_shell="$(_n2038_get_current_shell)" || return "$?"

  __n2038_color_for_error_code="${c_success}"
  if [ "${__n2038_return_code}" != "0" ]; then
    __n2038_color_for_error_code="${c_error}"
  fi

  # - We don't use "\"-variables ("\w", "\u", "\h", etc.) here because they do not exist in "sh".
  # - Colors must be defined before PS1 and not inside it, otherwise the braces will be printed directly.
  #   Because of that, we can't call "_n2038_print_color_message" here.
  #   But we can specify colors here and replace them all colors with their values later.
  # - We specify colors in the beginning of each line, because bash may have override it with text color, when navigating in commands' history.
  _n2038_echo -en "${c_border}└─[${__n2038_color_for_error_code}${__n2038_return_code_formatted}${c_border}]─[${__n2038_date}]${c_reset}

${c_border}┌─[${__n2038_user}@${__n2038_hostname}:${c_success}${PWD}${c_border}]${c_reset}
${c_border}├─[${c_success}${__n2038_current_shell}${c_border}]─\$ ${c_reset}" || return "$?"

  unset __n2038_return_code __n2038_return_code_formatted __n2038_date __n2038_hostname __n2038_user __n2038_current_shell __n2038_color_for_error_code
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_function.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
