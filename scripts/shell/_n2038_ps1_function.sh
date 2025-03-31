#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_ps1_function.sh"

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

# Imitate sourcing main file - to get correct references in IDE - it will not actually be sourced
. "../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_echo.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_get_current_shell_depth.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_get_current_shell_name.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_get_timestamp.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

if [ -z "${_N2038_EXECUTION_TIME_ACCURACY}" ]; then
  export _N2038_EXECUTION_TIME_ACCURACY=2
fi

# Print PS1 prompt.
#
# Usage: _n2038_ps1_function [return_code]
_n2038_ps1_function() {
  [ "$#" -gt 0 ] && { __n2038_return_code="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_return_code=""

  __n2038_color_for_error_code="${c_success}"

  if [ "${__n2038_return_code}" != "0" ]; then
    __n2038_color_for_error_code="${c_error}"
  fi

  __n2038_return_code_formatted="$(printf '%03d' "${__n2038_return_code#0}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  __n2038_date="$(date +'%Y-%m-%d]─[%a]─[%H:%M:%S')" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Getting "${USER}" is faster, but it is not always available
  if [ -n "${USER}" ]; then
    __n2038_user="${USER}"
  else
    __n2038_user="$(whoami)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  # Getting "${HOSTNAME}" is faster, but it is not always available:
  # - in "sh" (for example, in "dash");
  # - in WSL;
  if [ -n "${HOSTNAME}" ]; then
    __n2038_hostname="${HOSTNAME}"
  else
    __n2038_hostname="$(hostname)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  __n2038_current_os_name="${_N2038_CURRENT_OS_NAME}"
  if [ "${__n2038_current_os_name}" = "${_N2038_OS_NAME_UNKNOWN}" ]; then
    __n2038_current_os_name="${c_error}${__n2038_current_os_name}${c_border}"
  elif [ -n "${_N2038_CURRENT_OS_VERSION}" ]; then
    __n2038_current_os_name="${__n2038_current_os_name}-${_N2038_CURRENT_OS_VERSION}"
  fi

  __n2038_was_error_calculating_current_shell_depth=0

  # We improve performance of PS1 here by checking for init shell because we can.
  # This is very useful, because often you work in init shell anyways.
  if [ "${$}" = "${_N2038_INIT_SHELL_PROCESS_ID}" ] && [ "${_N2038_INIT_SHELL_DEPTH}" != "${_N2038_SHELL_DEPTH_UNKNOWN}" ]; then
    __n2038_current_shell_depth=0
  else
    __n2038_current_shell_depth="$(_n2038_get_current_shell_depth)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    if [ "${__n2038_current_shell_depth}" = "${_N2038_SHELL_DEPTH_UNKNOWN}" ]; then
      __n2038_was_error_calculating_current_shell_depth=1
    else
      if [ -z "${_N2038_INIT_SHELL_DEPTH}" ]; then
        _n2038_print_error "Variable \"${c_highlight}_N2038_INIT_SHELL_DEPTH${c_return}\" is not defined!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
        _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
      elif [ "${_N2038_INIT_SHELL_DEPTH}" = "${_N2038_SHELL_DEPTH_UNKNOWN}" ]; then
        __n2038_was_error_calculating_current_shell_depth=1
      else
        __n2038_current_shell_depth="$((__n2038_current_shell_depth - _N2038_INIT_SHELL_DEPTH - 1))" || { _n2038_unset "$?" && return "$?" || return "$?"; }

        # Termux has different call stack
        if [ "${__n2038_current_os_name}" = "${_N2038_OS_NAME_TERMUX}" ] && [ "${__n2038_current_shell_depth}" != "0" ]; then
          __n2038_current_shell_depth="$((__n2038_current_shell_depth - 3))" || { _n2038_unset "$?" && return "$?" || return "$?"; }
        fi
      fi
    fi
  fi

  __n2038_get_current_shell_depth_part=""
  if [ "${__n2038_was_error_calculating_current_shell_depth}" = "0" ]; then
    __n2038_get_current_shell_depth_part="─[${__n2038_current_shell_depth}]"
  fi

  __n2038_current_shell_name="$(_n2038_get_current_shell_name)" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  __n2038_execution_time_part=""
  if [ "${__n2038_current_shell_name}" = "${_N2038_CURRENT_SHELL_NAME_BASH}" ] && [ -n "${_N2038_LAST_TIME}" ]; then
    __n2038_current_timestamp="$(_n2038_get_timestamp)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    __n2038_current_timestamp="$((__n2038_current_timestamp - _N2038_LAST_TIME))" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Align with 24 characters - this should be enough for a couple thousand years
    __n2038_current_timestamp="$(printf '%024d' "${__n2038_current_timestamp#0}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Show seconds
    __n2038_seconds="$(echo "${__n2038_current_timestamp}" | cut -c1-15 | sed -En 's/^0*([0-9][0-9]*)/\1/p')" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Show seconds parts with specified accuracy
    __n2038_nanoseconds="$(echo "${__n2038_current_timestamp}" | cut "-c16-$((16 + _N2038_EXECUTION_TIME_ACCURACY - 1))")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    __n2038_execution_time_part="─[${__n2038_seconds}.${__n2038_nanoseconds}]" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  # - We don't use "\"-variables ("\w", "\u", "\h", etc.) here because they do not exist in "sh".
  # - Colors must be defined before PS1 and not inside it, otherwise the braces will be printed directly.
  #   Because of that, we can't call "_n2038_print_color_message" here.
  #   But we can specify colors here and replace them all colors with their values later.
  # - We specify colors in the beginning of each line, because bash may have override it with text color, when navigating in commands' history.
  _n2038_echo -en "${c_border}└─[${__n2038_color_for_error_code}${__n2038_return_code_formatted}${c_border}]${__n2038_execution_time_part}─[${__n2038_date}]

${c_border}┌─[${__n2038_user}@${__n2038_hostname}:${c_success}${PWD}${c_border}]
${c_border}├─[${__n2038_current_os_name}]${__n2038_get_current_shell_depth_part}─[${c_success}${__n2038_current_shell_name}${c_border}]─\$ ${c_reset}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  # Since we will run this function in subshell anyway, we won't unset local variables to get even more performance.
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
