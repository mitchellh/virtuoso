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

  context "initializing a VM" do
    context "reloading" do
      setup do
        @impl = Class.new(@klass) do
          def reload
            throw :reloaded, :reload
          end
        end
      end

      should "reload if a domain is given" do
        result = catch :reloaded do
          @impl.new(test_connection, test_domain)
          nil
        end

        assert_equal :reload, result
      end

      should "not load if a domain is not given" do
        result = catch :reloaded do
          @impl.new(test_connection)
          nil
        end

        assert !result
      end
    end
  end

  context "with a VM object" do
    setup do
      @instance = @klass.new(test_connection)
    end

    should "return a new spec object for a new VM" do
      assert_equal nil, @instance.spec.name
    end

    should "return the existing spec object for an existing VM" do
      @instance = @klass.new(test_connection, test_domain)
      assert_equal test_domain.spec.name, @instance.spec.name
    end
  end
end
