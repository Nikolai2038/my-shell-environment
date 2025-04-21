#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/programs/firefox/_n2038_firefox_get_profile_path.sh"

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
. "../../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "../../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Prints the path to the Firefox profile.
#
# Usage: _n2038_firefox_get_profile_path [--dev]
# Where:
# - `--dev`: If to use Firefox for Developers instead of default Firefox;
_n2038_firefox_get_profile_path() {
  __n2038_is_developers_edition="${_N2038_FALSE}"

  for __n2038_argument in "$@"; do
    if [ "${__n2038_argument}" = "--dev" ]; then
      __n2038_is_developers_edition="${_N2038_TRUE}" && { shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; }
    fi
  done

  if [ "${_N2038_CURRENT_OS_NAME}" = "${_N2038_OS_NAME_WINDOWS}" ]; then
    __n2038_firefox_data_path="${APPDATA}/Mozilla/Firefox"
  else
    __n2038_firefox_data_path="${HOME}/.mozilla/firefox"
  fi

  if [ "${__n2038_is_developers_edition}" = "${_N2038_TRUE}" ]; then
    __n2038_firefox_profile_name="$(sed -En 's/^Path=(.+\.dev-edition-default)$/\1/p' "${__n2038_firefox_data_path}/profiles.ini")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    __n2038_firefox_profile_name="$(sed -En 's/^Path=(.+\.default-release)$/\1/p' "${__n2038_firefox_data_path}/profiles.ini")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi
  echo "${__n2038_firefox_data_path}/${__n2038_firefox_profile_name}"

  unset __n2038_is_developers_edition __n2038_argument __n2038_firefox_data_path __n2038_firefox_profile_name
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
