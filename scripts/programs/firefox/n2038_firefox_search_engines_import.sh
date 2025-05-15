#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/programs/firefox/n2038_firefox_search_engines_import.sh"

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
. "./n2038_firefox_get_profile_path.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Imports search engines to the current user's Firefox from specified file.
#
# Usage: n2038_firefox_search_engines_import [--mozlz4] <firefox_type> <file_path>
# Where:
# - `firefox_type`: Type of the Firefox:
#   - `firefox`: Firefox;
#   - `firefox-developer-edition`: Firefox for Developers.
# - `--mozlz4`: If provided file is in "mozlz4" format, not JSON. In this case command "mozlz4" not needed to be installed (useful on Windows);
# - `file_path`: Path to the file from where search engines data will be loaded.
n2038_firefox_search_engines_import() {
  __n2038_usage() {
    _n2038_print_error "Usage: ${c_highlight}n2038_firefox_search_engines_import [--mozlz4] <${__N2038_FIREFOX_TYPE_FIREFOX}|${__N2038_FIREFOX_TYPE_FIREFOX_DEVELOPER_EDITION}> <file_path>${c_return}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  }

  __n2038_is_mozlz4="${_N2038_FALSE}"
  for __n2038_argument in "$@"; do
    if [ "${__n2038_argument}" = "--mozlz4" ]; then
      { __n2038_is_mozlz4="${_N2038_TRUE}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }
    fi
  done

  if [ "$#" -ne 2 ]; then
    __n2038_usage && return "$?" || return "$?"
  fi
  __n2038_firefox_type="${1}" && { shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; }
  __n2038_file_path="${1}" && { shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; }

  __n2038_firefox_profile_path="$(n2038_firefox_get_profile_path "${__n2038_firefox_type}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ "$__n2038_is_mozlz4}" = "${_N2038_TRUE}" ]; then
    cp "${__n2038_file_path}" "${__n2038_firefox_profile_path}/search.json.mozlz4" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    _n2038_commands_must_be_installed mozlz4 || { _n2038_unset "$?" && return "$?" || return "$?"; }
    mozlz4 -z "${__n2038_file_path}" "${__n2038_firefox_profile_path}/search.json.mozlz4" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  unset __n2038_is_developers_edition __n2038_is_mozlz4 __n2038_argument __n2038_file_path __n2038_firefox_profile_path
  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
