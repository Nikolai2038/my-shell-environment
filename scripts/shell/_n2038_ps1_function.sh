#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_ps1_function.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../messages/_constants.sh" || _n2038_return "$?"
. "../messages/_n2038_echo.sh" || _n2038_return "$?"
. "./_n2038_get_current_shell_name.sh" || _n2038_return "$?"
. "./_n2038_get_current_os_name.sh" || _n2038_return "$?"
. "./_n2038_get_current_shell_depth.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Print PS1 prompt.
#
# Usage: _n2038_ps1_function [return_code]
_n2038_ps1_function() {
  [ "$#" -gt 0 ] && { __n2038_return_code="${1}" && shift || return "$?"; } || __n2038_return_code=""

  __n2038_color_for_error_code="${c_success}"
  if [ "${__n2038_return_code}" != "0" ]; then
    __n2038_color_for_error_code="${c_error}"
  fi
  unset __n2038_return_code

  __n2038_return_code_formatted="$(printf '%03d' "${__n2038_return_code#0}")" || return "$?"

  __n2038_date="$(date +'%Y-%m-%d]─[%a]─[%H:%M:%S')" || return "$?"

  __n2038_user="$(whoami)" || return "$?"

  # There is warning about "$HOSTNAME" being undefined in POSIX "sh", so just in case, we use "hostname" command to get it, if it is installed.
  # Also, "hostname" command is used in WSL (to get Windows hostname), where is no "$HOSTNAME".
  __n2038_hostname="$(hostname)" || return "$?"

  __n2038_current_os_name="$(_n2038_get_current_os_name)" || return "$?"
  if [ "${__n2038_current_os_name}" = "${_N2038_OS_NAME_UNKNOWN}" ]; then
    __n2038_current_os_name="${c_error}${__n2038_current_os_name}${c_border}"
  fi

  __n2038_was_error_calculating_current_shell_depth=0
  __n2038_get_current_shell_depth="$(_n2038_get_current_shell_depth)" || return "$?"
  if [ "${__n2038_get_current_shell_depth}" = "${_N2038_SHELL_DEPTH_UNKNOWN}" ]; then
    __n2038_was_error_calculating_current_shell_depth=1
  else
    if [ -z "${_N2038_INIT_SHELL_DEPTH}" ]; then
      echo "Variable \"_N2038_INIT_SHELL_DEPTH\" is not defined!" >&2
      __n2038_was_error_calculating_current_shell_depth=1
    elif [ "${_N2038_INIT_SHELL_DEPTH}" = "${_N2038_SHELL_DEPTH_UNKNOWN}" ]; then
      echo "\"_N2038_INIT_SHELL_DEPTH\" is unknown!" >&2
      __n2038_was_error_calculating_current_shell_depth=1
    else
      __n2038_get_current_shell_depth="$((__n2038_get_current_shell_depth - _N2038_INIT_SHELL_DEPTH - 1))" || return "$?"
    fi
  fi

  if [ "${__n2038_was_error_calculating_current_shell_depth}" = "1" ]; then
    __n2038_get_current_shell_depth="${c_error}${__n2038_get_current_shell_depth}${c_border}"
  fi

  __n2038_current_shell_name="$(_n2038_get_current_shell_name)" || return "$?"
  if [ "${__n2038_current_shell_name}" = "${_N2038_SHELL_NAME_UNKNOWN}" ]; then
    __n2038_current_shell_name="${c_error}${__n2038_current_shell_name}${c_border}"
  fi

  # - We don't use "\"-variables ("\w", "\u", "\h", etc.) here because they do not exist in "sh".
  # - Colors must be defined before PS1 and not inside it, otherwise the braces will be printed directly.
  #   Because of that, we can't call "_n2038_print_color_message" here.
  #   But we can specify colors here and replace them all colors with their values later.
  # - We specify colors in the beginning of each line, because bash may have override it with text color, when navigating in commands' history.
  _n2038_echo -en "${c_border}└─[${__n2038_color_for_error_code}${__n2038_return_code_formatted}${c_border}]─[${__n2038_date}]

${c_border}┌─[${__n2038_user}@${__n2038_hostname}:${c_success}${PWD}${c_border}]
${c_border}├─[${__n2038_current_os_name}]─[${__n2038_get_current_shell_depth}]─[${c_success}${__n2038_current_shell_name}${c_border}]─\$ ${c_reset}" || return "$?"

  unset __n2038_color_for_error_code __n2038_return_code_formatted __n2038_date __n2038_user __n2038_hostname __n2038_current_os_name __n2038_get_current_shell_depth __n2038_current_shell_name
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
