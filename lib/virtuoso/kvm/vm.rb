module Virtuoso
  module Kvm
    # Kvm VM.
    class VM < API::VM
      def initialize(*args)
        @networks = []
        super
      end

      def network(type, options = nil)
        raise Error::UnsupportedNetworkError if ![:nat, :bridge].include?(type)

        model = type == :bridge ? 'e1000' : 'virtio'

        @networks << {:type => type, :model => model}.merge(options || {})
      end

      def spec
        d = super

        @networks.each do |network|
          net = Libvirt::Spec::Device.get(:interface).new
          net.model_type = network[:model]
          net.mac_address = network[:mac_address]

          if network[:type] == :bridge
            net.type = :bridge
            net.source_bridge = network[:bridge]
          else
            net.type = :user
          end

          d.devices << net
        end

        d
      end

      def reload
        spec = super

        @networks = []
        spec.devices.find_all { |d| d.is_a?(Libvirt::Spec::Device::Interface) }.each do |network|
          if network.type == :user
            # NAT
            network(:nat, :model => network.model_type, :mac_address => network.mac_address)
          elsif network.type == :bridge
            # Bridge
            network(:bridge, :model => network.model_type, :mac_address => network.mac_address,
                   :bridge => network.source_bridge)
        end
      end

      protected

      def new_spec
        # Setup the basic settings for the VM
        Libvirt::Spec::Domain.new.tap do |d|
          d.hypervisor = :kvm
          d.vcpu = 1
          d.features = [:acpi, :apic, :pae]
          d.clock.offset = :umt
          d.os.type = :hvm
          d.os.arch = :i386
          d.os.boot = [:hd]

          d.devices << new_disk_ide
        end
      end
    end
  end
end
