require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require './lib/district_repository'

class EconomicProfileTest < Minitest::Test

  # def setup
  #   epr = EconomicProfileRepository.new
  #   epr.load_data({
  #     :economic_profile => {
  #       :median_household_income => "./data/Median household income.csv",
  #       :children_in_poverty => "./data/School-aged children in poverty.csv",
  #       :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
  #       :title_i => "./data/Title I students.csv"
  #     }
  #   })
  # end

  def test_economic_profile_is_a_class
    economic_profile = EconomicProfile.new("test", "parent")

    assert_equal EconomicProfile, economic_profile.class
  end

  def test_median_household_income_is_empty
    economic_profile = EconomicProfile.new("test", "parent")

    assert economic_profile.median_household_income.empty?
  end

  def test_children_in_poverty_is_empty
    economic_profile = EconomicProfile.new("test", "parent")

    assert economic_profile.children_in_poverty.empty?
  end

  def test_free_or_reduced_price_lunch_is_empty
    economic_profile = EconomicProfile.new("test", "parent")

    assert economic_profile.free_or_reduced_price_lunch.empty?
  end

  def test_title_is_empty
    economic_profile = EconomicProfile.new("test", "parent")

    assert economic_profile.title_i.empty?
  end
end
