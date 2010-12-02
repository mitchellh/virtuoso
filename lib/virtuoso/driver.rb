module Virtuoso
  # Base class for a virtual machine driver. Every feature in this
  # driver must be overloaded by the drivers in one way or another.
  class Driver
    # Specifies a main disk image to use as the primary boot disk
    # for the VM.
    attr_accessor :disk_image

    # Creates the virtual machine based on the given options and
    # starts it.
    def create; end
  end
end
