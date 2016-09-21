
require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/economic_profile'
require './lib/district_repository'
require './lib/economic_profile_repository'

class EconomicProfileRepositoryTest < Minitest::Test

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

  def test_head_count_is_a_class
    headcount = EconomicProfileRepository.new

    assert_equal EconomicProfileRepository, headcount.class
  end

  def test_can_make_an_instance_of_economic_profile
    row = {:location => "dummy_location"}
    assert_instance_of EconomicProfile, @economic_profile_repository.generator(row)
  end

  def test_can_iterate_through_all_csv_to_make_all_economic_profiles
    assert_equal 181, @economic_profile_repository.economic_profiles.count
  end

  def test_can_populate_median_house_hold_income
    economic_profiles = @economic_profile_repository.economic_profiles.values
    assert economic_profiles.all? do |profile|
      profile.median_household_income.nil?
    end
     row = {location: "COLORADO", dataformat: "test", timeframe: "0000-1111", data: "999.9" }

    expected ={[2005, 2009]=>56222.0, [2006, 2010]=>56456.0, [2008, 2012]=>58244.0, [2007, 2011]=>57685.0, [2009, 2013]=>58433.0, [0, 1111]=>999.9}

    assert_equal expected, @economic_profile_repository.median_maker(row, "median_household_income")
  end

  def test_can_populate_children_in_poverty
    economic_profiles = @economic_profile_repository.economic_profiles.values
    assert economic_profiles.all? do |profile|
      profile.children_in_poverty.nil?
    end
    row = {location:"ACADEMY 20", timeframe:"2016", dataformat:"percent", data:"0.0009"}
    expected ={1995=>0.032, 1997=>0.035, 1999=>0.032, 2000=>0.031, 2001=>0.029, 2002=>0.033, 2003=>0.037, 2004=>0.034, 2005=>0.042, 2006=>0.036, 2007=>0.039, 2008=>0.04404, 2009=>0.047, 2010=>0.05754, 2011=>0.059, 2012=>0.064, 2013=>0.048, 2016=>0.0009}

    assert_equal expected, @economic_profile_repository.children_maker(row, "children_in_poverty")
  end

  def test_can_populate_free_or_reduce_lunch
    economic_profiles = @economic_profile_repository.economic_profiles.values
    assert economic_profiles.all? do |profile|
      profile.free_or_reduced_price_lunch.nil?
    end

    row = {location:"Colorado", poverty_level:"Eligible for Free or Reduced Lunch", timeframe:"2020", dataformat:"Percent", data:"a milli"}
    expected = {2000=>{:percentage=>0.27, :total=>195149.0}, 2001=>{:total=>204299.0, :percentage=>0.27528}, 2002=>{:percentage=>0.28509, :total=>214349.0}, 2003=>{:total=>228710.0, :percentage=>0.3}, 2004=>{:percentage=>0.3152, :total=>241619.0}, 2005=>{:total=>259673.0, :percentage=>0.3326}, 2006=>{:percentage=>0.337, :total=>267590.0}, 2007=>{:total=>275560.0, :percentage=>0.34}, 2008=>{:percentage=>0.3536, :total=>289404.0}, 2013=>{:total=>367980.0, :percentage=>0.41959}, 2009=>{:percentage=>0.3838, :total=>319428.0}, 2010=>{:total=>336443.0, :percentage=>0.399}, 2011=>{:percentage=>0.4085, :total=>348930.0}, 2012=>{:total=>358899.0, :percentage=>0.416}, 2014=>{:percentage=>0.41593, :total=>369760.0}, 2020=>{:percentage=>0.0}}
    economic_profile = @economic_profile_repository.find_by_name("COLORADO")

    @economic_profile_repository.lunch_maker(row, "free_or_reduced_price_lunch")

    assert_equal expected, economic_profile.free_or_reduced_price_lunch
  end

  def test_can_populate_title
    economic_profiles = @economic_profile_repository.economic_profiles.values
    assert economic_profiles.all? do |profile|
      profile.title_i.nil?
    end

    row = {location:"Colorado", poverty_level:"Eligible for Free or Reduced Lunch", timeframe:"2020", dataformat:"Percent", data:"a milli"}
    expected = {2009=>0.216, 2011=>0.224, 2012=>0.22907, 2013=>0.23178, 2014=>0.23556, 2020=>0.0}
    economic_profile = @economic_profile_repository.find_by_name("COLORADO")

    @economic_profile_repository.title_maker(row, "title_i")

    assert_equal expected, economic_profile.title_i
  end
end
