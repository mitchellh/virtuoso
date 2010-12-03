require 'libvirt'

module Virtuoso
  # The various supported hypervisors. Lazy loaded.
  autoload :VirtualBox, "virtuoso/virtualbox"

  # Holds all the "abstract" classes for specifying and documenting
  # the Virtuoso API.
  module API
    autoload :Hypervisor, "virtuoso/api/hypervisor"
    autoload :VM, "virtuoso/api/vm"
  end

  # Connects to a hypervisor given by the URL to a libvirt instance,
  # and returns the proper hypervisor class based on the connection.
  def self.connect(url=nil)
    mapping = { "VBOX" => :VirtualBox }
    conn = Libvirt.connect(url)
    # TODO: Handle connections which we don't support yet
    const_get(mapping[conn.hypervisor]).const_get(:Hypervisor).new(conn)
  end
end
