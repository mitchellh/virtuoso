require "test_helper"

Protest.describe("Virtuoso") do
  setup do
    @klass = Virtuoso
  end

  context "connecting" do
    should "raise an exception if an unsupported hypervisor is connected to" do
      assert_raises(Virtuoso::Error::UnsupportedHypervisorError) {
        @klass.connect("test:///default")
      }
    end

    # TODO: To test other connections, hypervisor must be present... so we
    # can't guarantee and test that yet.
  end
end
