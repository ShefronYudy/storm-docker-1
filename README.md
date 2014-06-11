storm-docker
============

This repository is forked from https://github.com/wurstmeister/storm-docker
and contains some edits that are specific to running the
[storm-alerts](https://github.com/viki-org/storm-alerts) repository.

At Viki, we run the [Docker](https://www.docker.io/) images built from this
repository to obtain configured environments for the following components of the
[Storm 'alerts' topology](https://github.com/viki-org/storm-alerts):

- Zookeeper
- Nimbus
- Storm UI
- Storm Supervisor

By leveraging the power of [Docker](https://www.docker.io/) to create containers
on heterogeneous Linux servers and run on all of them as if they were
homogenous, the rather tedious process of:

- setting up Zookeeper
- setting up Nimbus
- setting up Storm UI
- setting up Storm Supervisor
- deploying storm-alerts and **hoping that everything will work**

is replaced by:

- setting up this repository (instructions are below; they are much less tedious
and error prone than manually setting up the individual components stated above.
Don't believe it? Read the Dockerfiles)
- deploying storm-alerts and **seeing that things are working** =)

## System Requirements

- **GNU** Make >= 3.8.2 (Required for .RECIPEPREFIX)
- Docker
- python 2.7.x
- virtualenv

## Setup for running storm-alerts within storm-docker

This section details the steps needed to setup the `storm-docker` repository
so it is ready for running the Storm topology in the
[storm-alerts](https://github.com/viki-org/storm-alerts) repository.

You should perform the following on the production server that you are going
to run [storm-alerts](https://github.com/viki-org/storm-alerts) on.

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

### Python setup

We will be making use of [virtualenv](http://virtualenv.readthedocs.org/en/latest/)
for running the Storm Supervisor Docker. We also make use of the
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

### Building the Docker images

Run the **GNU** `make` command (**NOTE:** Ensure that your version of GNU Make
is at least **3.8.2**, because we are using the `.RECIPEPREFIX` feature
available since that version). The default goal builds the Docker images:

    make

If this is the first time the Docker images are being built, this script will
take some time to complete.

### Configuring the Storm setup

**NOTE:** This step is **critical** to the correct functioning of the Storm
topology.

Copy the `storm-setup.yaml.sample` file in the `config` directory:

    cp config/storm-setup.yaml.sample config/storm-setup.yaml

And edit the `config/storm-setup.yaml` file. Documentation is available in
the `config/storm-setup.yaml.sample` file on how to fill up the file.

### Run the Docker containers

using the `start-storm.sh` script:

    ./start-storm.sh

And now the server is ready for running the
[storm-alerts](https://github.com/viki-org/storm-alerts) repository. Follow the
instructions [here](https://github.com/viki-org/storm-alerts) for setting up the
storm-alerts repository if you intend to deploy the storm-alerts topology to the
server you just did the above setup on.

## To stop the Docker containers

Take a look inside the `destroy-storm.sh` script if you only need to stop
specific Docker containers. This can probably be done using `docker stop` (or
`docker kill`).

If you wish to stop everything (or if you're lazy), run the `destroy-storm.sh`
script:

    ./destroy-storm.sh

Do not be alarmed by the `docker rm` commands in the script. Rebuilding the
Docker images after a `docker rm` is faster than running the `rebuild.sh` script
for the first time as results are being cached.

## FAQ - Debugging stuff to do with Docker containers

**NOTE:** This section is written from my memory (which tends to be vague) so it
may not be as accurate as the sections above. In fact, you should correct the
information here should you discover any mistakes.

#### Qn: storm-alerts has been running for some time but for some reason it went down. I do not see the storm-docker containers when I run `docker ps` . What's wrong?

**Answer:** Most likely your Docker containers were killed using `docker stop`
or `docker kill` (and perhaps followed by `docker rm`).
Do a `docker ps -a` and check if the containers are around. If the containers
are around, then they were most likely killed by `docker stop` or `docker kill`.
If you do not see the containers from the output of `docker ps -a`, most
probably they were removed using `docker rm`.

In any case, the simplest solution is to execute the `destroy-storm.sh` script
in this repository, followed by the `make` command to rebuild the Docker images,
then the `start-storm.sh` script (this might not work).

If that fails, seek help from someone, preferrably in the following order:

- someone who has directly worked on this repository
- someone who is experienced in Docker

Alternatively, you could go learn Docker yourself and figure things out.
The [official Docker documentation](http://docs.docker.io/) is **awesome** and
it'll take only one or two afternoons' worth of time to read them.
