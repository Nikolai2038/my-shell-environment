#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_constants.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
# ...

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

# NOTE: We use "tput" here to be able to define colors both for "bash" and "ksh"

# Color for usual text (and in cases when using "_n2038_print_color_message" function is not possible)
export c_text
c_text="$(tput setaf 15)" || n2038_return "$?"

# Color for info text
export c_info
c_info="$(tput setaf 6)" || n2038_return "$?"

# Color for successful text
export c_success
c_success="$(tput setaf 2)" || n2038_return "$?"

# Color for highlighted text
export c_highlight
c_highlight="$(tput setaf 90)" || n2038_return "$?"

# Color for warning text
export c_warning
c_warning="$(tput setaf 3)" || n2038_return "$?"

# Color for error text
export c_error
c_error="$(tput setaf 1)" || n2038_return "$?"

# Color for border used in PS1 function - for usual user
export c_border_usual
c_border_usual="$(tput setaf 27)" || n2038_return "$?"

# Color for border used in PS1 function - for root user
export c_border_root
c_border_root="$(tput setaf 90)" || n2038_return "$?"

# Color for border when printing tables, etc.
export c_border="${c_border_usual}"

# Reset color
export c_reset
c_reset="$(tput sgr0)" || n2038_return "$?"

# Special text that will be replaced with the previous one
export c_return='COLOR_RETURN'

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
