require 'libvirt'

module Virtuoso
  autoload :Driver, "virtuoso/driver"
  autoload :VirtualBox, "virtuoso/virtualbox"

  # Creates a new Virtuoso VM instance for the given hypervisor.
  #
  # @param [Symbol] hypervisor
  # @return [Object]
  def self.new(hypervisor)
    mapping = { :virtualbox => :VirtualBox }
    const_get(mapping[hypervisor]).new
  end
end
