#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/messages/_n2038_replace_colors_with_exact_values.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./_constants.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_echo.sh" || _n2038_return "$?" || return "$?"
. "../shell/_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"
. "../string/_n2038_escape_sed.sh" || _n2038_return "$?" || return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

# Replace colors in the specified text with their exact values.
#
# Usage: _n2038_replace_colors_with_exact_values [text]
_n2038_replace_colors_with_exact_values() {
  [ "$#" -gt 0 ] && { __n2038_text="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_text=""

  __n2038_prefix=""
  __n2038_suffix=""

  # Braces "\[" and "\]" are required, so "bash" can understand, that this is colors and not output.
  # If we do not use them, the shell will break when we try to navigate in commands' history.
  # "sh" does not have commands' history, and braces will result in just text, so we don't use them here
  if [ "$(_n2038_get_current_shell_name)" = "${_N2038_CURRENT_SHELL_NAME_BASH}" ]; then
    __n2038_prefix="\["
    __n2038_suffix="\]"
  fi

  # shellcheck disable=SC2016
  _n2038_echo -en "${__n2038_text}" \
    | sed "s/$(_n2038_escape_sed '${c_info}')/$(_n2038_escape_sed "${__n2038_prefix}${c_info}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_success}')/$(_n2038_escape_sed "${__n2038_prefix}${c_success}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_highlight}')/$(_n2038_escape_sed "${__n2038_prefix}${c_highlight}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_warning}')/$(_n2038_escape_sed "${__n2038_prefix}${c_warning}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_error}')/$(_n2038_escape_sed "${__n2038_prefix}${c_error}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_text}')/$(_n2038_escape_sed "${__n2038_prefix}${c_text}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_border_usual}')/$(_n2038_escape_sed "${__n2038_prefix}${c_border_usual}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_border_root}')/$(_n2038_escape_sed "${__n2038_prefix}${c_border_root}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_border}')/$(_n2038_escape_sed "${__n2038_prefix}${c_border}${__n2038_suffix}")/g" \
    | sed "s/$(_n2038_escape_sed '${c_reset}')/$(_n2038_escape_sed "${__n2038_prefix}${c_reset}${__n2038_suffix}")/g" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
