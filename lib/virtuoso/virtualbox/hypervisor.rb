module Virtuoso
  module VirtualBox
    # VirtualBox driver, allowing the control and management of
    # VirtualBox virtual machines.
    class Hypervisor < API::Hypervisor
      def new_vm
        VM.new(connection)
      end
    end
  end
end
