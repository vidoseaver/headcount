require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/result_entry'
require './lib/result_set'
require 'pry'

class ResultEntryTest < Minitest::Test

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
    a = ResultEntry.new(dummy: 0.3)

    assert_instance_of ResultEntry, a
  end

  def test_it_populates_free_and_reduced_price_lunch_rate_when_it_initializes
     assert_equal 0.5, @result_1.free_and_reduced_price_lunch_rate
  end

  def test_it_populates_children_in_poverty_rate_when_it_initializes
     assert_equal 0.25, @result_1.children_in_poverty_rate
  end

  def test_it_populates_high_school_graduation_rate_when_it_initializes
     assert_equal 0.75, @result_1.high_school_graduation_rate
  end
end
