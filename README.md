<h3 align="center"> 

```
╔╦╗┌─┐┬─┐┌┬┐┬┌┐┌┌─┐┌┬┐┌─┐┌┬┐╔═╗┬ ┬┌─┐┬  ┬  
 ║ ├┤ ├┬┘│││││││├─┤ │ ├┤  ││╚═╗├─┤├┤ │  │  
 ╩ └─┘┴└─┴ ┴┴┘└┘┴ ┴ ┴ └─┘─┴┘╚═╝┴ ┴└─┘┴─┘┴─┘
```
<video src="https://github.com/anonimidin/terminatedshell/assets/109206637/83813d8d-de32-4e36-920e-63b97038fbac"></video>
 
</h3>

~
<p align="center">
  <img alt="License" src="https://img.shields.io/github/license/anonimidin/terminatedshell?color=000000"/>
  <img alt="Github forks" src="https://img.shields.io/github/forks/anonimidin/terminatedshell?color=000000" />
  <img alt="Github stars" src="https://img.shields.io/github/stars/anonimidin/terminatedshell?color=000000" />
</p>

### [ ABOUT ]

Terminated Shell – TUI bash script crafted for persistence after exploitation in `Debian` based Linux operation systems.

<<<<<<< HEAD
### [ DISCLAIMER ]
=======
Terminated Shell – `Debian` based script crafted for automating persistence methods for red teamers.
>>>>>>> refs/remotes/origin/main

**This script is intended solely for `EDUCATIONAL PURPOSES`!** 

The script **author** and **contributors** do not encourage or endorse any illegal activities, and the use of this script for illegal purposes is prohibited. are not responsible for any misuse or damage caused by its use. Users should comply with the laws of their country and use this script with respect to ethical norms and laws.

### [ PROJECT STRUCTURE ]

```
.
│── .github/
│   ├── workflows/
│   │   └── main.yaml 
├── functions/
│   ├── HOOKS
│   ├── LOGS
│   ├── MALINT
│   ├── MANAGE_USERS
│   ├── MOTD
│   ├── CRON
│   ├── SHELL
│   └── SYSTEMD
├── LICENSE
├── README.md
├── CONTRIBUTING.md
└── terminatedshell
```

### [ ABOUT FUNCTIONS ]

All functions are stored in `functions/`.

**Function `MANAGE_USERS`:** View, add, or delete users. Elevate your control with superuser privileges.

**Function `CRON`:** Provides options to configure persistence with custom IP, port, and payload.

**Function `SHELL`:** Handles shell configuration persistence by adding a custom command to the user's `.bashrc` or `.zshrc` file.

**Function `MANAGE_USERS`:** Provides options to view all users, add a user, or delete a user.

**Function `HOOKS`:** Provides options for `git hooks` and `apt-get hooks`.
- For `git` hooks, it allows the user to choose a repository and add a custom payload to the `pre-commit` hook or the git config file.
- For `apt-get` hooks, it allows the user to add a custom payload to the `pre-invoke` command.

**Function `SYSTEMD`:** Compares system and user `systemd` unit paths. Allows the user to add a custom systemd service, either at the system level (with root privileges) or user level.

**Function `MOTD`:** Allows the user to add a custom payload to the `MOTD` file.

**Function `LOGS`:** Spoof `Apache2`|`NGINX` log files with random IPs and delete\disable syslog and log files via `shred`  

### [ TESTED ON ]

- ParrotOS 6.1 
- Ubuntu 24.04 LTS
- Debian 11
- Kali 2023.4

### [ REQUIREMENTS ]

Before starting, ensure you have the necessary tools/packages are installed or install them based on what function are you going to use on target machine:

```
systemd
cron
shred
anonip
rlwrap
```

One-liner command to install them (SU privileges are required) :

```bash
sudo apt-get install systemd cron sudo coreutils rlwrap -y && \
echo -e "\n[+] All requirements has been installed \n" || echo -e "\n[x] Something went wrong.\n";
```

### [ INSTALLATION ]

Choose your preferred one-liner to download and run the script:

- **Using curl**

``` bash
curl -LO https://github.com/anonimidin/terminatedshell/blob/main/static/terminatedshell-static && \
chmod +x terminatedshell-static && ./terminatedshell-static || echo -e "\n[x] Something went wrong\n";
```

- **Using wget**

```sh
wget https://github.com/anonimidin/terminatedshell/raw/main/terminatedshell -O terminatedshell && \
chmod +x terminatedshell functions/* && ./terminatedshell || echo -e "\n[x] Something went wrong\n";
```

- **Using git**

```sh
git clone https://github.com/anonimidin/terminatedshell.git && cd terminatedshell && \
chmod +x terminatedshell functions/* && ./terminatedshell || echo -e "\n[x] Something went wrong\n"; 
```

- **Compile static script via shc**

```sh
bash ./static/terminatedshell-compiler.sh terminatedshell-bin 
```

### [ ADDING YOUR IDEAS ]

We welcome your **creative ideas** and **contributions** to the development of the **Terminated Shell** project! If you have **suggestions**, **improvements**, or **new features**, please share them with us. Together, we can make this tool even better. [Check CONTRIBUTING.md for details.](CONTRIBUTING.md)

### [ LICENSE ]

This project is under license from **Apache License 2.0**. For more details, see the [LICENSE](LICENSE.md) file.

Made by <a href="https://t.me/s/anonimidin_notes" target="_blank">ANONIMIDIN</a> for cybersecurity enthusiasts.