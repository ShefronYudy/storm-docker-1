storm-docker
============

This repository makes it easy to run **distributed, multiple server**
(multiple Zookeeper, multiple Storm Supervisor)
[Storm](http://storm.incubator.apache.org/) topologies within
[Docker](https://www.docker.io/).

## System Requirements

- GNU Make
- Docker
- python 2.7.x
- virtualenv

## Software Setup

### Python setup

We will be making use of [virtualenv](http://virtualenv.readthedocs.org/en/latest/)
for some of the Python scripts in this repository. We also make use of the
[PyYAML](http://pyyaml.org/) library, and that requires some Python header
files.

On a Ubuntu-like system:

    sudo apt-get install python-virtualenv
    sudo apt-get install python-dev

### Install Docker

For Ubuntu Precise 12.04 (LTS), ensure that your Linux Kernel is a relatively
recent version (check the docs here:
http://docs.docker.io/installation/ubuntulinux/ for more information).

Use the following command from the top of the script at http://get.docker.io
to install Docker

    wget -qO- https://get.docker.io/ | bash

Verify your Docker installation:

    docker info

### Cloning this repository

Clone this repository, preferrably to `$HOME/workspace/storm-docker`.
At `$HOME/workspace`:

    git clone git@github.com:viki-org/storm-docker.git

The next few commands will be run from the `storm-docker` repository. Let us
go there:

    cd storm-docker

## Configuration

### Configuring the Storm setup

**NOTE:** This step is **critical** to the correct functioning of the Storm
topology.

Copy the sample configuration files to concrete configuration files (this does
not overwrite any existing concrete configuration files):

    ./copy-sample-config.sh

Carry on by editing the following concrete configuration files:

- `config/storm-setup.yaml`
- `config/cluster.xml`
- `config/zoo.cfg`

Documentation is available in the copied concrete configuration files, except
the `config/cluster.xml` file used for logback configuration. For that, we
highly recommend reading
[The logback manual](http://logback.qos.ch/manual/).

Once done with your edits, we can continue with building the Docker images.

### Building the Docker images

**NOTE:** This step is necessary after making changes to **any** of the
configuration files in the above subsection.

Run the **GNU** `make` command. The default goal builds the Docker images:

    make

If this is the first time the Docker images are being built, this script will
take some time to complete.

## Running the Storm components

### Run the Docker containers

To run all Docker containers for this repository on your current machine:

    ./start-storm.sh

You should not see any errors if configuration is done correctly.

For more information on running individual containers, run:

    ./start-storm.sh --help

## Stopping Docker containers

To stop all running Docker containers for this repository:

    ./destroy-storm.sh

To stop individual containers, supply them as arguments to the
`destroy-storm.sh` script, for instance to stop the `ui` and `zookeeper`
containers:

    ./destroy-storm.sh ui zookeeper

## Other configuration

### On Storm's Logging Configuration

Storm 0.9.x makes use of [slf4j](http://www.slf4j.org/) as the abstract logger
and [logback](http://logback.qos.ch/) as the concrete logger.

**NOTE:** Whether storm-docker uses the `storm/cluster.xml` file as the actual
logging configuration file is just a guess, but one I'm relatively confident of
being correct.

When you build the Docker containers (steps are detailed below), the
`storm/cluster.xml` configuration file will be used as the `cluster.xml` file
for Storm. This happens to be the configuration file for logback, so you may
want to review it and change the logging configuration settings.

Additional documentation on logback can be found here:

- [http://logback.qos.ch/manual/index.html](http://logback.qos.ch/manual/index.html)
- [http://logback.qos.ch/documentation.html](http://logback.qos.ch/documentation.html)

## Credits

This repository was originally based on
[wurstmeister/storm-docker](https://github.com/wurstmeister/storm-docker);
big thanks to wurstmeister for making his project open source.
