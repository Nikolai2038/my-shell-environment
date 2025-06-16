#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/programs/jetbrains/n2038_jetbrains_download.sh"

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
. "./_constants.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_n2038_print_info.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_n2038_print_list_items.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

# Download specified JetBrains product latest EAP installer in the current directory.
#
# Usage: n2038_jetbrains_download <product_name> <download_type> [version]
#
# Example: n2038_jetbrains_download "idea" "linux"
n2038_jetbrains_download() {
  _n2038_commands_must_be_installed jq || { _n2038_unset "$?" && return "$?" || return "$?"; }

  [ "$#" -gt 0 ] && { __n2038_product_name="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_product_name=""
  if [ -z "${__n2038_product_name}" ]; then
    _n2038_print_error "The product name is not specified! Available products:
$(_n2038_print_list_items "${_N2038_JETBRAINS_PRODUCTS}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  [ "$#" -gt 0 ] && { __n2038_download_type="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_download_type=""
  if [ -z "${__n2038_download_type}" ]; then
    _n2038_print_error "The OS type is not specified! Available OS types:
$(_n2038_print_list_items "${_N2038_JETBRAINS_DOWNLOAD_TYPES}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  [ "$#" -gt 0 ] && { __n2038_version="${1}" && shift || { _n2038_unset "$?" && return "$?" || return "$?"; }; } || __n2038_version=""

  if [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_IDEA}" ]; then
    __n2038_product_code="IIU"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_PHPSTORM}" ]; then
    __n2038_product_code="PS"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_CLION}" ]; then
    __n2038_product_code="CL"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_PYCHARM}" ]; then
    __n2038_product_code="PC"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_WEBSTORM}" ]; then
    __n2038_product_code="WS"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_RIDER}" ]; then
    __n2038_product_code="RD"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_RUBYMINE}" ]; then
    __n2038_product_code="RM"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_RUSTROVER}" ]; then
    __n2038_product_code="RR"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_WRITERSIDE}" ]; then
    __n2038_product_code="WRS"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_DATAGRIP}" ]; then
    __n2038_product_code="DG"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_DATASPELL}" ]; then
    __n2038_product_code="DS"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_FLEET}" ]; then
    __n2038_product_code="FL"
  elif [ "${__n2038_product_name}" = "${_N2038_JETBRAINS_PRODUCT_NAME_GOLAND}" ]; then
    __n2038_product_code="GO"
  else
    _n2038_print_error "The download for the JetBrains product \"${c_highlight}${__n2038_product_name}${c_return}\" is not implemented! Available products:
$(_n2038_print_list_items "${_N2038_JETBRAINS_PRODUCTS}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  # "release.type" can be:
  # - "eap" (Early Access Program) – A preview version with experimental features, available for early testing. It may be unstable and is not intended for production use. But it can be used without license - just need to login.
  # - "rc" (Release Candidate) – A nearly finished version that is being tested for final bugs before the official release. It is more stable than EAP but still not guaranteed to be bug-free.
  # - "release" – The final, officially stable version intended for general use.
  if [ -n "${__n2038_version}" ]; then
    __n2038_version_files="$(curl --fail "https://data.services.jetbrains.com/products?code=${__n2038_product_code}&release.type=eap" | jq -r '(.[0].releases[] | select(.version == "'"${__n2038_version}"'") | .downloads // "")')" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  # If version is not specified - we get the latest one
  else
    __n2038_version_files="$(curl --fail "https://data.services.jetbrains.com/products?code=${__n2038_product_code}&release.type=eap" | jq -r '(.[0].releases.[0].downloads // "")')" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  if [ -z "${__n2038_version_files}" ]; then
    _n2038_print_error "Failed to get files list!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  __n2038_link_to_download="$(echo "${__n2038_version_files}" | jq -r "(.${__n2038_download_type}.link // \"\")")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  if [ -z "${__n2038_link_to_download}" ]; then
    _n2038_print_error "Download link for type \"${c_highlight}${__n2038_download_type}${c_return}\" not found! Found download types:
$(_n2038_print_list_items "$(echo "${__n2038_version_files}" | jq -r 'keys[]')")" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  # Use CDN server to download
  __n2038_link_to_download="$(echo "${__n2038_link_to_download}" | sed -En 's|^(https://download)(.jetbrains.com.+)$|\1-cdn\2|p')" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  __n2038_file_path="${N2038_DOWNLOADS_PATH}/$(basename "${__n2038_link_to_download}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ -f "${__n2038_file_path}" ]; then
    _n2038_print_info "File \"${c_highlight}${__n2038_file_path}${c_return}\" already exists. Skipping download." || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    curl --fail -L -o "${__n2038_file_path}" "${__n2038_link_to_download}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  fi

  echo "${__n2038_file_path}"

  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
