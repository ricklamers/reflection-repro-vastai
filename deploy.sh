#!/bin/bash

# Define the remote server address and port
REMOTE_SERVER="root@38.99.105.118"
PORT=21515

# Function to check if a file exists on the remote server
check_file_exists() {
    ssh -p $PORT $REMOTE_SERVER "test -f $1"
    return $?
}

# Function to copy and run a script on the remote server in a tmux session
copy_and_run_remote_script() {
    local script=$1
    local filled_script="/tmp/filled_$(basename $script)"
    local session_name="script_session_$(date +%s)"
    
    # Use templatefill.py to get a template-filled version of the file
    python templatefill.py "$script" "$filled_script"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fill template for $script"
        exit 1
    fi
    
    scp -P $PORT "$filled_script" $REMOTE_SERVER:./
    # Create optional ~/.no_auto_tmux file on the remote server
    ssh -p $PORT $REMOTE_SERVER "touch ~/.no_auto_tmux"
    ssh -p $PORT $REMOTE_SERVER "tmux new-session -d -s $session_name 'bash ./$(basename $filled_script); exec bash'"
    
    echo "Script is running in tmux session: $session_name"
    echo "To attach to the session, use: ssh -p $PORT $REMOTE_SERVER -t 'tmux attach-session -t $session_name'"
    
    # Clean up the temporary filled script
    rm "$filled_script"
    
    # Attach to the tmux session to see the script run
    ssh -p $PORT $REMOTE_SERVER -t "tmux attach-session -t $session_name"
}

# Check if a target is provided
if [ $# -eq 0 ]; then
    echo "Error: No target specified. Usage: $0 <target> [port]"
    exit 1
fi

target=$1

# Check if the target file exists locally
if [ ! -f "$target" ]; then
    echo "Error: $target does not exist locally."
    exit 1
fi

# Handle different target types
case $target in
    setup.sh)
        copy_and_run_remote_script $target
        ;;
    process-*.sh)
        # Check if the file exists locally
        if [ ! -f "$target" ]; then
            echo "Error: $target does not exist locally."
            exit 1
        fi
        copy_and_run_remote_script $target
        ;;
    *)
        echo "Error: Invalid target. Supported targets are setup.sh and process-<number>.sh"
        exit 1
        ;;
esac
