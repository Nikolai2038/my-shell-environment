#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/shell/_n2038_get_current_os_version.sh"

# Required before imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_before_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_before_imports.sh" || { __n2038_return_code="$?" && [ "${__n2038_return_code}" = "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" ] && return "${_N2038_RETURN_CODE_WHEN_FILE_IS_ALREADY_SOURCED}" || [ "$({ basename "$0" || echo basename_failed; } 2> /dev/null)" = "$({ eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"" || echo eval_basename_failed; } 2> /dev/null)" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_get_current_os_name.sh" || _n2038_return "$?" || return "$?"

# Required after imports
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_imports.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_imports.sh" || _n2038_return "$?" || return "$?"

# Prints version of the current OS.
# It can be empty (for example, for Arch).
# Also, we don't save it's value in variable, like we did with _N2038_CURRENT_OS_NAME, because OS version can change in current shell (if we update it).
#
# Usage: _n2038_get_current_os_version
_n2038_get_current_os_version() {
  # There is no version for Arch, so we skip checking it every time
  __n2038_current_os_name="$(_n2038_get_current_os_name)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  if [ "${__n2038_current_os_name}" = "${_N2038_OS_NAME_ARCH}" ]; then
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  # For Termux there is no "/etc/os-release" file, so we need to check it separately
  if [ -n "${TERMUX_VERSION}" ]; then
    echo "${TERMUX_VERSION}"
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  if [ ! -f "/etc/os-release" ]; then
    _n2038_print_error "File \"${c_highlight}/etc/os-release${c_return}\" not found - probably, \"${c_highlight}_n2038_get_current_os_version${c_return}\" is not implemented for your OS." || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset 0 && return "$?" || return "$?"
  fi

  sed -n 's/^VERSION_ID=//p' /etc/os-release || { _n2038_unset "$?" && return "$?" || return "$?"; }

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
# shellcheck source=/usr/local/lib/my-shell-environment/requirements/_n2038_required_after_function.sh
. "${_N2038_REQUIREMENTS_PATH}/_n2038_required_after_function.sh" || _n2038_return "$?" || return "$?"
