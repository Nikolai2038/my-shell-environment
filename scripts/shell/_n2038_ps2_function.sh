#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_ps2_function.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$({ basename "$0" || true; } 2> /dev/null)" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../messages/_constants.sh" || _n2038_return "$?"
. "../messages/_n2038_echo.sh" || _n2038_return "$?"
. "./_n2038_get_current_shell_name.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Print PS2 prompt.
#
# Usage: _n2038_ps2_function
_n2038_ps2_function() {
  __n2038_current_shell_name="$(_n2038_get_current_shell_name)" || return "$?"

  # - We don't use "\"-variables ("\w", "\u", "\h", etc.) here because they do not exist in "sh".
  # - Colors must be defined before PS1 and not inside it, otherwise the braces will be printed directly.
  #   Because of that, we can't call "_n2038_print_color_message" here.
  #   But we can specify colors here and replace them all colors with their values later.
  _n2038_echo -e "${c_border}├─[${c_success}${__n2038_current_shell_name}${c_return}]─> ${c_reset}" || return "$?"

  unset __n2038_current_shell_name
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
