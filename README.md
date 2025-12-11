[![Gem Version](https://badge.fury.io/rb/teuton-server.svg)](https://badge.fury.io/rb/teuton-server)

# Teuton Server

[Teuton Software](https://github.com/teuton-software/teuton) is an infrastructure test application, that is installed into host called T-NODE. T-NODE user monitorize remote S-NODE users machines using [Teuton Software](https://github.com/teuton-software/teuton).

When a S-NODE user wants to be tested, must wait until T-NODE user launch manually Teuton test units.

But with TeutonServer, T-NODE host listen to evaluation requests from S-NODE hosts directly.

## Installation

* `gem install teuton-server`, to install TeutonServer.

> Ensure [Teuton Software (version => 2.1)](https://github.com/teuton-software/teuton) is installed too.

## Running

1. `teuton-server init`, create default configuration server file.
1. `teuton-server`, runs Teuton Server.

## Documentation

* [Installation](docs/installation.md)
* [Start TeutonServer](docs/start.md)
* [Configuration file](docs/configfile.md)
