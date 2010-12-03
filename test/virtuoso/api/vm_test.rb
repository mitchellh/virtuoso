require "test_helper"

Protest.describe("API::VM") do
  setup do
    @klass = Virtuoso::API::VM
  end

  context "requiring an existing VM" do
    setup do
      @impl = Class.new(@klass) do
        def save
          @domain = true
        end

        def start
          requires_existing_vm
        end
      end

      @instance = @impl.new(test_connection)
    end

    should "raise an exception if an existing VM is not set" do
      assert_raises(Virtuoso::Error::NewVMError) { @instance.start }
    end

    should "not raise an exception if an existing VM is set" do
      assert_nothing_raised {
        @instance.save
        @instance.start
      }
    end
  end
end
