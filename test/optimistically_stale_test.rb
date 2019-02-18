require "test_helper"

class OptimisticallyStaleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::OptimisticallyStale::VERSION
  end
end
