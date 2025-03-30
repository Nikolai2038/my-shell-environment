#!/bin/sh

__N2038_PATH_TO_THIS_SCRIPT_FROM_ENVIRONMENT_ROOT="scripts/programs/jetbrains/n2038_jetbrains_install.sh"

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
. "../../../n2038_my_shell_environment.sh" || _n2038_return "$?" || return "$?"

# Imports
. "./_constants.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_constants.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_n2038_print_error.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_n2038_print_info.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_n2038_print_list_items.sh" || _n2038_return "$?" || return "$?"
. "../../messages/_n2038_print_success.sh" || _n2038_return "$?" || return "$?"
. "./n2038_jetbrains_download.sh" || _n2038_return "$?" || return "$?"

# Required after imports
_n2038_required_after_imports || _n2038_return "$?" || return "$?"

n2038_jetbrains_install() {
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

  __n2038_downloaded_file="$(n2038_jetbrains_download "${__n2038_product_name}" "${__n2038_download_type}")" || { _n2038_unset "$?" && return "$?" || return "$?"; }

  if [ "${__n2038_download_type}" = "${_N2038_JETBRAINS_DOWNLOAD_TYPE_LINUX}" ]; then
    __n2038_program_directory="${N2038_PROGRAMS_PATH}/JetBrains/${__n2038_product_name}"
    sudo mkdir --parents "${__n2038_program_directory}" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    # Before extracting, get directory name inside tar archive
    __n2038_dir_name="$(tar --list --file="${__n2038_downloaded_file}" | head -n 1 | cut -d '/' -f 1)" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    if [ -z "${__n2038_dir_name}" ]; then
      _n2038_print_error "Failed to get directory name from tar archive!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
      _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
    fi

    __n2038_installed_program_directory="${__n2038_program_directory}/${__n2038_dir_name}"
    if [ -d "${__n2038_installed_program_directory}" ]; then
      _n2038_print_info "The directory \"${c_highlight}${__n2038_installed_program_directory}${c_return}\" already exists! Unpacking the archive will be skipped!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    else
      _n2038_print_info "Unpacking the archive \"${c_highlight}${__n2038_downloaded_file}${c_return}\" to \"${c_highlight}${__n2038_installed_program_directory}${c_return}\"..." || { _n2038_unset "$?" && return "$?" || return "$?"; }
      sudo tar --extract --gzip --file="${__n2038_downloaded_file}" --directory="${__n2038_program_directory}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
      _n2038_print_success "Unpacking the archive \"${c_highlight}${__n2038_downloaded_file}${c_return}\" to \"${c_highlight}${__n2038_installed_program_directory}${c_return}\": success!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    fi

    __n2038_bin_file="${__n2038_installed_program_directory}/bin/${__n2038_product_name}"

    _n2038_print_info "Creating symlink to the program \"${c_highlight}${__n2038_product_name}${c_return}\"..." || { _n2038_unset "$?" && return "$?" || return "$?"; }
    echo sudo ln -sf "${__n2038_bin_file}" "${_N2038_SHELL_ENVIRONMENT_PROGRAMS}/${__n2038_product_name}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    sudo ln -sf "${__n2038_installed_program_directory}/bin/${__n2038_product_name}" "${_N2038_SHELL_ENVIRONMENT_PROGRAMS}/${__n2038_product_name}" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_print_success "Creating symlink to the program \"${c_highlight}${__n2038_product_name}${c_return}\": success!" || { _n2038_unset "$?" && return "$?" || return "$?"; }

    _n2038_print_info "Creating desktop entry for the program \"${c_highlight}${__n2038_product_name}${c_return}\"..." || { _n2038_unset "$?" && return "$?" || return "$?"; }

    cat << EOF | sudo tee "/usr/share/applications/${__n2038_product_name}.desktop" > /dev/null || { _n2038_unset "$?" && return "$?" || return "$?"; }
[Desktop Entry]
Name=${__n2038_product_name}
Exec=${__n2038_bin_file}
Icon=${__n2038_bin_file}.svg
Type=Application
Terminal=false
EOF
    _n2038_print_success "Creating desktop entry for the program \"${c_highlight}${__n2038_product_name}${c_return}\": success!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
  else
    _n2038_print_error "The installation for the JetBrains product \"${c_highlight}${__n2038_product_name}${c_return}\" is not implemented for the OS type \"${c_highlight}${__n2038_download_type}${c_return}\"!" || { _n2038_unset "$?" && return "$?" || return "$?"; }
    _n2038_unset "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"
  fi

  return 0
}

# Required after function
_n2038_required_after_function "$@" || _n2038_return "$?" || return "$?"
