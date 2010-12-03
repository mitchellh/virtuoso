module Virtuoso
  module API
    # Base class specifying the API for all hypervisors. Every feature in
    # this base class must be overloaded by any hypervisors.
    class Hypervisor
      # The libvirt connection instance.
      attr_reader :connection

      # Initializes a hypervisor with the given libvirt connection. The
      # connection should be established through {Virtuoso.connect}, which
      # also chooses the correct hypervisor.
      def initialize(connection)
        @connection = connection
      end

      # Returns a new {VM} instance that can be used to create a new virtual
      # machine.
      #
      # @return [VM]
      def new_vm; end

      # Searches for a VM with the given ID and returns it if it finds it,
      # and otherwise returns nil. The exact semantics of the find are up to
      # the hypervisor but typically it searches by both name and UUID.
      #
      # @return [VM]
      def find(id); end
    end
  end
end
