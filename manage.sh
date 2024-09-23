#!/bin/bash

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

# Function to download benchmark result files from remote server
download_remote_benchmark_files() {
    local local_dir="benchmark-results"
    mkdir -p "$local_dir"
    ssh -p $PORT $REMOTE_SERVER "find /tmp -type f \( -name '*.html' -o -name '*.json' \) -print0" | xargs -0 -I {} scp -P $PORT $REMOTE_SERVER:{} "$local_dir/"
    echo "Downloaded .html and .json files from /tmp to $local_dir/"
    
    # Download ~/simple-evals/ifeval/result.txt
    scp -P $PORT $REMOTE_SERVER:~/simple-evals/ifeval/result.txt "$local_dir/"
    echo "Downloaded ~/simple-evals/ifeval/result.txt to $local_dir/"
    
    # Download all jsonl files from ~/simple-evals/ifeval/data
    mkdir -p "$local_dir/ifeval_data"
    ssh -p $PORT $REMOTE_SERVER "find ~/simple-evals/ifeval/data -name '*.jsonl' -print0" | xargs -0 -I {} scp -P $PORT $REMOTE_SERVER:{} "$local_dir/ifeval_data/"
    echo "Downloaded all jsonl files from ~/simple-evals/ifeval/data to $local_dir/ifeval_data/"
}

# Function to SSH into the remote server
ssh_connect() {
    ssh -p $PORT $REMOTE_SERVER
}

# Check if a target is provided
if [ $# -eq 0 ]; then
    echo "Error: No target specified. Usage: $0 <target> [port]"
    exit 1
fi

target=$1

# Check if the target is to download benchmark results
if [ "$target" = "download-benchmark-results" ]; then
    download_remote_benchmark_files
    exit 0
fi

# Check if the target is to SSH connect
if [ "$target" = "connect" ]; then
    ssh_connect
    exit 0
fi

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
        echo "Error: Invalid target. Supported targets are setup.sh, process-<number>.sh, download-benchmark-results, and connect"
        exit 1
        ;;
esac
