<h1 align="center">Terminated Shell</h1>
<div align="center" id="top"> 
  <img src="./.github/banner.png" alt="Terminatedshell" />

  &#xa0;

  <!-- <a href="https://terminatedshell.netlify.app">Demo</a> -->
</div>

<p align="center">
  <img alt="License" src="https://img.shields.io/github/license/anonimidin/terminatedshell?color=000000"/>
  <img alt="Github forks" src="https://img.shields.io/github/forks/anonimidin/terminatedshell?color=000000" /> 
  <img alt="Github stars" src="https://img.shields.io/github/stars/anonimidin/terminatedshell?color=000000" />
</p>

<hr> 

<p align="center">
  <a href="#dart-about">About</a> &#xa0; | &#xa0; 
  <a href="#sparkles-features">Features</a> &#xa0; | &#xa0;
  <a href="#white_check_mark-requirements">Requirements</a> &#xa0; | &#xa0;
  <a href="#checkered_flag-starting">Starting</a> &#xa0; | &#xa0;
  <a href="#memo-license">License</a> &#xa0; | &#xa0;
  <a href="https://github.com/anonimidin" target="_blank">Author</a>
</p>

<h4 align="center"> 
	🚧  Beta verison 0.1  🚧
</h4> 

## :dart: About ##

Terminated Shell script – a tool crafted for Linux persistence. Dive into the Linux underworld and unleash your control!

## Disclaimer ##

Use this script responsibly and for <b>EDUCATIONAL PURPOSES</b> only. The script author and contributors are not responsible for any misuse or damage caused by its use.
Keep persisting in the Linux realm, and may your shells be ever terminated if u use this script for bad purpose! 💀🐧

## :sparkles: About ##

**Global Variables:**

- `current_shell`: Stores the current shell of the user.
- `random`: Generates a random number, used in various places.

**Function: priv_check:**

- Checks whether the script is running with superuser (root) privileges.
- If not running as root, asks the user whether to continue without superuser privileges.

**Function: sched_persis:**

- Handles scheduler persistence, allowing the user to choose between at and cron.
- Provides options to configure persistence with custom IP, port, and payload.
- Checks for the existence of the `at` command and installs it if necessary.

**Function: shell_persis:**

- Handles shell configuration persistence by adding a custom command to the user's .bashrc or .zshrc file.

**Function: manage_users:**

- Provides options to view all users, add a user, or delete a user.
- Checks for superuser privileges before executing user management tasks.

**Function: hooks:**

- Provides options for Git hooks and Apt-get hooks.
- For Git hooks, it allows the user to choose a repository and add a custom payload to the pre-commit hook or the Git config file.
- For Apt-get hooks, it allows the user to add a custom payload to the pre-invoke command.

**Function: system_deamon:**

- Compares system and user systemd unit paths.
- Allows the user to add a custom systemd service, either at the system level (with root privileges) or user level.

**Function: motd:**

- Allows the user to add a custom payload to the MOTD file.

**Main Menu: menu:**

- Displays a banner with options for various tasks.
- Invokes the corresponding function based on the user's choice.

**User Management:**

- View, add, or delete users. Elevate your control with superuser privileges.

## :white_check_mark: Requirements ##

Before starting, ensure you have the necessary packages installed:

```bash
sudo apt-get update -y && sudo apt-get install at socat systemd shred cron coreutils -y && sudo apt autoremove -y && \
echo -e "\n[+] All requirements has been installed \n" || echo -e "\n[x] Something went wrong.\n";
```
## :checkered_flag: Starting ##

Choose your preferred one-liner to download and run the script:

- **Using curl**

``` bash
curl -LO https://github.com/anonimidin/terminatedshell/raw/main/terminatedshell.sh && \
chmod +x terminatedshell.sh && ./terminatedshell.sh || echo -e "\n[x] Something went wrong\n";
```

- **Using wget**

``` bash
wget https://github.com/anonimidin/terminatedshell/raw/main/terminatedshell.sh -O terminatedshell.sh && \
chmod +x terminatedshell.sh && ./terminatedshell.sh || echo -e "\n[x] Something went wrong\n";
```

- **Using git**
``` bash
git clone https://github.com/anonimidin/terminatedshell.git && cd terminatedshell && \
chmod +x terminatedshell.sh && ./terminatedshell.sh || echo -e "\n[x] Something went wrong\n"; 
```
- **Download via wget, install shc & compile via shc (SU privileges required)**
```bash
wget https://github.com/anonimidin/terminatedshell/raw/main/terminatedshell.sh -O terminatedshell.sh && chmod +x terminatedshell.sh && \
wget https://github.com/neurobin/shc/archive/refs/tags/4.0.3.tar.gz && tar -xvzf 4.0.3.tar.gz && cd shc-4.0.3 && ./configure && make && sudo make install && \
cd - && shc -U -f terminatedshell.sh -o terminatedshell || echo -e "\n[x] Something went wrong\n"
```
## :memo: License ##

This project is under license from Apache License 2.0. For more details, see the [LICENSE](LICENSE.md) file.

## Adding Your Ideas ## 

We welcome your creative ideas and contributions to the development of the Terminated Shell project! If you have suggestions, improvements, or new features, please share them with us. Together, we can make this tool even better.

## How to Propose an Idea

**Create an Issue:** 
- Go to the [Issues](https://github.com/anonimidin/terminatedshell/issues) section and create a new issue. 
- Describe your idea, proposal, or problem you are facing.

**Fork the Repository:** 
- If you have programming skills and want to make changes yourself, fork the repository, make your changes, and submit a pull request to **new-feature** branch.

**Code Style:**
- Follow the existing code style and conventions used in the project.
- Consistent coding style makes it easier for everyone to understand and maintain the codebase.

**Share Your Experience:** 
- If you have experience using Terminated Shell and have noticed something that can be improved, feel free to share your thoughts.

Together, we are creating a powerful tool for Linux and ensuring its continuous improvement.


Made by <a href="https://github.com/anonimidin" target="_blank">Anonimidin </a> for red teamers.
<a href="#top">Back to top</a>
