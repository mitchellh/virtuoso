module Virtuoso
  # Any exceptions which are thrown by Virtuoso (not lower-level libraries)
  # exist in this module.
  module Error
    class VirtuosoError < StandardError; end
    class NewVMError < VirtuosoError; end
  end
end
