#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/_n2038_activate_inner.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./messages/_n2038_replace_colors_with_exact_values.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_get_current_os_name.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_get_current_shell_depth.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_ps1_function.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_ps2_function.sh" || _n2038_return "$?" || return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

# Function which executes all necessary steps to activate the shell environment.
#
# Usage: _n2038_activate_inner
_n2038_activate_inner() {
  # To initialize the "_N2038_CURRENT_OS_NAME" variable - to not recalculate it every time
  _n2038_get_current_os_name > /dev/null || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Initialize the "_N2038_INIT_SHELL_DEPTH" variable
  if [ -z "${_N2038_INIT_SHELL_DEPTH}" ]; then
    export _N2038_INIT_SHELL_DEPTH
    _N2038_INIT_SHELL_DEPTH="$(_n2038_get_current_shell_depth)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Termux has different call stack
    if [ "$(_n2038_get_current_os_name)" = "${_N2038_OS_NAME_TERMUX}" ] && [ -n "${_N2038_INIT_SHELL_DEPTH}" ] && [ "${_N2038_INIT_SHELL_DEPTH}" != "${_N2038_SHELL_DEPTH_UNKNOWN}" ]; then
      _N2038_INIT_SHELL_DEPTH="$((_N2038_INIT_SHELL_DEPTH - 1))"
    fi

    export _N2038_INIT_SHELL_PROCESS_ID="${$}"
  fi

  # ========================================
  # Set command prompt.
  # - We must use function here to be able to get current shell via "$0" - this will not work if file is being executed.
  # - Also, when we are entering "sh" from "bash" (even if "sh" is a symbolic link to "bash"), "sh" won't know about functions.
  #   In this case, we execute files directly.
  #   This logic probably can be improved, but it works for now.
  # - Colors must be defined before PS1 and not inside it, otherwise the braces will be printed directly.
  #   Because of that, we can't call "_n2038_print_color_message" here.
  #   But we can specify colors here and replace them all colors with their values later.
  # - Be aware of VS Code: it will ALWAYS insert "\[\]" around "PS1" and "PS2" variables, which will be printed, if we switch shell in the integrated terminal.
  #   Currently I could not find a solution to that problem - so just use external terminal for stability.
  # ========================================

  # Cut all before and after function body
  __n2038_new_ps1_function_file_content_only_body="$(sed -n '/_n2038_ps1_function() {/,/^}/p' "${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps1_function.sh")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  __n2038_new_ps1_function_file_content_only_body="$(_n2038_replace_colors_with_exact_values "${__n2038_new_ps1_function_file_content_only_body}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  # Use "_N2038" here instead of "__N2038" to not unset variable when calling "_n2038_unset".
  # shellcheck disable=SC2154
  export PS1="\$(
    _N2038_RETURN_CODE_PS1=\"\$?\"
    ${__n2038_new_ps1_function_file_content_only_body}
    _n2038_ps1_function \"\${_N2038_RETURN_CODE_PS1}\" 2> /dev/null || {
      . \"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps1_function.sh\" || exit \"\$?\"
      _n2038_ps1_function \"\${_N2038_RETURN_CODE_PS1}\" || exit \"\$?\"
    }
    unset _N2038_RETURN_CODE_PS1
  )"

  # Cut all before and after function body
  __n2038_new_ps2_function_file_content_only_body="$(sed -n '/_n2038_ps2_function() {/,/^}/p' "${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps2_function.sh")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  __n2038_new_ps2_function_file_content_only_body="$(_n2038_replace_colors_with_exact_values "${__n2038_new_ps2_function_file_content_only_body}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  export PS2="\$(
    ${__n2038_new_ps2_function_file_content_only_body}
    _n2038_ps2_function 2> /dev/null || {
      . \"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps2_function.sh\" || exit \"\$?\"
      _n2038_ps2_function || exit \"\$?\"
    }
  )"

  # ========================================

  # Make scripts available in shell by their names
  export PATH="${_N2038_SHELL_ENVIRONMENT_PATH}:${PATH}"

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
