#!/bin/sh

: "$((_N2038_PATH_TO_THIS_SCRIPT_NUMBER = _N2038_PATH_TO_THIS_SCRIPT_NUMBER + 1))"
eval "_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}=\"${_N2038_SHELL_ENVIRONMENT_PATH}/scripts/shell/_n2038_ps1_function.sh\""
# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_before_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_before_imports.sh" && _n2038_required_before_imports; } || { __n2038_return_code="$?" && [ "$(basename "$0")" = "$(eval "basename \"\${_N2038_PATH_TO_THIS_SCRIPT_${_N2038_PATH_TO_THIS_SCRIPT_NUMBER}}\"")" ] && exit "${__n2038_return_code}" || return "${__n2038_return_code}"; }

# Imports
. "./_n2038_get_current_shell.sh" || _n2038_return "$?"

# shellcheck source=/usr/local/lib/my-shell-environment/_n2038_required_after_imports.sh
{ . "${_N2038_SHELL_ENVIRONMENT_PATH}/_n2038_required_after_imports.sh" && _n2038_required_after_imports; } || _n2038_return "$?"

# Color for info text
export c_info="\033[38;5;06m"

# Color for successful text
export c_success="\033[38;5;02m"

# Color for highlighted text
export c_highlight="\033[38;5;90m"

# Color for warning text
export c_warning="\033[38;5;03m"

# Color for error text
export c_error="\033[38;5;01m"

# Color for usual text (in cases when using "_n2038_print_color_message" function is not possible)
export c_text="\033[38;5;15m"

# Color for border used in PS1 function - for usual user
export c_border_usual="\033[38;5;27m"

# Color for border used in PS1 function - for root user
export c_border_root="\033[38;5;90m"

# Color for border when printing tables, etc.
export c_border="${c_border_usual}"

# Reset color
export c_reset='\e[0m'

_n2038_ps1_function() {
  __n2038_return_code="${1}" && { shift || true; }

  __n2038_return_code_formatted="$(printf '%03d' "${__n2038_return_code#0}")" || return "$?"

  __n2038_date="$(date +'%Y-%m-%d]─[%a]─[%H:%M:%S')" || return "$?"

  # There is warning about "$HOSTNAME" being undefined in POSIX "sh", so just in case, we use "hostname" command to get it, if it is installed.
  # Also, "hostname" command is used in WSL, where is no "$HOSTNAME", but we can still get Windows hostname.
  __n2038_hostname="$(hostname)" || return "$?"

  __n2038_user="$(whoami)" || return "$?"

  __n2038_current_shell="$(_n2038_get_current_shell)" || return "$?"

  # We don't use "\"-variables ("\w", "\u", "\h", etc.) here because they do not exist in "sh"
  echo -e "${c_border}└─[${c_reset}${__n2038_return_code_formatted}]─[${__n2038_date}]"
  echo ""
  echo -e "${c_border}┌─[${c_reset}${__n2038_user}@${__n2038_hostname}:${PWD}]"
  echo -e "${c_border}├─[${c_reset}${__n2038_current_shell}]─$ "

  unset __n2038_return_code __n2038_return_code_formatted __n2038_date __n2038_hostname __n2038_user __n2038_current_shell
}

# If this file is being executed - we execute function itself, otherwise it will be just loaded
if [ "$(basename "$0")" = "_n2038_ps1_function.sh" ]; then
  _n2038_ps1_function "${@}" || exit "$?"
fi
