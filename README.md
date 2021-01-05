# How to set up openEASE

This is a small guide on how to currently set up openEASE, which will walk you through the steps necessary to install the separate components.

Requirements:

- Debian Ubuntu 18.04 LTS
- git
- docker ver. 19.03.13, build 4484c46d9d
- docker-compose

Side note: Newer docker versions might work too, though we currently cannot guarantee that.

## Table of Contents

- [Set up the Workspace](#set-up-the-workspace)
- [Running the App](#runnin-the-app)
- [Workspace Update-Script](#workspace-update-script)
- [Useful stuff](#useful-stuff)
- [Possible Errors, Troubleshooting, etc.](#possible-errors-troubleshooting-etc)
  - [Postgres Insertion Error](#postgres-insertion-error)
  - [Setting up the HTTPS-Certificate](#setting-up-the-https-certificate)

## Set up the Workspace

1. **Setting up your system**: As of now, `openEASE` **only** runs on Debian Ubuntu 18.04. Make sure to have `git`,`docker`, and `docker-compose` installed as well (pay attention to the version; see the requirements above).

2. **Cloning the necessary repositories**: Create a workspace folder somewhere and clone the following three repositories into it:

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

3. **Cloning the `node modules`**: This step is a bit cumbersome, but make sure to do it correctly! Inside the `openease` directory, we need to create a folder structure, which looks like this (read the following explanations, before proceeding):

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

4. **Building the Docker Containers**: Open a terminal and follow the steps:

    - `openease` container: Change to `<parent dir>/openease` and run `docker build -t openease/app .`
    - `knowrob` container: First, with an editor of your choice, open the `dockerfile` in `<parent dir>/knowrob/docker`, and change line 85 to:

        ``` dockerfile
        git clone https://github.com/daniel86/knowrob.git && \
        ```

        Then, in your terminal change to `<parent dir>/knowrob/docker` and run `docker build -t openease/knowrob .`
    - `openease-dockerbridge` container: Change to `<parent dir>/openease-dockerbridge` and run `docker build -t openease/dockerbridge .`

    Side note: The `openease` and `knowrob` container will take some time to finish building. To save time, you can run the three builds in different terminals.

## Running the App

After everything is set up and you have built all the necessary containers from our repositories, open a terminal and change to the directory of your `openease` repository. Then run `docker-compose up`. If everything runs smoothly, you can access the app via `localhost` in your webbrowser.
Running `docker-compose down` in a separate terminal will shut down the application. Alternatively press `CTRL` + `C` and then you can run the command in the same terminal.

To use the app, you will need to create an account or alternatively request the admin login from your supervisor(s). In order to access the Neem-Hub, one needs to enter the access credentials in the NEEM-Hub settings. Please request Neem configurations from your supervisor(s) or researchers at IAI-Bremen.

## Workspace Update-Script

We provide an update script, so users do not need to manually update all the parts of the software. The script can update all the repositories which we cloned and build all the containers from the previous chapter. To use the script, do the following:

1. Make sure your `git config` has the right username and e-mail (either locally or globally). You can check this in your terminal with:

    ``` shell
    git config [--global] user.name
    git config [--global] user.email
    ```

    (You only need the global flag, if you want to check your global `git config`. If you enter it, omit the square brackets.)

    If you do not how to set up your `git config`, check out this [page from atlassian](https://support.atlassian.com/bitbucket-cloud/docs/configure-your-dvcs-username-for-commits/).

2. Save the [update script](https://github.com/navidJadid/openease-setup/blob/main/update-openease.sh) somewhere on your system

3. Open the script with an editor of your choice, and edit the paths to the repositories.

    If you set up your repositories according to our guide, you just need to change the following path:

    ``` shell
    OPENEASE_ROOT=<path to the parent directory of the repositories>
    ```

    Otherwise change the following paths:

    ``` shell
    OPENEASE_ROOT=<path to the parent directory of the openease repository>
    [...]
    KNOWROB=<path to the knowrob repository>
    DOCKERBRIDGE=<path to the openease-dockerbridge repository>
    ```

4. You can run the script with `bash <location of the script>/update-openease.sh` together with any of the following option flags:

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
