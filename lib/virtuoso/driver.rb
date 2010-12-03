module Virtuoso
  # Base class for a virtual machine driver. Every feature in this
  # driver must be overloaded by the drivers in one way or another.
  class Driver
    # The established libvirt connection object.
    attr_reader :connection

    # Specifies a main disk image to use as the primary boot disk
    # for the VM.
    attr_accessor :disk_image

    # Initialize a new driver. This sets up and establishes the connection
    # to libvirt based on the given settings.
    #
    # **Important:** Driver implementations which override initialize
    # _must_ call `super`, otherwise a connection will never be prepared.
    #
    # @param [String] url Libvirt URL to connect to.
    def initialize(url)
      @connection = Libvirt.connect(url)
    end

    # Creates the virtual machine based on the given options and
    # starts it.
    def create; end
  end
end
