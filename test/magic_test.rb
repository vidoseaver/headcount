require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/magic'

class MagicTest < Minitest::Test
  include Magic
  def test_wtm_takes_make_number_into_percentage_by_thousanths
    assert_equal 0.391, wtm(0.3915)
    assert_equal 0.39,  wtm(0.390)
    assert_equal 1,     wtm(1)
  end
end
