module Virtuoso
  module API
    # Base class specifying the API that all VMs within a hypervisor must
    # conform to.
    class VM
      # The libvirt connection instance.
      attr_reader :connection

      # The libvirt domain object (for existing VMs).
      attr_reader :domain

      # The name of the VM.
      attr_accessor :name

      # The memory for the VM.
      attr_accessor :memory

      # The disk image to use as the main boot drive.
      attr_accessor :disk_image

      # Initializes a VM with the given libvirt connection.
      def initialize(connection, domain=nil)
        @connection = connection
        @domain = domain
        reload if domain
      end

      # Saves the VM.
      def save; end

      # Destroys the VM, deleting any information about it. This will not
      # destroy any disk images, nor will it stop the VM if it is running.
      def destroy; end

      # Reloads information from about a VM which exists. Since Virtuoso
      # can't enforce any sort of VM locking, it is possible a VM changes
      # in the background by some other process while it is being modified.
      # In that case, when you attempt to save, your changes will either
      # overwrite the previous settings, or fail altogether (if someone else
      # destroyed the VM, for example). It is up to the developer to be
      # knowledgeable about his or her environment and account for this
      # accordingly. If you know that a VM changed, or you're just being
      # careful, {#reload} may be called to reload the data associated
      # with this VM and bring it up to date.
      def reload; end

      protected

      # A helper method for subclasses to mark methods which require an
      # existing VM to function (these are methods like `start` and `stop`).
      # This method will raise an {Error::NewVMError} if an existing VM
      # is not set.
      def requires_existing_vm
        raise Error::NewVMError if !domain
      end
    end
  end
end
