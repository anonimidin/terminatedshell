<div align="center" id="top">
  <img src="./.github/banner.png" alt="Terminatedshell" />

  &#xa0;
  
</div>

<p align="center">
  <img alt="License" src="https://img.shields.io/github/license/anonimidin/terminatedshell?color=000000"/>
  <img alt="Github forks" src="https://img.shields.io/github/forks/anonimidin/terminatedshell?color=000000" />
  <img alt="Github stars" src="https://img.shields.io/github/stars/anonimidin/terminatedshell?color=000000" />
</p>

<hr>

## [ ABOUT ] ##

Terminated Shell script – `Debian` based tool crafted for Linux persistence.

![PREVIEW](./.github/preview.mp4)

## [ DISCLAIMER ] ##

This script is intended solely for `EDUCATIONAL PURPOSES`. The script **author** and **contributors** do not encourage or endorse any illegal activities, and the use of this script for illegal purposes is prohibited. are not responsible for any misuse or damage caused by its use. Users should comply with the laws of their country and use this script with respect to ethical norms and laws.

## [ PROJECT STRUCTURE ] ##

```text
.
│── .github/
│   ├── workflows/
│   │   └── main.yaml
│   ├── banner.png 
│   └── preview.mp4
├── functions/
│   ├── HOOKS
│   ├── LOGS
│   ├── MALINT
│   ├── MANAGE_USERS
│   ├── MOTD
│   ├── SCHEDULER
│   ├── SHELL
│   └── SYSTEMD
├── LICENSE
├── README.md
└── terminatedshell
```

## [ ABOUT FUNCTIONS ] ##

All functions are stored in `functions/`. 

**- Function: `MANAGE_USERS`:**

- View, add, or delete users. Elevate your control with superuser privileges.

**- Function: `SCHEDULER`:**

- Handles scheduler persistence, allowing the user to choose between `at` and `cron`.
- Provides options to configure persistence with custom IP, port, and payload.
- Checks for the existence of the `at` command and installs it if necessary.

**- Function: `SHELL`:**

- Handles shell configuration persistence by adding a custom command to the user's `.bashrc` or `.zshrc` file.

**- Function: `MANAGE_USERS`:**

- Provides options to view all users, add a user, or delete a user.
- Checks for superuser privileges before executing user management tasks.

**- Function: `HOOKS`:**

- Provides options for `git hooks` and `apt-get hooks`.
- For `git` hooks, it allows the user to choose a repository and add a custom payload to the `pre-commit` hook or the git config file.
- For `apt-get` hooks, it allows the user to add a custom payload to the `pre-invoke` command.

**- Function: `SYSTEMD`:**

- Compares system and user `systemd` unit paths.
- Allows the user to add a custom systemd service, either at the system level (with root privileges) or user level.

**- Function: `MOTD`:**

- Allows the user to add a custom payload to the `MOTD` file.

## [ REQUIREMENTS ] ##

Before starting, ensure you have the necessary tools/packages installed are install on target:

```text
at
socat
systemd
cron
shred
anonip
```

One-liner command to install them (SU privileges are required) :

```bash
sudo apt-get install at socat systemd cron sudo coreutils/shred -y && sudo apt autoremove -y && \
echo -e "\n[+] All requirements has been installed \n" || echo -e "\n[x] Something went wrong.\n";
```

## [ INSTALLATION ] ##

Choose your preferred one-liner to download and run the script:

- **Using curl**

``` bash
curl -LO https://github.com/anonimidin/terminatedshell/raw/main/terminatedshell && \
chmod +x terminatedshell functions/* && ./terminatedshell || echo -e "\n[x] Something went wrong\n";
```

- **Using wget**

``` bash
wget https://github.com/anonimidin/terminatedshell/raw/main/terminatedshell -O terminatedshell && \
chmod +x terminatedshell functions/* && ./terminatedshell || echo -e "\n[x] Something went wrong\n";
```

- **Using git**

``` bash
git clone https://github.com/anonimidin/terminatedshell.git && cd terminatedshell && \
chmod +x terminatedshell functions/* && ./terminatedshell || echo -e "\n[x] Something went wrong\n"; 
```

- **Compile static script via shc**

```bash
bash ./static/terminatedshell-compiler.sh terminatedshell-bin 
```

## [ ADDING YOUR IDEAS ] ##

We welcome your **creative ideas** and **contributions** to the development of the **Terminated Shell** project! If you have **suggestions**, **improvements**, or **new features**, please share them with us. Together, we can make this tool even better.


**- Create an Issue:**

- Go to the [Issues](https://github.com/anonimidin/terminatedshell/issues) section and create a new issue.
- Describe your **idea**, **proposal**, or **problem** you are facing.

**- Fork the Repository:**

- If you have programming skills and want to make changes yourself, fork the repository, make your changes, and submit a pull request to `new-feature`  branch.

**- Code Style:**

- Follow the existing **code style** used in the project.
- Consistent coding style makes it easier for everyone to understand and maintain the codebase.

## [ LICENSE ] ##

This project is under license from **Apache License 2.0**. For more details, see the [LICENSE](LICENSE.md) file.

Made by <a href="https://medium.com/@anonimidin" target="_blank">ANONIMIDIN</a> for red teamers.