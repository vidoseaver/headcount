require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/result_set'
require './lib/result_entry'
require 'pry'

class ResultSetTest < Minitest::Test

  def setup
    @result_1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
        children_in_poverty_rate: 0.25,
        high_school_graduation_rate: 0.75})
    @result_2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
        children_in_poverty_rate: 0.2,
        high_school_graduation_rate: 0.6})

    @result_set = ResultSet.new(matching_districts: [@result_1], statewide_average: @result_2)
  end

  def test_results_entry_is_a_class
    assert_instance_of ResultSet, @result_set
  end

  def test_can_store_matching_districts
    assert_equal @result_1, @result_set.matching_districts.first
  end

  def test_can_store_statewide_avarage
    assert_equal @result_2, @result_set.statewide_average
  end

  def test_can_find_free_and_reduce_lunch_rate_of_the_matching_districts
    assert_equal 0.5, @result_set.matching_districts.first.free_and_reduced_price_lunch_rate
  end

  def test_can_find_child_in_poverty_rate_of_the_matching_districts
    assert_equal 0.25, @result_set.matching_districts.first.children_in_poverty_rate
  end

  def test_can_find_high_school_graduation_rate_of_the_matching_districts
    assert_equal 0.75, @result_set.matching_districts.first.high_school_graduation_rate
  end

  def test_can_find_free_and_reduce_lunch_rate_of_the_statewide_average
    assert_equal 0.3, @result_set.statewide_average.free_and_reduced_price_lunch_rate
  end

  def test_can_find_child_in_poverty_rate_of_the_statewide_average
    assert_equal 0.2, @result_set.statewide_average.children_in_poverty_rate
  end

  def test_can_find_high_school_graduation_rate_of_the_statewide_average
    assert_equal 0.6, @result_set.statewide_average.high_school_graduation_rate
  end
end
