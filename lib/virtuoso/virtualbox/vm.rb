module Virtuoso
  module VirtualBox
    # VirtualBox VM.
    class VM < API::VM
      def initialize(*args)
        @networks = []
        super
      end

      def network(type, options=nil)
        raise Error::UnsupportedNetworkError if ![:nat, :host_only].include?(type)

        if type == :nat
          @networks << { :type => :nat, :model => "82540EM" }.merge(options || {})
        else
          @networks << { :type => :host_only, :model => "82540EM", :network => "vboxnet0" }.merge(options || {})
        end
      end

      def spec
        d = super

        # Networks
        @networks.each do |network|
          if network[:type] == :nat
            # Configure the NAT device
            nat = Libvirt::Spec::Device.get(:interface).new
            nat.type = :user
            nat.mac_address = network[:mac_address] if network[:mac_address]
            nat.model_type = network[:model]
            d.devices << nat
          else
            # Configure the host only network
            net = Libvirt::Spec::Device.get(:interface).new
            net.type = :network
            net.model_type = network[:model]
            net.source_network = network[:network]
            d.devices << net
          end
        end

        # If we're running headless, attach the RDP device
        if options[:headless]
          rdp = Libvirt::Spec::Device.get(:graphics).new
          rdp.type = :rdp
          d.devices << rdp
        end

        d
      end

      def reload
        spec = super

        # Check to see if headless mode is enabled
        headless = spec.devices.find { |d| d.is_a?(Libvirt::Spec::Device::Graphics) && d.type == :rdp }
        set(:headless, headless)

        # Detect and load any networks
        @networks = []
        spec.devices.find_all { |d| d.is_a?(Libvirt::Spec::Device::Interface) }.each do |network|
          if network.type == :user
            # NAT
            network(:nat, :model => network.model_type, :mac_address => network.mac_address)
          elsif network.type == :network
            # Host only
            network(:host_only, :model => network.model_type, :network => network.source_network)
          end
        end
      end

      protected

      def new_spec
        # Setup the basic settings for the VM
        Libvirt::Spec::Domain.new.tap do |d|
          d.hypervisor = :vbox
          d.vcpu = 1
          d.features = [:acpi, :pae]
          d.clock.offset = :localtime
          d.os.type = :hvm
          d.os.arch = :i386
          d.os.boot = [:cdrom, :hd]

          # Attach a device for the main hard disk.
          d.devices << new_disk_ide
        end
      end
    end
  end
end
