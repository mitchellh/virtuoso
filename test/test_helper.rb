require "test/unit/assertions"
require "protest"
require "mocha"
require "virtuoso"

class Protest::TestCase
  include Test::Unit::Assertions
  include Mocha::API

  # Get Mocha integrated properly into the tests
  alias :original_run :run
  def run(report)
    original_run(report)
    mocha_verify
  ensure
    mocha_teardown
  end

  # Returns a connection to a libvirt test hypervisor.
  def test_connection
    Libvirt.connect("test:///default")
  end

  # Returns a domain object from the libvirt test hypervisor.
  def test_domain
    test_connection.domains.first
  end
end

Protest.report_with(:progress)
