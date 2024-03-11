#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "[*] Usage: bash terminatedshell-compiler.sh <OUTPUT-FILE>" && exit 1;
else
    output_file=$1
fi

compile_func() {
    shc -l "/bin/bash" -U -f terminatedshell-static -o "$output_file" && \
    echo "[+] - Terminatedshell script compiled into \"$output_file\" SUCCESSFULLY" || { echo -e "\n[x] - Terminatedshell script compiled UNSUCCESSFULLY\n";}
}
if command -v shc > /dev/null; then
    echo "[+] - SHC command FOUND" && compile_func;
else
    echo "[x] - SHC command NOT FOUND"
    if [[ $EUID -eq 0 ]]; then
        echo "[+] Installing SHC version 4.0.3" && \
        wget https://github.com/neurobin/shc/archive/refs/tags/4.0.3.tar.gz && tar -xvzf 4.0.3.tar.gz && cd shc-4.0.3 && \
        ./configure && make && sudo make install && cd - && \
        echo "[*] - Compiling..." && sleep 0.5 && compile_func;
    else
        echo "[*] - You need SU privileges to install SHC" 
    fi;
fi
