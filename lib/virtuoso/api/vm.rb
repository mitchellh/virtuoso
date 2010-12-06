module Virtuoso
  module API
    # Base class specifying the API that all VMs within a hypervisor must
    # conform to.
    class VM
      # The libvirt connection instance.
      attr_reader :connection

      # The libvirt domain object.
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

        # Set reasonable defaults for fields if we can
        @name = "My Virtuoso VM"
        @memory = 524288 # 512 MB

        # Load in the data from the domain if set
        reload if domain
      end

      # Returns the libvirt domain specification for the current domain.
      # If this VM represents an existing domain, then that spec will be
      # returned, otherwise a new spec will be returned.
      #
      # For hypervisor implementers: The `set_domain` method will cause
      # this spec to reset, please do not set `@domain` directly.
      #
      # @return [Libvirt::Spec::Domain]
      def domain_spec
        @domain_spec ||= domain ? domain.spec : Libvirt::Spec::Domain.new
      end

      # Returns the current state of the VM. This is expected to always
      # return the current, up-to-date state (therefore it is _not_ cached
      # and updated only on {#reload}). The state is meant to be returned
      # as a symbol.
      #
      # @return [Symbol]
      def state; end

      # Saves the VM. If the VM is new, this is expected to create it
      # initially, otherwise this is expected to update the existing
      # VM.
      def save; end

      # Destroys the VM, deleting any information about it. This will not
      # destroy any disk images, nor will it stop the VM if it is running.
      def destroy; end

      # Starts the VM.
      def start; end

      # Stops the VM.
      def stop; end

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

      # Resets the spec for this VM. If this object represents a new VM,
      # then the expected behavior is for this method to setup the spec
      # object as if it is new. If this object represents an existing VM,
      # then any changes to the spec should be discarded (since the last
      # save).
      def reset
        # Default behavior is to just reset the spec, which will do
        # the right thing most of the time.
        @domain_spec = nil
      end

      protected

      # A helper method for subclasses to mark methods which require an
      # existing VM to function (these are methods like `start` and `stop`).
      # This method will raise an {Error::NewVMError} if an existing VM
      # is not set.
      def requires_existing_vm
        raise Error::NewVMError if !domain
      end

      # A helper method for subclasses to set a domain object to represent
      # this VM. This properly sets up the object and reloads it for the
      # most up to date information.
      def set_domain(domain)
        @domain = domain
        @domain_spec = nil

        domain ? reload : reset
      end
    end
  end
end
