require 'libvirt'

module Virtuoso
  autoload :Error, "virtuoso/error"
  autoload :VirtualBox, "virtuoso/virtualbox"
  autoload :Kvm, 'virtuoso/kvm'

  # Holds all the "abstract" classes for specifying and documenting
  # the Virtuoso API.
  module API
    autoload :Hypervisor, "virtuoso/api/hypervisor"
    autoload :VM, "virtuoso/api/vm"
  end

  # Connects to a hypervisor given by the URL to a libvirt instance,
  # and returns the proper hypervisor class based on the connection.
  def self.connect(url=nil)
    mapping = { "VBOX" => :VirtualBox, 'KVM' => :Kvm }
    conn = Libvirt.connect(url)
    raise Error::UnsupportedHypervisorError, "Unsupported hypervisor: #{conn.hypervisor}" if !mapping[conn.hypervisor]
    const_get(mapping[conn.hypervisor]).const_get(:Hypervisor).new(conn)
  end
end
