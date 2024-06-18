# A4VAI Unit Test Container Deployment Utilities

[![en](https://img.shields.io/badge/lang-en-red.svg)](./README.md)
[![kr](https://img.shields.io/badge/lang-kr-blue.svg)](./README-KR.md)

- **This repository contains resources for deploying the A4VAI unit test containers.**
    - The container can be used to test assets/scripts exclusive for one "module" of the A4VAI project.
- **The resources are provided in the form of scripts and documentation.**
    - The scrips are provided under `scripts` directory.
    - The module-exclusive documentation is provided under each module directory.

## Quick Start

- Clone this repository to your local machine.
    - You must use `git clone` command. Make sure not to download the repository as a zip file.
    - You might need [kestr31/A4VAI-Env-Setup](https://github.com/kestr31/A4VAI-Env-Setup) creating directory structure required for the deployment.
    - You can still manually create the workspace directory structure by your own.

```bash
git clone https://github.com/kestr31/A4VAI-Test-Container.git
```

- For example of deploying `AirSim` unit test container, use following command:

```bash
cd A4VAI-Test-Container
# MANUALLY CREATE THE WORKSPACE DIRECTORY STRUCTURE IF YOU DIDN'T USE A4VAI-Env-Setup
mkdir -p ${HOME}/Documents/A4VAI-Workspace/Documents/A4VAI-Env-Setup/airsim_ws
# DEPLOY THE AIRSIM BINARY CONTAINER WITH DEBUG MODE
./scripts/run.sh airsim debug
# CONNECT TO THE CONTAINER
docker exec -it airsim-binary bash
```

- For stopping the container, use following command:

```bash
./scripts/stop.sh airsim
```

- To "reset" the repository, use following command:
    - Newly created files ans directories will stay as they are.
    - You can choose module to perform the reset.

```bash
./scripts/reset.sh airsim
```

- To "clean" the repository, use following command:
    - All newly created files and directories will be removed.
    - You can choose module to perform the clean.

```bash
./scripts/clean.sh airsim
```

## List of Scripts

- `run.sh`
    - Use case: `./scripts/run.sh <module> <option>`
    - Deploy the container with the specified module and option.
- `stop.sh`
    - Use case: `./scripts/stop.sh <module>`
    - Stop the container with the specified module.
- `reset.sh`
    - Use case: `./scripts/reset.sh <module>`
    - Reset the repository with the specified module.
    - Newly created files and directories will stay as they are.
- `clean.sh`
    - Use case: `./scripts/clean.sh <module>`
    - Clean the repository with the specified module.
    - All newly created files and directories will be removed.

## License

- This repository is licensed under the MIT License.

---
