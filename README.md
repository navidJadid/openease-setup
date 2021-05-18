# How to set up openEASE

This is a small guide on how to currently set up openEASE, which will walk you through the steps necessary to install the separate components.

Requirements:

- Debian Ubuntu 18.04 LTS
- git
- docker ver. 19.03.13, build 4484c46d9d
- docker-compose 1.25.4

Side note: Newer `docker` and `docker-compose` versions might work too, though we currently cannot guarantee that. If you are successful in getting it to run on newer versions, please let us know about your experiences or consider contributing to this repository via Pull-Request.

## Table of Contents

- [Set up the Workspace](#set-up-the-workspace)
- [Running the App](#running-the-app)
- [Workspace Update-Script](#workspace-update-script)
- [Useful stuff](#useful-stuff)
- [Possible Errors, Troubleshooting, etc.](#possible-errors-troubleshooting-etc)
  - [Postgres Insertion Error](#postgres-insertion-error)
  - [Setting up the HTTPS-Certificate](#setting-up-the-https-certificate)

## Set up the Workspace

1. **Setting up your system**: As of now, `openEASE` **only** runs on Debian Ubuntu 18.04. Make sure to have `git`, `docker`, and `docker-compose` installed as well (pay attention to the version; see the requirements above).

2. **Cloning the necessary repositories**: There are two ways to clone the necessary repositories, which is either to do it manually, or by using our install-script.

    2.1. **Using the install-script**

    First, clone this repository or save the [install-script `install.sh`](https://github.com/navidJadid/openease-setup/blob/main/install.sh) together with the [configuration `config.sh`](https://github.com/navidJadid/openease-setup/blob/main/config.sh) in the same directory somewhere on your system. Cloning the repository has the benefit that you also save the [update-script `update.sh`](https://github.com/navidJadid/openease-setup/blob/main/update.sh) into the same directory already, meaning you can later execute it without further setup.

    By default, the script would install `openEase` into `~/Documents/openease_workspace`. However, if you want to change the installation location, then open the script with an editor of your choice, and edit the following path:

    ``` shell
    OPENEASE_ROOT_DIR=<path to the parent directory of the repositories>
    ```

    Normally, the script would clone the `openease`, `knowrob` and `dockerbridge` repositories into the same parent directory, but if you instead want them to end upin different locations, then change the following paths:

    ``` shell
    OPENEASE_PARENT_DIR=<path to the openease repository>
    [...]
    KNOWROB_PARENT_DIR=<path to the knowrob repository>
    [...]
    DOCKERBRIDGE_PARENT_DIR=<path to the openease-dockerbridge repository>
    ```

    If you want to change the folder names the modules will be installed into, you can adjust the following variables:

    ``` shell
    # folder names for the modules
    [...]
    OPENEASE="openease"             # openease webapp-container
    [...]
    KNOWROB="knowrob"               # knowrob-container
    DOCKERBRIDGE="dockerbridge"     # dockerbridge-container
    ```

    It is also possible to change the target repositories, if, for example, you want to clone a fork, instead of the original repository. For that you can replace any of the following with the HTTPS to your git-fork:

    ``` shell
    OPENEASE_REPO="https://github.com/ease-crc/openease.git"
    CANVAS_THREE_REPO="https://github.com/ease-crc/openease_threejs.git"
    CHARTS_REPO="https://github.com/ease-crc/openease_d3.git"
    ROS_CLIENTS_REPO="https://github.com/ease-crc/ros-js-clients.git"
    ROSPROLOG_REPO="https://github.com/ease-crc/rosprolog-js-console.git"
    KNOWROB_REPO="https://github.com/daniel86/knowrob.git"
    DOCKERBRIDGE_REPO="https://github.com/ease-crc/openease_dockerbridge.git"
    ```

    Lastly, make sure your `git config` has the right username and e-mail (either locally or globally). You can check this in your terminal with:

    ``` shell
    git config [--global] user.name
    git config [--global] user.email
    ```

    You only need the global flag, if you want to check your global `git config`. If you enter it, omit the square brackets. If you do not how to set up your `git config`, check out this [page from atlassian](https://support.atlassian.com/bitbucket-cloud/docs/configure-your-dvcs-username-for-commits/).

    **IMPORTANT**: If you don't have a global `git-config`, you have to make sure to create the target parent directories **before** executing the script and set up the local `git-config` (otherwise the script cannot clone the repositories due to lacking credentials).

    Finally, open a terminal and execute `bash <location of the script>/install.sh`. Check the console output and folder structures to see if everything installed properly. The intended folder structure (for the default installation) should be:

    ``` system
        <workspace directory>
        └─ openease
        └─ knowrob
        └─ openease-dockerbridge
    ```

    And inside the openease-directory:

    ``` system
        node_modules/
        └── @openease
            ├── canvas-three
            ├── charts
            ├── ros-clients
            └── rosprolog-console
                └── node_modules
                    └── @openease
                        └── ros-clients
    ```

    2.2. **Cloning everything manually**

    - First, create a workspace folder somewhere and clone the following three repositories into it:

        - `openease`: <https://github.com/ease-crc/openease>
        - `knowrob`: <https://github.com/daniel86/knowrob>
        - `openease-dockerbridge`: <https://github.com/ease-crc/openease_dockerbridge>

        The directory structure should then look something like this:

        ``` system
        <workspace directory>
        └─ openease
        └─ knowrob
        └─ openease-dockerbridge
        ```

        (It is of course also possible to put them in separate places, but this guide will assume they share the same parent directory.)

    - Next, we need to clone the `node modules`. This step is a bit cumbersome, but make sure to do it correctly! Inside the `openease` directory, we need to create a folder structure, which looks like this (read the following explanations, before proceeding):

        ``` system
        node_modules/
        └── @openease
            ├── canvas-three
            ├── charts
            ├── ros-clients
            └── rosprolog-console
                └── node_modules
                    └── @openease
                        └── ros-clients
        ```

        All the directories inside `@openease` are repositories that need to be cloned. The repositories for the necessary modules are the following:

        - `canvas-three`: <https://github.com/ease-crc/openease_threejs.git>
        - `charts`: <https://github.com/ease-crc/openease_d3.git>
        - `ros-clients`: <https://github.com/ease-crc/ros-js-clients>
        - `rosprolog-console`: <https://github.com/ease-crc/rosprolog-js-console>

        It is important to clone them into the mentioned directory and then change their directory name to match the structure above. **DO NOT** create a folder structure as above and then clone the repositories inside them. Lastly, the `ros-client` really needs to appear twice.

3. **Building the Docker Containers**: Open a terminal and follow the steps.

    - `openease` container: Change to `<parent dir>/openease` and run `docker build -t openease/app .`
    - `knowrob` container: First, with an editor of your choice, open the `dockerfile` in `<parent dir>/knowrob/docker`, and change line 85 to:

        ``` dockerfile
        git clone https://github.com/daniel86/knowrob.git && \
        ```

        Then, in your terminal change to `<parent dir>/knowrob/docker` and run `docker build -t openease/knowrob .`
    - `openease-dockerbridge` container: Change to `<parent dir>/openease-dockerbridge` and run `docker build -t openease/dockerbridge .`

    Alternatively, it is possible to build the containers with the update-script by passing the `-b` flag (s. [Workspace Update-Script](#workspace-update-script)). Make sure to follow the given steps, before executing the script.

    Side note: The `openease` and `knowrob` container will take some time to finish building. To save time, you can run the three builds in different terminals.

## Running the App

After everything is set up and you have built all the necessary containers from our repositories, open a terminal and change to the directory of your `openease` repository. Then run `docker-compose up`. If everything runs smoothly, you can access the app via `localhost` in your webbrowser.
Running `docker-compose down` in a separate terminal will shut down the application. Alternatively press `CTRL` + `C` and then you can run the command in the same terminal.

To use the app, you will need to create an account or alternatively request the admin login from your supervisor(s). In order to access the Neem-Hub, one needs to enter the access credentials in the NEEM-Hub settings. Please request Neem configurations from your supervisor(s) or researchers at IAI-Bremen.

## Workspace Update-Script

We provide an update script, so users do not need to manually update all the parts of the software. The script can update all the repositories which we cloned and build all the containers from the previous chapter. To use the script, do the following:

1. Again, make sure your `git config` has the right username and e-mail (either locally or globally). You can check this in your terminal with:

    ``` shell
    git config [--global] user.name
    git config [--global] user.email
    ```

    You only need the global flag if you want to check your global `git config`. If you enter it, omit the square brackets. If you do not how to set up your `git config`, check out this [page from atlassian](https://support.atlassian.com/bitbucket-cloud/docs/configure-your-dvcs-username-for-commits/).

2. If you have already cloned this repository according to point 2.1 in the section [Set up the Workspace](#set-up-the-workspace), then you can skip to point 3. Otherwise, save the [update-script](https://github.com/navidJadid/openease-setup/blob/main/update.sh) together with the [configuration `config.sh`](https://github.com/navidJadid/openease-setup/blob/main/config.sh) in the same directory somewhere on your system.

3. If you used the install script and already set up your workspace according to point 2.1 in the section [Set up the Workspace](#set-up-the-workspace), then you are good to go can skip to point 4. If instead, you cloned the repositories manually, open `config.sh` with an editor of your choice, and edit the paths to the repositories. 

    First, if `openease`, `knowrob`, and `dockerbridge` all have the same parent directory, only change the following variable:

    ``` shell
    OPENEASE_ROOT_DIR=<path to the parent directory of the repositories>
    ```

    Otherwise change the following paths:

    ``` shell
    OPENEASE_PARENT_DIR=<path to the openease repository>
    [...]
    KNOWROB_PARENT_DIR=<path to the knowrob repository>
    [...]
    DOCKERBRIDGE_PARENT_DIR=<path to the openease-dockerbridge repository>
    ```

    It might also be useful to check the variables for the folder names, to check if they are the same as your local folder names:

    ``` shell
    # folder names for the modules
    [...]
    OPENEASE="openease"             # openease webapp-container
    [...]
    KNOWROB="knowrob"               # knowrob-container
    DOCKERBRIDGE="dockerbridge"     # dockerbridge-container
    ```

4. You can run the script with `bash <location of the script>/update.sh` together with any of the following option flags:

    ``` shell
    -h: will display help information
    -u: will update all the repositories
    -b: will build all the containers
    ```

A few remarks on how the script works:

- If executed without any option flags, the script will try to update the repositories and then build the containers. This is equivalent to running the script with both the `-u` and `-b` flags, except that the user will be prompted to confirm the actions.
- The order of the flags generally doesn't matter, i.e., if the update and build flag are passed together, then the update is always executed before the build.
- If `-h` is used with other flags, it will take priority and disable the other flags' functionalities.

## Useful Stuff

You can add these utility functions to your `.bashrc`, to have access to them from anywhere.

``` bashrc
function docker-remove-with-images() {
   docker rm $(docker ps -a -q)
   docker rmi $(docker images -q)
}
function docker-stop-and-remove() {
   docker kill $(docker ps -q)
   docker rm $(docker ps -a -q)
   docker kill $(docker ps -a -q)
}

export -f docker-remove-with-images
export -f docker-stop-and-remove
```

You can open `.bashrc` with, for example, `nano <path to .bashrc-file>/.bashrc`. Go to the end of the file and add the code snippet from above. Then enter the exit command (usually `CTRL` + `X`) and confirm to save the changes to the same file. Lastly either log out and back in, or just type the following command `source <path to .bashrc-file>/.bashrc`.

You can then type the following commands into your terminal:

- `docker-remove-with-images`: removes all docker containers and images
- `docker-stop-and-remove`: stops all containers and removes all the containers

<!-- markdownlint-disable-next-line MD026 -->
## Possible Errors, Troubleshooting, etc.

### Postgres Insertion Error

If you see something like this:

``` bash
postgres        | ERROR:  column ... does not exist at character ...
```

then you might need to remove your volumes. Execute the following three commands in your terminal:

``` bash
docker-compose down
docker-stop-and-remove (all containers)
docker volume rm $(docker volume ls -q)
```

**WARNING**: The third command removes all volumes, even from other projects. If you need to preserve those, then you can instead use either `docker volume prune` (removes only volumes not used by any container), or list your volumes with `docker volume ls` and use `docker volume rm <VOLUME NAME>`.

### Setting up the HTTPS-Certificate

To set up the https cert, in your terminal execute the following two commands:

``` bash
cd <YOUR WORKSPACE>/openease/certs/
./gencert.sh
```

You can also see the [docs](http://knowrob.org/doc/docker#setting_up_websocket_authentication).
