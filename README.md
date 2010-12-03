# Virtuoso

Virtuoso is a Ruby library that provides dead simple virtual machine
management across many hypervisors, using the powerful [libvirt](http://libvirt.org)
library underneath. Libvirt is an extremely powerful library, and the
focus of Virtuoso is to provide an extremely simple, common API for
managing virtual machines at the cost of sacrificing some of libvirt's
power.

Currently supported hypervisors:

  - VirtualBox

Since Virtuoso is built on top of [libvirt](http://libvirt.org), it isn't
too difficult to add support for another hypervisor. The reason a libvirt-supported
hypervisor may not be supportd by Virtuoso at this time is most likely
because I don't have experience using that hypervisor. Open an issue if
you'd like to see support for another hypervisor.

## Installation

The library is packaged as a gem:

    gem install virtuoso

Additionally, you may need to install libvirt, the C-library used to
interface with the various hypervisors. On OS X the recommended way is
using [homebrew](http://github.com/mxcl/homebrew):

    brew install libvirt

If you're on linux, your package manager should contain a compatible
version of libvirt.

## Usage

Below is an example of starting a VM with VirtualBox. All drivers (for
different hypervisors) are required to conform to the same API, so the
usage is the same for all other hypervisors.

    require 'virtuoso'

    # Connect to a libvirt instance. Virtuoso instantiates the proper
    # hypervisor.
    hypervisor = Virtuoso.connect("vbox:///session")

    # Create a new VM within the hypervisor and start it
    vm = hypervisor.new_vm
    vm.name = "My Virtuoso VM"
    vm.disk_image = "/home/mitchellh/lucid.vmdk"
    vm.save
    vm.start
