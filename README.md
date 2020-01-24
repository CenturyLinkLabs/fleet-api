## NOTE

This repo is no longer being maintained. Users are welcome to fork it, but we make no warranty of its functionality.

fleet-api
=========

[![Gem Version](https://badge.fury.io/rb/fleet-api.svg)](http://badge.fury.io/rb/fleet-api)
[![Circle CI](https://circleci.com/gh/CenturyLinkLabs/fleet-api.svg?style=svg)](https://circleci.com/gh/CenturyLinkLabs/fleet-api)

Provides a Ruby wrapper around the CoreOS Fleet API.

The client allows programmatic access to most of the *fleetctl* commands including the ability to load, start, stop, unload and destroy unit files.

**Important Note:** As of version 1.0.0, this gem is now using the official Fleet REST API. Previous versions of this gem communicated with Fleet by reading/writing directly from/to the etcd key-value store. While this approach was functional, it was extremely brittle due to the fact that we were essentially using a private API. Now that the Fleet API has hit version 1.0 and is presumably stable it makes more sense to leverage the official API.

Users migrating from an older version of the Gem will simply need to make sure they configure it with the Fleet API endpoint instead of the etcd API endpoint.

### Installation

Install the gem directly:

    gem install fleet-api

Alternatively, add this line to your application's Gemfile:

    gem 'fleet-api', require: 'fleet'


### Usage

Configure the URL for the Fleet API:

    require 'fleet'

    Fleet.configure do |fleet|
      fleet.fleet_api_url = 'http://10.1.42.1:49153'
    end

If you don't provide an explicit value for the `.fleet_api_url` attribute, it will default to using the value of the `FLEETCTL_ENDPOINT` environment variable (if present) or the socket at `unix:///var/run/fleet.sock`.


#### Service Definitions

When submitting a service definition to the `Fleet::Client` you must convert your [unit file](http://www.freedesktop.org/software/systemd/man/systemd.unit.html) into a Ruby hash. Each section in the unit file is represented as a key/value pair in the hash where the key is the name of the section and the value is another hash containing all the statements for that section.

For example, look at the following unit file.

	[Unit]
	Description=Useless infinite loop
	
	[Service]
	ExecStart=/bin/bash -c "while true; do sleep 1; done"

This unit file would be represented as the following Ruby hash.
	
	{
	  'Unit' => {
	    'Description' => 'Useless infinite loop'
	  },
	  'Service' => {
	    'ExecStart' => "/bin/bash -c \"while true; do sleep 1; done\""
	  }
	}

If you need mutiple values for a single statement (like multiple `ExecStart` instructions) you can use an array of strings:

    {
      'Unit' => {
        'Description' => 'Useless infinite loop'
      },
      'Service' => {
        'ExecStart' => ["/bin/bash -c \"while true; do sleep 1; done\"", "some other command"]
      }
    }
	
#### Submitting a Unit File

Equivalent of `fleetctl submit`:

	service = {
	  'Unit' => {
	    'Description' => 'Useless infinite loop'
	  },
	  'Service' => {
	    'ExecStart' => "/bin/bash -c \"while true; do sleep 1; done\""
	  }
	}
	
	client = Fleet.new
	client.submit('forever.service', service)
	
Note that the name you pass-in as the first parameter to the `.submit` method should end in ".service"

#### Loading a Unit File

Equivalent of `fleetctl load`:

	client = Fleet.new
	client.load('forever.service')

#### Starting a Service

Equivalent of `fleetctl start`:

    client = Fleet.new
    client.start('forever.service')
    
#### Stopping a Service

Equivalent of `fleetctl stop`:

    client = Fleet.new
    client.stop('forever.service')

#### Unloading a Unit File

Equivalent of `fleetctl unload`:

    client = Fleet.new
    client.unload('forever.service')
    
#### Destroying a Service

Equivalent of `fleetctl destroy`:

    client = Fleet.new
    client.destroy('forever.service')
    
#### Listing Services

Equivalent of `fleetctl list-units`:

    client = Fleet.new
    client.list

#### Retrieving Service Status

Equivalent of `fleetctl status`:

    client = Fleet.new
    client.get_unit_state('forever.service')

Retrieves current status of a unit file:

    client = Fleet.new
    client.status('forever.service')

#### Retrieving a Unit File

Retrieves contents and current state of a unit file:

    client = Fleet.new
    client.get_unit_file('foo.service')

