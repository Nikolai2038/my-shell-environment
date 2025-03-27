#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_constants.sh"

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

# Imports
. "../string/_n2038_tput.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# NOTE: We define empty values for Bash IDE server to find references to these variables.

# Color for usual text (and in cases when using "_n2038_print_color_message" function is not possible)
export c_text=""

# Color for info text
export c_info=""

# Color for successful text
export c_success=""

# Color for highlighted text
export c_highlight=""

# Color for warning text
export c_warning=""

# Color for error text
export c_error=""

# Color for border used in PS1 function - for usual user
export c_border_usual=""

# Color for border used in PS1 function - for root user
export c_border_root=""

# Reset color
export c_reset=""

# NOTE: We use "_n2038_tput" here to be able to define colors both for "bash" and "ksh"
# NOTE: MINGW and TTYs recognize only 8 colors, so we don't use any colors higher than 7.
c_text="$(_n2038_tput setaf 7)" || _n2038_return "$?"
c_info="$(_n2038_tput setaf 6)" || _n2038_return "$?"
c_success="$(_n2038_tput setaf 2)" || _n2038_return "$?"
c_highlight="$(_n2038_tput setaf 5)" || _n2038_return "$?"
c_warning="$(_n2038_tput setaf 3)" || _n2038_return "$?"
c_error="$(_n2038_tput setaf 1)" || _n2038_return "$?"
c_border_usual="$(_n2038_tput setaf 4)" || _n2038_return "$?"
c_border_root="$(_n2038_tput setaf 5)" || _n2038_return "$?"
c_reset="$(_n2038_tput sgr0)" || _n2038_return "$?"

# Color for border when printing tables, etc.
export c_border="${c_border_usual}"

# Special text that will be replaced with the previous one
export c_return='COLOR_RETURN'

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
