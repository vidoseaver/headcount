require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require './lib/district_repository'

class EconomicProfileTest < Minitest::Test

  def setup
    @district_repository = DistrictRepository.new
    @district_repository.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
    @economic_profile_repository = @district_repository.economic_profile_repository
  end

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

  def test_returns_unknown_data_error_if_year_does_not_exisit
    profile = @economic_profile_repository.find_by_name("ACADEMY 20")

    assert_raises UnknownDataError do
      profile.median_household_income_in_year(2016)
    end
  end

  def test_knows_median_house_hold_income_in_a_year
    profile = @economic_profile_repository.find_by_name("ACADEMY 20")

    assert_equal 89784.0, profile.median_household_income_in_year(2012)
  end

  def test_can_test_household_income_average
    profile = @economic_profile_repository.find_by_name("ACADEMY 20")

    assert_equal 87635.4, profile.median_household_income_average
  end

  def test_can_childen_in_poverty_in_year
    profile = @economic_profile_repository.find_by_name("ACADEMY 20")

    assert_equal 0.064, profile.children_in_poverty_in_year(2012)
  end

  def test_know_free_or_reduced_price_lunch_percentage_in_year
    profile = @economic_profile_repository.find_by_name("ACADEMY 20")

    assert_equal 0.113, profile.free_or_reduced_price_lunch_percentage_in_year(2010)
  end

  def test_free_or_reduced_price_lunch_number_in_year
    profile = @economic_profile_repository.find_by_name("ACADEMY 20")

    assert_equal 3006.0, profile.free_or_reduced_price_lunch_number_in_year(2012)
  end

  def test_knows_title_i_by_year
    profile = @economic_profile_repository.find_by_name("ACADEMY 20")

    assert_equal 0.01072, profile.title_i_in_year(2012)
  end

end
