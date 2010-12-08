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

        # Set reasonable defaults for fields if we can
        @name = "My Virtuoso VM"
        @memory = 524288 # 512 MB

        # Load in the proper data
        set_domain(domain)
      end

      # Returns the domain spec representing this VM, along with any changes
      # made to the VM (such as changing the name). This allows interaction
      # on a lower level with libvirt.
      #
      # This spec is not cached, therefore any changes made to it won't be
      # reflected when {#save} is called. If you insist on using the spec
      # in this way, you must modify the spec and call the appropriate libvirt
      # library methods yourself.
      #
      # @return [Libvirt::Spec::Domain]
      def spec
        domain_spec
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

        reload if domain
      end

      # Returns the current domain's spec. This is expected to be used by
      # {#spec} to setup any modifications. This value is cached until {#set_domain}
      # is called.
      #
      # @return [Libvirt::Spec::Domain]
      def domain_spec
        domain ? domain.spec : new_spec
      end

      # Returns a domain spec for a new VM. This should be overridden by any
      # subclasses to customize what a new spec looks like.
      #
      # @return [Libvirt::Spec::Domain]
      def new_spec
        Libvirt::Spec::Domain.new
      end
    end
  end
end
