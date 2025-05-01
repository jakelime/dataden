#!/bin/bash

run_version_init_jetforge() {
    # this function is meant to be run from root dir
    # in docker compose structure
    echo "initialising versioning for jetforge..."
    cwd=$(pwd)
    cd src-jetforge/main/
    python3 initapp.py
    cd $cwd
}

load_env_file() {
    # Loads environment variables from a .env file

    # Check if an argument was provided
    if [ -z "$1" ]; then
        ENV_FILE=".env"
    else
        ENV_FILE="$1"
    fi

    # Check if the .env file exists
    if [ ! -f "$ENV_FILE" ]; then
        echo "Error: .env file not found at $ENV_FILE"
        exit 1
    fi

    # Read the .env file line by line
    # This loop handles:
    # - Lines starting with # (comments)
    # - Empty lines
    # - Exporting valid variable assignments
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Trim leading/trailing whitespace from the line
        trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        # Skip comments and empty lines
        if [[ "$trimmed_line" =~ ^# || -z "$trimmed_line" ]]; then
            continue
        fi

        # Export the variable
        # Using 'export' makes the variable available to subprocesses
        # Using 'eval' allows variable substitution within the .env file itself (use with caution)
        # If you don't need substitution, a safer approach is: export "$trimmed_line"
        # However, the standard `export KEY=VALUE` syntax is more common in .env files.
        # This approach handles `export KEY=VALUE` and `KEY=VALUE` formats.
        if [[ "$trimmed_line" =~ ^export[[:space:]]+ ]]; then
            # Handle lines that already start with 'export'
            eval "$trimmed_line"
        else
            # Handle lines in KEY=VALUE format
            export "$trimmed_line"
        fi

    done <"$ENV_FILE"

}

mount_network_drive() {
    # mounts network drive, parameters are
    # -s (source, network path)
    # -d (destination, local path to be mounted to)

    # loads env into local variables
    loads_env_file
    local src="$NETWORK_DRIVE_PATH"
    local dst="$LOCAL_MOUNT_PATH"

    # function to use optional arguments in this function
    while getopts "s:d:" opt; do
        case "$opt" in
        s) src="$OPTARG" ;;
        d) dst="$OPTARG" ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            return 1
            ;;
        esac
    done

    # try to catch if env variables are not available,
    # or, no arguments detected
    if [[ -z "$src" ]]; then
        echo "Error: NETWORK_DRIVE_PATH is not defined in .env" >&2
        return 1
    elif [[ -z "$dst" ]]; then
        echo "Error: LOCAL_MOUNT_PATH is not defined in .env" >&2
        return 1
    fi

    echo "mapping function(src: $src, dst: $dst)..."
    if [ ! -d "${dst}" ]; then
        echo "netdrive dir is not mapped."
        sudo mkdir -p "${dst}"
        sudo mount -t drvfs $src "${dst}"
    else
        echo "netdrive is already mapped: ${mounted_path}"
    fi

}
