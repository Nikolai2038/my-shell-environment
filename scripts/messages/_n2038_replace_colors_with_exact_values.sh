#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_replace_colors_with_exact_values.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && { _n2038_return "0" && return 0; } || [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../shell/_n2038_is_shell_bash_compatible.sh" || _n2038_return "$?"
. "../string/n2038_escape_sed.sh" || _n2038_return "$?"
. "./_constants.sh" || _n2038_return "$?"
. "./_n2038_echo.sh" || _n2038_return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?"

# Replace colors in the specified text with their exact values.
#
# Usage: _n2038_replace_colors_with_exact_values [text]
_n2038_replace_colors_with_exact_values() {
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || return "$?"; } || __n2038_text=""

  __n2038_prefix=""
  __n2038_suffix=""

  # Braces "\[" and "\]" are required, so "bash" can understand, that this is colors and not output.
  # If we do not use them, the shell will break when we try to navigate in commands' history.
  # "sh" does not have commands' history, and braces will result in just text, so we don't use them here
  if _n2038_is_shell_bash_compatible; then
    __n2038_prefix="\["
    __n2038_suffix="\]"
  fi

  # shellcheck disable=SC2016
  _n2038_echo -en "${__n2038_text}" \
    | sed "s/$(n2038_escape_sed '${c_info}')/$(n2038_escape_sed "${__n2038_prefix}${c_info}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_success}')/$(n2038_escape_sed "${__n2038_prefix}${c_success}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_highlight}')/$(n2038_escape_sed "${__n2038_prefix}${c_highlight}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_warning}')/$(n2038_escape_sed "${__n2038_prefix}${c_warning}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_error}')/$(n2038_escape_sed "${__n2038_prefix}${c_error}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_text}')/$(n2038_escape_sed "${__n2038_prefix}${c_text}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_border_usual}')/$(n2038_escape_sed "${__n2038_prefix}${c_border_usual}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_border_root}')/$(n2038_escape_sed "${__n2038_prefix}${c_border_root}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_border}')/$(n2038_escape_sed "${__n2038_prefix}${c_border}${__n2038_suffix}")/g" \
    | sed "s/$(n2038_escape_sed '${c_reset}')/$(n2038_escape_sed "${__n2038_prefix}${c_reset}${__n2038_suffix}")/g" || return "$?"

  unset __n2038_text __n2038_prefix __n2038_suffix
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?"
