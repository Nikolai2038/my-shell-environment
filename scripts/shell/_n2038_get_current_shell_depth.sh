#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_shell_depth.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

_N2038_SHELL_DEPTH_UNKNOWN="?"

_n2038_get_current_shell_depth() {
  # NOTE: We don't use "SHLVL" variable here, because it is not incremented when entering "dash".
  #       I also tried to increase it manually when entering "dash", but it didn't work.

  if ! which pstree > /dev/null 2>&1; then
    if [ "${N2038_IS_DEBUG}" = "1" ]; then
      _n2038_print_error "Install \"${c_highlight}pstree${c_return}\" command to be able to see current shell depth!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    fi
    echo "${_N2038_SHELL_DEPTH_UNKNOWN}"
    return 0
  fi

  # Count all processes, which starts with word "[a-z]*sh" - like "bash", "sh" and others
  __n2038_current_shell_depth="$(pstree --ascii --long --show-parents --arguments $$ | sed -En '/^[[:blank:]]*`-[a-z]*sh( .*$|$)/p' | wc -l)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ -z "${__n2038_current_shell_depth}" ]; then
    _n2038_print_error "Could not determine the current shell depth!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    echo "${_N2038_SHELL_DEPTH_UNKNOWN}"
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  # "ksh" has different call stack
  if [ "$(_n2038_get_current_shell_name)" = "${_N2038_CURRENT_SHELL_NAME_KSH}" ]; then
    __n2038_current_shell_depth="$((__n2038_current_shell_depth + 3))" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  echo "${__n2038_current_shell_depth}"
  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
