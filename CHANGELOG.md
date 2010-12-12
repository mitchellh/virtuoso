## 0.0.2 (unreleased)

Hypervisor Changes:

  - VirtualBox: Implemented `VM#network` for NAT networking.
  - VirtualBox: Headless support by setting option `:headless` to
    a truthy value.

General API changes:

  - Added `VM#network` method to add/enable networks.
  - Added `VM#set` method to set arbitrary key/value options
    allowing for extensions to the API without breaking between
    hypervisors.
  - Added `VM#spec` to get the libvirt XML for the domain, including
    all modifications.

## 0.0.1 (December 7, 2010)

  - Initial release

