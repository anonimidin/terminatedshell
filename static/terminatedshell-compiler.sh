#!/usr/bin/env bash

# --- Function to log messages ---
log() {
    local msg=$1
    # shellcheck disable=SC2155
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] - $msg" >> compiler_log.txt
}

# --- Function to handle errors ---
h_error() {
    local msg=$1
    log "Error: $msg"
    echo "[x] - $msg"
    exit 1
}

check_deps() {
    local deps=("wget" "tar" "make")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            h_error "$dep is required but not found. Install it - sudo apt install $dep"
        fi
    done
}

parse_args() {
    if [[ $# -lt 1 ]]; then
        h_error "Usage: $0 <OUTPUT-FILE>"
    else
        output_file=$1
    fi
}

# --- Function to compile ---
compile_func() {
    if ! shc -U -f terminatedshell-static -o "$output_file"; then
        h_error "TerminatedShell script compilation failed."
    else
        log "Untraceable Terminatedshell script compiled into \"$output_file\" successfully."
        echo "[+] - Untraceable TerminatedShell script compiled into \"$output_file\" successfully."
    fi
}

# --- MAIN ---
echo "----------------------------------------------------"
echo -e "\t TerminatedShell compiler"
echo -e "https://github.com/anonimidin/terminatedshell"
echo "----------------------------------------------------"
check_deps
parse_args "$@"

if command -v shc > /dev/null; then
    log "SHC command found."
    echo "[+] - SHC command found."
    compile_func
else
    log "SHC command not found. Trying to install."
    echo "[x] - SHC command not found. Trying to install."
    
    if [[ $EUID -eq 0 ]]; then
        log "Installing SHC version 4.0.3."
        echo "[+] - Installing SHC version 4.0.3"
        
        if wget https://github.com/neurobin/shc/archive/refs/tags/4.0.3.tar.gz && \
            tar -xvzf 4.0.3.tar.gz && \
            cd shc-4.0.3 && \
            ./configure && make && sudo make install && cd -; then
                log "SHC version 4.0.3 installed successfully."
                echo "[*] - SHC version 4.0.3 installed successfully."
                echo "[*] - Compiling..."
                compile_func
        else
            h_error "Failed to install SHC version 4.0.3"
        fi
    else
        h_error "You need SU privileges to install SHC."
    fi
fi
