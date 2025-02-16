#!/bin/sh

: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/messages/_constants.sh\""
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" && _n2038_required_before_imports; } || { __n2038_return_code="$?" && [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" && _n2038_required_after_imports; } || _n2038_return "$?"

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

: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER - 1))"
