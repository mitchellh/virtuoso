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
    context "defaults" do
      should "have a new domain spec by default" do
        instance = @klass.new(test_connection)
        assert instance.domain_spec
        assert instance.domain_spec.is_a?(Libvirt::Spec::Domain)
      end

      should "use the existing domain spec if a domain is given" do
        instance = @klass.new(test_connection, test_domain)
        assert_equal :test, instance.domain_spec.hypervisor
      end
    end

    context "reloading" do
      setup do
        @impl = Class.new(@klass) do
          def reload
            throw :reloaded, true
          end
        end
      end

      should "reload if a domain is given" do
        result = catch :reloaded do
          @impl.new(test_connection, test_domain)
          nil
        end

        assert result
      end

      should "not reload if a domain is not given" do
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

    should "be able to reset the domain spec" do
      @instance.domain_spec.name = "foo"
      assert_equal "foo", @instance.domain_spec.name
      @instance.reset
      assert_nil @instance.domain_spec.name
    end
  end
end
