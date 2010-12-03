module Virtuoso
  module API
    # Base class specifying the API that all VMs within a hypervisor must
    # conform to.
    class VM
      # The libvirt connection instance.
      attr_reader :connection

      # The disk image to use as the main boot drive.
      attr_accessor :disk_image

      # Initializes a VM with the given libvirt connection.
      def initialize(connection)
        @connection = connection
      end

      # Saves the VM.
      def save; end
    end
  end
end
