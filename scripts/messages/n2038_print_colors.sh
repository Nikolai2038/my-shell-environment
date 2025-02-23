#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/n2038_print_colors.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./_constants.sh" || _n2038_return "$?"
. "./_n2038_echo.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

n2038_print_colors() {
  _n2038_echo -e "${c_info}c_info${c_reset}" || return "$?"
  _n2038_echo -e "${c_success}c_success${c_reset}" || return "$?"
  _n2038_echo -e "${c_highlight}c_highlight${c_reset}" || return "$?"
  _n2038_echo -e "${c_warning}c_warning${c_reset}" || return "$?"
  _n2038_echo -e "${c_error}c_error${c_reset}" || return "$?"
  _n2038_echo -e "${c_text}c_text${c_reset}" || return "$?"
  _n2038_echo -e "${c_border_usual}c_border_usual${c_reset}" || return "$?"
  _n2038_echo -e "${c_border_root}c_border_root${c_reset}" || return "$?"
  _n2038_echo -e "${c_border}c_border${c_reset}" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_function.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
