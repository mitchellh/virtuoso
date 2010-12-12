module Virtuoso
  module VirtualBox
    # VirtualBox VM.
    class VM < API::VM
      def initialize(*args)
        super

        @networks = []
      end

      def network(type, options=nil)
        raise Error::UnsupportedNetworkError if type != :nat

        @networks << { :type => :nat, :model => "82540EM" }.merge(options || {})
      end

      def spec
        # Basic settings
        d = domain_spec
        d.name = name
        d.memory = memory

        # Setup the main hard drive. A disk section must always exist and we
        # assume the first disk section is the main one.
        disk = d.devices.find { |d| d.is_a?(Libvirt::Spec::Device::Disk) }
        disk.source = disk_image

        # Networks
        @networks.each do |network|
          nat = Libvirt::Spec::Device.get(:interface).new
          nat.type = :user
          nat.mac_address = network[:mac_address] if network[:mac_address]
          nat.model_type = network[:model]
          d.devices << nat
        end

        # If we're running headless, attach the RDP device
        if options[:headless]
          rdp = Libvirt::Spec::Device.get(:graphics).new
          rdp.type = :rdp
          d.devices << rdp
        end

        d
      end

      def state
        domain ? domain.state : :new
      end

      def save
        # Get the spec, since if we undefine the domain later, we won't be
        # able to.
        definable = spec

        # To modify an existing domain, we actually undefine and redefine it.
        # We can't use `set_domain` here since that will clear the `domain`
        # pointer, which we need to get the proper domain spec.
        domain.undefine if domain

        # At this point, assuming the virtuoso settings are correct, we
        # should have a bootable VM spec, so define it and reload the VM
        # information.
        set_domain(connection.domains.define(definable))
      end

      def destroy
        requires_existing_vm
        domain.undefine
        set_domain(nil)
      end

      def start
        requires_existing_vm
        domain.start
      end

      def stop
        requires_existing_vm
        domain.stop
      end

      def reload
        # Load the main disk image path. We assume this is the first "disk"
        # device, though this assumption is probably pretty weak.
        spec = domain_spec
        disk = spec.devices.find { |d| d.is_a?(Libvirt::Spec::Device::Disk) }
        self.disk_image = disk.source

        # Load the basic attributes
        self.name = spec.name
        self.memory = spec.memory
      end

      protected

      def new_spec
        # Setup the basic settings for the VM
        d = Libvirt::Spec::Domain.new
        d.hypervisor = :vbox
        d.vcpu = 1
        d.features = [:acpi, :pae]
        d.clock.offset = :localtime
        d.os.type = :hvm
        d.os.arch = :i386
        d.os.boot = [:cdrom, :hd]

        # Attach a device for the main hard disk.
        disk = Libvirt::Spec::Device.get(:disk).new
        disk.type = :file
        disk.device = :disk
        disk.target_dev = :hda
        disk.target_bus = :ide
        d.devices << disk

        d
      end
    end
  end
end
