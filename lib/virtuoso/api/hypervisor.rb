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
    end
  end
end
