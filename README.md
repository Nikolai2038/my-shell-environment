# my-shell-environment

## 1. Description

My personal shell environment customizations, which is both useful and simple to install.

## 2. Preview

![Preview](./.readme_images/preview.png)

Structure of the command prompt:

```plaintext
┌─[USER_NAME@PC_NAME:FULL_PATH_TO_THE_CURRENT_DIRECTORY]
├─[OS_NAME]─[SHELL_DEPTH]─[SHELL_NAME]─$ COMMAND
COMMAND_OUTPUT
└─[COMMAND_RETURN_CODE]─[FINISHED_DATE]─[FINISHED_DAY_OF_THE_WEEK]─[FINISHED_TIME]
```

## 3. Requirements

### 3.1. Supported shells

(tested with start from `bash`):

- `sh`;
- `bash`;
- `dash`;
- `ksh`.

### 3.2. Required commands

- `git`, `grep`, `which`, `tput`.

You can install them via:

- Debian:

    ```sh
    sudo apt-get update && sudo apt-get install -y git grep debianutils ncurses-bin
    ```

- Arch Linux:

    ```sh
    sudo pacman --sync --refresh --needed --noconfirm git grep which ncurses
    ```

- Termux:

    ```sh
    pkg update && pkg install -y git grep which ncurses-utils
    ```

- Fedora:

    ```sh
    sudo dnf install -y git grep which ncurses
    ```

### 3.3. Optional commands

They will enhance some functional:

- `pstree`: Will allow to output current shell depth.

You can install them via:

- Debian:

    ```sh
    sudo apt-get update && sudo apt-get install -y psmisc
    ```

- Arch Linux:

    ```sh
    sudo pacman --sync --refresh --needed --noconfirm psmisc
    ```

- Termux:

    ```sh
    pkg update && pkg install -y psmisc
    ```

- Fedora:

    ```sh
    sudo dnf install -y psmisc
    ```

- NOTE: If you install `psmisc` in already applied "my-shell-environment", for shell depth to appear you need to do either of one:

    - Open a **new terminal** (even **not a new shell**, because shell depth is recalculating based on the process tree);
    - Or just execute (but this method will see current shell as level `0`, regardless of the parent shells number):

        ```sh
        _N2038_INIT_SHELL_DEPTH="" && n2038_my_bash_environment activate
        ```

## 4. Installation

Stable version:

```sh
rm -rf ~/.my-shell-environment; git clone --branch main https://github.com/Nikolai2038/my-shell-environment.git ~/.my-shell-environment && . ~/.my-shell-environment/n2038_my_shell_environment.sh && n2038_my_shell_environment install; rm -rf ~/.my-shell-environment
```

Development version:

```sh
rm -rf ~/.my-shell-environment; git clone --branch dev https://github.com/Nikolai2038/my-shell-environment.git ~/.my-shell-environment && . ~/.my-shell-environment/n2038_my_shell_environment.sh && n2038_my_shell_environment --dev install; rm -rf ~/.my-shell-environment
```

## 5. Update

```bash
n2038_my_shell_environment update
```

## 6. Features

### 6.1. Command prompt

As shown in preview above, these scripts when sourced will show information about:

- Current user;
- Hostname;
- Full path to the current directory;
- Current real shell (follows symlinks);
- Exit code of the finished command. If it is not `0`, it will be red (can be seen on preview);
- Date and time when command was finished.

### 6.2. Scripts

#### 6.2.1. `n2038_jetbrains_download.sh` - Download specified JetBrains product latest stable installer in the current directory

Usage:

```sh
n2038_jetbrains_download.sh <product_name> <download_type>
```

Where:

- `product_name` can be one of the: `idea`, `phpstorm`, `clion`, `pycharm`, `webstorm`, `rider`, `rubymine`, `rustrover`, `writerside`, `datagrip`, `dataspell`, `fleet`, `goland`;
- `download_type` can be on of the: `linuxARM64`, `linux`, `windows`, `thirdPartyLibrariesJson`, `windowsZip`, `windowsARM64`, `mac`, `macM1`.

## 7. More information

### 7.1. About `n2038` prefix

`n2038` prefix was chosen from my nickname to use something unique - to not be confused with system scripts;

### 7.2. Environment variables (to customize environment)

These constants can be overridden via environment variables:

- `N2038_IS_DEBUG_BASH`: If debug mode is enabled (more logs will be shown);
- (must be overridden before installation) `_N2038_SHELL_ENVIRONMENT_NAME`: Name for the scripts folder and name to be shown in logs;
- (must be overridden before installation)`_N2038_SHELL_ENVIRONMENT_REPOSITORY_URL`: Repository URL to install scripts from;

### 7.3. Code style

- I use `n2038_` prefix for all variables and functions to not be confused with other ones in the system;
- I use `_` prefix for variables, which are not intended to be changed by the user;
- I use `_` prefix for functions, which are not intended to be executed by the user (but by the developer - can and must be interactive and informative about it);
- I use `__` prefix for local variables, constants and functions, which will not be available outside function;
    - Special function `_n2038_unset` is used to unset all local variables and constants - so use them in one function only. If you want to temporarily export some variable to be used in another function - consider it as constant and prefix it with `_`. Unset it by hand when not needed anymore (for example, `_N2038_RETURN_CODE_PS1` and `_N2038_PWD_BEFORE_IMPORTS_*` are like that);
- I use UPPERCASE names for constants. For example, `N2038_IS_DEBUG_BASH`;
- I try to use `sh` syntax on main elements of the shell environment. In the future, I will add several customizations for `bash` and probably some other shells when I will get to them;
- Each shell script contains function with same name. All code done in function and `return` are used. We pass all the arguments to this function and check them all in it. After function call, return code is checked. If it is not `0`, we `exit` or `return` from the script based on if it was executed or sourced (see the bottom lines of any script for more context);
- Each command, which can return non-zero return code, must end with `|| return "$?"`, `|| exit "$?"` or `|| true`;
- `exit` is forbidden to be used inside functions - only `return`. This is because we can source shell script and execute function directly in the shell - so calling `exit` from it will result in shell exit (terminal close or disconnection from the remote);
- When printing colored messages with highlights, make sure to surround highlights with quotation marks too. This way they will be more readable in logs and notes;
- Instead of `some_function || return "$?"` use `some_function || { _n2038_unset "$?" && return "$?" || return "$?"; }`:
    - There is no need to optimize this like `return 0` below, because it will only be executed on errors.
- Instead of `return 0` use `_n2038_unset 0 && return "$?" || return "$?"` to unset all local variables. Do not forget to include this as last row in each function:
    - For optimization, you can leave `return 0`, if you did not use any local variables above it.
- Instead of (for example) `return "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}"` use `_n2038_unset_init "${_N2038_RETURN_CODE_WHEN_ERROR_WITH_MESSAGE}" && return "$?" || return "$?"`.

## 6. Contribution

Feel free to contribute via [pull requests](https://github.com/Nikolai2038/my-shell-environment/pulls) or [issues](https://github.com/Nikolai2038/my-shell-environment/issues)!
