require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'

class DistrictRepositoryTest < Minitest::Test

  def test_that_destrict_repo_is_a_class
    a = District.new({:name => "ACADEMY 20"})

    assert_equal District, a.class
    end

  def test_name_method_returns_upcase_district_name
    a = District.new({:name => "academy 20"})

    assert_equal "ACADEMY 20", a.name
  end
end
