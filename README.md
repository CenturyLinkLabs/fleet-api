fleet-api
=========

[![Gem Version](https://badge.fury.io/rb/fleet-api.svg)](http://badge.fury.io/rb/fleet-api)
[![Build Status](https://api.shippable.com/projects/53f3a91a5491229d0207e4d9/badge/master)](https://www.shippable.com/projects/53f3a91a5491229d0207e4d9)

Provides a Ruby wrapper around the CoreOS Fleet API.

The client allows programmatic access to most of the *fleetctl* commands including the ability to load, start, stop, unload and destroy unit files.

At this point, there is no official Fleet API (though one is [in the works](https://github.com/coreos/fleet/blob/master/Documentation/api-v1-alpha.md)) so this library mimcs the behavior of the *fleetctl* command line tool and simply writes data to the [etcd]() key-value-store. The Fleet daemon reads data out of specific keys in etcd and processes it as appropiate.

As work on the actual Fleet API progresses, this library will be refactored to use the real API.

An alternative implementation is available in the [cloudspace/ruby-fleetctl](https://github.com/cloudspace/ruby-fleetctl) gem. The *ruby-fleetctl* gem takes a different approach and uses SSH to interact directly with the *fleetctl* binary to send commands. Our approach of writing directly to etcd cuts out the *fleetctl* middleman but is in more danger of being broken by future releases since we're effectively using a "private API".

The current version of the *fleet-api* gem is known to work with version 0.6.0 of Fleet.

### Installation

Install the gem directly:

    gem install fleet-api

Alternatively, add this line to your application's Gemfile:

    gem 'fleet-api', require: 'fleet'


### Usage

Configure the URL for the etcd API:

    require 'fleet'

    Fleet.configure do |fleet|
      fleet.fleet_api_url = 'http://10.1.42.1:4001'
    end

If you don't provide an explicit value for the `.fleet_api_url` attribute, it will default to using the value of the `FLEETCTL_ENDPOINT` environment variable.

**Note: since this Fleet API is not yet available in the stable version of CoreOS, the URL value provided must be the endpoint for the etcd API.**

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
	
#### Loading a Unit File

Equivalent of `fleetctl load`:

	service = {
	  'Unit' => {
	    'Description' => 'Useless infinite loop'
	  },
	  'Service' => {
	    'ExecStart' => "/bin/bash -c \"while true; do sleep 1; done\""
	  }
	}
	
	client = Fleet.new
	client.load('forever.service', service)
	
Note that the name you pass-in as the first parameter to the `.load` method should end in ".service"

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
    
#### Retrieving Service Status

Equivalent of `fleetctl status`:

    client = Fleet.new
    client.status('forever.service')
