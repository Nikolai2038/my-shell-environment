#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/programs/firefox/n2038_firefox_search_engines_export.sh"

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
. "../../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "./_n2038_firefox_get_profile_path.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Exports search engines from current user's Firefox into specified file.
#
# Usage: n2038_firefox_search_engines_export [--dev] [--mozlz4] <file_path>
# Where:
# - `--dev`: If to use Firefox for Developers instead of default Firefox;
# - `--mozlz4`: If to export in "mozlz4" format, not JSON. In this case command "mozlz4" not needed to be installed (useful on Windows);
# - `file_path`: Path to the file where search engines data will be saved. Format is JSON.
n2038_firefox_search_engines_export() {
  __n2038_is_developers_edition="${_N2038_FALSE}"
  __n2038_is_mozlz4="${_N2038_FALSE}"
  for __n2038_argument in "$@"; do
    if [ "${__n2038_argument}" = "--dev" ]; then
      { __n2038_is_developers_edition="${_N2038_TRUE}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }
    elif [ "${__n2038_argument}" = "--mozlz4" ]; then
      { __n2038_is_mozlz4="${_N2038_TRUE}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }
    fi
  done

  if [ "$#" -lt 1 ]; then
    _n2038_print_error "Usage: ${c_highlight}n2038_firefox_search_engines_export [--dev] [--mozlz4] <file_path>${c_return}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi
  { __n2038_file_path="${1}" && shift; } || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ "${__n2038_is_developers_edition}" = "${_N2038_TRUE}" ]; then
    __n2038_firefox_profile_path="$(_n2038_firefox_get_profile_path --dev)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    __n2038_firefox_profile_path="$(_n2038_firefox_get_profile_path)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  if [ "$__n2038_is_mozlz4}" = "${_N2038_TRUE}" ]; then
    _n2038_commands_must_be_installed mozlz4 || { _n2038_unset "$?" && return "$?" || return "$?"; }
    mozlz4 "${__n2038_firefox_profile_path}/search.json.mozlz4" "${__n2038_file_path}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    cp "${__n2038_firefox_profile_path}/search.json.mozlz4" "${__n2038_file_path}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  _n2038_unset 0 && return "$?" || return "$?"
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
