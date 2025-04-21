#!/bin/sh

# NOTE: This file will not be skipped if it was already sourced. This is because we need to source it in "n2038_my_shell_environment" every activation. See "_n2038_required_before_imports" for the skip logic.

# If you ever update this variable here, don't forget to update it in the "_n2038_required_before_imports" as well.
__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/_n2038_activate_inner.sh"

# Required before imports
if ! type _n2038_required_before_imports > /dev/null 2>&1; then
  # If we have not initialized the shell environment, but has it (for example, when starting "dash" from "bash"), then we will try to initialize it.
  if [ -n "${_N2038_SHELL_ENVIRONMENT_PATH}" ]; then
    # shellcheck disable=SC1091
    _N2038_IS_MY_SHELL_ENVIRONMENT_INITIALIZED=0 . "${_N2038_SHELL_ENVIRONMENT_PATH}/n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"
  else
    echo "\"my-bash-environment\" is not initialized. Please, initialize it first." >&2 && return 1 2> /dev/null || exit 1
  fi
fi
_n2038_required_before_imports || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || _n2038_return "${__n2038_return_code}" || return "$?"; }

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
. "../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "./messages/_n2038_replace_colors_with_exact_values.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_get_current_shell_depth.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_ps1_function.sh" || _n2038_return "$?" || return "$?"
. "./shell/_n2038_ps2_function.sh" || _n2038_return "$?" || return "$?"

# Aliases
. "./aliases/_n2038_aliases_docker_compose.sh" || _n2038_return "$?" || return "$?"
. "./aliases/_n2038_aliases_docker.sh" || _n2038_return "$?" || return "$?"
. "./aliases/_n2038_aliases_git.sh" || _n2038_return "$?" || return "$?"
. "./aliases/_n2038_aliases_ls.sh" || _n2038_return "$?" || return "$?"
. "./aliases/_n2038_aliases_packages_automatically.sh" || _n2038_return "$?" || return "$?"
. "./aliases/_n2038_aliases_packages_by_hand.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Function which executes all necessary steps to activate the shell environment.
#
# Usage: _n2038_activate_inner
_n2038_activate_inner() {
  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating inner script..." >&2
  fi

  # Initialize the "_N2038_INIT_SHELL_DEPTH" variable
  if [ -z "${_N2038_INIT_SHELL_DEPTH}" ]; then
    export _N2038_INIT_SHELL_DEPTH
    _N2038_INIT_SHELL_DEPTH="$(_n2038_get_current_shell_depth)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Termux has different call stack
    if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_TERMUX}" ] && [ -n "${_N2038_INIT_SHELL_DEPTH}" ] && [ "${_N2038_INIT_SHELL_DEPTH}" != "${_N2038_SHELL_DEPTH_UNKNOWN}" ]; then
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
  # shellcheck disable=SC2089
  # shellcheck disable=SC2090
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
  # shellcheck disable=SC2089
  # shellcheck disable=SC2090
  export PS2="\$(
    ${__n2038_new_ps2_function_file_content_only_body}
    _n2038_ps2_function 2> /dev/null || {
      . \"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps2_function.sh\" || exit \"\$?\"
      _n2038_ps2_function || exit \"\$?\"
    }
  )"

  # ========================================

  # Create directory for programs.
  # This must be done after installing, because installing depends on empty "my-shell-environment" directory.
  mkdir --parents "${_N2038_SHELL_ENVIRONMENT_PROGRAMS}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  if [ -n "${_N2038_SHELL_ENVIRONMENT_PROGRAMS} " ] && ! echo "${PATH}" | grep --quiet "${_N2038_SHELL_ENVIRONMENT_SYMLINKS}"; then
    # Make scripts available in shell by their names
    export PATH="${_N2038_SHELL_ENVIRONMENT_PROGRAMS}:${PATH}"
  fi

  if [ -n "${_N2038_SHELL_ENVIRONMENT_SYMLINKS} " ] && ! echo "${PATH}" | grep --quiet "${_N2038_SHELL_ENVIRONMENT_SYMLINKS}"; then
    # Make scripts available in shell by their names
    export PATH="${_N2038_SHELL_ENVIRONMENT_SYMLINKS}:${PATH}"
  fi

  # "EDITOR" must be set for "Git Graph" extension in VS Code - otherwise it will show error when creating tag
  if which nvim > /dev/null 2>&1; then
    export EDITOR="nvim"
  elif which vim > /dev/null 2>&1; then
    export EDITOR="vim"
  elif which nano > /dev/null 2>&1; then
    export EDITOR="nano"
  elif which vi > /dev/null 2>&1; then
    export EDITOR="vi"
  elif which code > /dev/null 2>&1; then
    export EDITOR="code"
  elif which kate > /dev/null 2>&1; then
    export EDITOR="kate"
  fi

  if [ "$(_n2038_get_current_shell_name)" = "${_N2038_CURRENT_SHELL_NAME_BASH}" ]; then
    # shellcheck source=/usr/local/lib/my-shell-environment/scripts/_n2038_activate_inner_bash.sh
    . "${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/_n2038_activate_inner_bash.sh" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_activate_inner_bash || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  if [ "${N2038_IS_DEBUG}" = "1" ]; then
    echo "Activating inner script: success!" >&2
  fi

  unset __n2038_new_ps1_function_file_content_only_body __n2038_new_ps2_function_file_content_only_body
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
