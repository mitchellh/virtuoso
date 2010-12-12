# Virtuoso User's Guide

## Overview

Virtuoso is a Ruby library that provides dead simple virtual machine
management across many hypervisors by using the powerful [libvirt](http://libvirt.org)
library underneath. Libvirt is an extremely powerful library, and the
focus of Virtuoso is to sacrifice much of this power in favor of an
extremely simple, uniform API for managing virtual machines.

**Warning:** Virtuoso's API should be considered unstable until version
1.0 or otherwise noted. This means that Virtuoso may make backwards-incompatible
API changes from version to version.

## Installation

### Gem Installation

The library itself is packaged as a gem, and as such is a straightfoward
install:

    gem install virtuoso

### Libvirt Dependency

If an `FFI::Libvirt::MissingLibError` exception is raised when
you try to load Virtuoso, then you need to install libvirt.

Installing libvirt varies from platform to platform.

#### Mac OS X

[Homebrew](http://github.com/mxcl/homebrew) is the recommended method of
installation of libvirt on Mac OS X:

    brew install libvirt

#### Linux

Your respective package manager should have a libvirt package available.
Please search your package manager repos for `libvirt`.

#### Windows

The libvirt team is currently working on providing libvirt for Windows
users, but it is not quite ready yet.

## Basic Usage

Virtuoso was designed from the beginning to have a uniform API for every
hypervisor, so once you learn the basic concepts of Virtuoso, then these
can be used for all hypervisors.

### Establishing a Connection

Before doing anything, a connection must be established to a hypervisor.
Connections are established using libvirt URLs. If you don't provide a
URL, then libvirt will try all hypervisors in an arbitrary order and
return the first successful connection made. A few examples of connecting
are shown below:

    # Detect a hypervisor and connect...
    conn = Virtuoso.connect

    # Connect specifically to VirtualBox locally
    conn = Virtuoso.connect("vbox:///session")

    # Connect to VirtualBox over SSH on a remote machine
    conn = Virtuoso.connect("vbox+ssh://10.0.0.1/session")

The resulting connection object will be a subclass of {Virtuoso::API::Hypervisor},
which specifies the common API all hypervisors must provide.

### Creating a new VM

#### Basic Settings

Now that there is a connection object available, creating a new VM is
a piece of cake. Call {Virtuoso::API::Hypervisor#new_vm #new_vm} on
the hypervisor object to get a new {Virtuoso::API::VM} object. This
VM object is what you will use to set the configuration and control
the VM on this hypervisor.

Below, a basic VM is created:

    vm = conn.new_vm
    vm.name = "My new VM"
    vm.memory = 512000
    vm.disk_image = "/path/to/hard_drive.vmdk"
    vm.save

That's it! A new VM will be created with the given settings (and
possibly some other sensible defaults).

#### Networking

Virtuoso has the ability to specify basic networks on VMs. Below,
a NAT network is created on the VM:

    vm.network(:nat, :mac_address => "01:23:45:67:89:ab")

This will create a NAT network with the given MAC address on the
interface.

**Note:** Not all hypervisors may support certain network types.
You should look at the hypervisor-specific documentation for more
information. But even if a specific network type is not supported,
the `network` method is required to be implemented, so the hypervisor
should give a reasonable error.

#### Other options, API extensions

A hypervisor may provide other features which simply don't exist
with others. An example is VirtualBox headless mode, which runs the
VM without a GUI. Since this is a feature fairly specific to VirtualBox,
it is implemented through an API-safe extension. This allows the
API to remain stable with other hypervisors, while allowing additional
options to be set which _may_ mean something to the current hypervisor.
An example is shown below:

    vm.set(:headless, true)

This tells VirtualBox to run in headless mode. If this were a KVM VM,
however, it would simply ignore the value, since it has no meaningful
semantics in that context. The important thing is that the API is stable
throughout.

### Controlling a VM

Once a VM is created, you can control it using basic methods:

    vm.start
    vm.stop
    vm.destroy

### Modifying an Existing VM

Virtuoso also has support for modifying existing VMs, with a _big asterisk_.
The fine print is that modifying a VM does not make promises on preserving
settings which can't be controlled by Virtuoso itself. If you are only modifying
VMs which Virtuoso created, then you should be fine. However, if you're
modifying VMs created another way (manually, through libvirt directly, etc.)
then Virtuoso makes no promises that when you call `save`, all settings will
be preserved.

To modify a VM, simply find it through the hypervisor object to get a reference
to a VM object:

    vm = conn.find("My new VM")
    vm.memory += 100000 # Increase RAM by ~100 MB
    vm.save
