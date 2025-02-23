#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_constants.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Color for usual text (and in cases when using "_n2038_print_color_message" function is not possible)
export c_text="\033[38;5;15m"

# Color for info text
export c_info="\033[38;5;06m"

# Color for successful text
export c_success="\033[38;5;02m"

# Color for highlighted text
export c_highlight="\033[38;5;90m"

# Color for warning text
export c_warning="\033[38;5;03m"

# Color for error text
export c_error="\033[38;5;01m"

# Color for border used in PS1 function - for usual user
export c_border_usual="\033[38;5;27m"

# Color for border used in PS1 function - for root user
export c_border_root="\033[38;5;90m"

# Color for border when printing tables, etc.
export c_border="${c_border_usual}"

# Reset color
export c_reset='\e[0m'

# Special text that will be replaced with the previous one
export c_return='COLOR_RETURN'

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_function.sh
. "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
