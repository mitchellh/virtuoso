module Virtuoso
  module VirtualBox
    # VirtualBox driver, allowing the control and management of
    # VirtualBox virtual machines.
    class Hypervisor < API::Hypervisor
      def new_vm
        VM.new(connection)
      end

      # Searches for a VM by name or UUID.
      #
      # @param [String] id Name or UUID
      # @return [VM]
      def find(id)
        result = connection.domains.find(id)
        return nil if !result
        VM.new(connection, result)
      end
    end
  end
end
