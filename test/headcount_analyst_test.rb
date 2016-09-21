require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/headcount_analyst'
require './lib/district_repository'
require './lib/result_entry'

require 'pry'


class HeadcountAnalystTest < Minitest::Test

  def setup
    @district_repo = DistrictRepository.new
    @district_repo.load_data({
                      :enrollment        => { :kindergarten => "./data/Kindergartners in full-day program.csv",
                                              :high_school_graduation => "./data/High school graduation rates.csv"},
                      :statewide_testing => { :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                              :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                              :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                              :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                              :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"},
                      :economic_profile => {
                                              :median_household_income => "./data/Median household income.csv",
                                              :children_in_poverty => "./data/School-aged children in poverty.csv",
                                              :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
                                              :title_i => "./data/Title I students.csv"}})
    @headcount_analyst = @district_repo.headcount_analyst
  end

  def test_head_count_is_a_class
    headcount = HeadcountAnalyst.new
    assert_equal HeadcountAnalyst, headcount.class
  end

  def test_can_find_district_by_name
    assert_instance_of District, @headcount_analyst.find_district_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", @headcount_analyst.find_district_by_name("academy 20").name
  end

  def test_compare_district_kindergarten_participation_rate_average_vs_all_of_colorado
    assert_equal 0.766, @headcount_analyst.kindergarten_participation_rate_variation("academy 20", :against => "COLORADO")
  end

  def test_compare_district_kindergarten_participation_rate_average_vs_another_district
    assert_equal 0.447, @headcount_analyst.kindergarten_participation_rate_variation("academy 20", :against => "yuma school district 1")
  end

  def test_compare_district_kindergarten_participation_rate_variation_trend_per_year
    expected = {2007=>0.992, 2006=>1.05, 2005=>0.961, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.689, 2013=>0.694, 2014=>0.661}
    assert_equal expected , @headcount_analyst.kindergarten_participation_rate_variation_trend("academy 20", :against => "COLORADO")
  end

  def test_year_comparer
    data_set_one = {2007=>0.39159, 2006=>0.35364, 2005=>0.26709, 2004=>0.30201, 2008=>0.38456, 2009=>0.39, 2010=>0.43628, 2011=>0.489, 2012=>0.47883, 2013=>0.48774, 2014=>0.49022}
    data_set_two = {2007=>0.39465, 2006=>0.33677, 2005=>0.27807, 2004=>0.24014, 2008=>0.5357, 2009=>0.598, 2010=>0.64019, 2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118}
    expected     = {2007=>0.992, 2006=>1.05, 2005=>0.961, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.689, 2013=>0.694, 2014=>0.661}
    assert_equal expected, @headcount_analyst.year_comparer(data_set_one, data_set_two)
  end

  def test_high_school_varation_rate_vs_state
    assert_equal 1.196, @headcount_analyst.high_school_rate_variation("academy 20", :against => "COLORADO")
  end

  def test_kindergarten_participation_vs_high_school_graduation
    assert_equal 0.6404682274247492, @headcount_analyst.kindergarten_participation_against_high_school_graduation("academy 20")
  end

  def test_if_numbers_fall_with_in_range
    refute @headcount_analyst.correlates?(1.6)
    assert @headcount_analyst.correlates?(1.0)
  end

  def test_kindergarten_participation_correlates_with_highschool_graduation
    assert @headcount_analyst.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
  end

  def test_kindergarten_correlates_with_highschool_graduation_state_wide
    refute @headcount_analyst.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end

  def test_kindergarten_participation_can_pass_high_school_particpation_an_array
    districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
    assert @headcount_analyst.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
  end

  def test_we_can_find_statewide_average_for_high_school_graduation_rate
      assert_equal 0.809, @headcount_analyst.average_highschool_graduation_rate
  end

  def test_we_can_find_statewide_average_for_children_in_poverty_graduation_rate
      assert_equal 0.163, @headcount_analyst.average_children_in_poverty_rate
  end

  def test_we_can_find_statewide_average_for_free_and_reduced_price_lunch_rate
      assert_equal 0.408, @headcount_analyst.free_and_reduced_price_lunch_rate
  end

  def tests_the_result_entry_maker_makes_result_entries
    data = {free_and_reduced_price_lunch_rate: 0.019, highschool_graduation_rate: 0.67, children_in_poverty_rate:0.23}
    assert_instance_of ResultEntry, @headcount_analyst.result_entry_maker(data)
    assert_equal 0.019, @headcount_analyst.result_entry_maker(data).free_and_reduced_price_lunch_rate
    assert_equal 0.67,  @headcount_analyst.result_entry_maker(data).highschool_graduation_rate
    assert_equal 0.23,  @headcount_analyst.result_entry_maker(data).children_in_poverty_rate
  end

  def test_we_can_make_entries_for_all_of_our_districts
    assert_equal 181, @headcount_analyst.high_poverty_and_high_school_graduation_result_entries.count
    assert @headcount_analyst.high_poverty_and_high_school_graduation_result_entries.all? {|result_entry| result_entry.is_a?(ResultEntry)}
  end


  def test_it_returns_an_array_of_only_the_result_entries_that_we_want
    assert_equal 38, @headcount_analyst.all_districts_with_high_poverty_and_graduation_rate.count
    average   = @headcount_analyst.statewide_average_result_entry_for_graduation_and_poverty
    ave_forlr = average.free_and_reduced_price_lunch_rate
    ave_cip   = average.children_in_poverty_rate
    ave_hgr   = average.high_school_graduation_rate
    all_result_entries = @headcount_analyst.all_districts_with_high_poverty_and_graduation_rate
    all_result_entries.all? do |result_entry|
      ((result_entry.free_and_reduced_price_lunch_rate > ave_forlr) &&
      (result_entry.children_in_poverty_rate          > ave_cip) &&
      (result_entry.high_school_graduation_rate       > ave_hgr))
    end
  end

  def result_test_maker_makes_an_instance_of_result_set
    assert_instance_of ResultSet, @headcount_analyst.result_set_maker(dummy: "thing")
  end

  def test_high_poverty_and_high_school_graduation
    assert_instance_of ResultSet, @headcount_analyst.high_poverty_and_high_school_graduation
  end

  def test_get_averages_of_median_house_hold_income_in_state
    assert_equal 57408.0, @headcount_analyst.statewide_average_median_house_hold_income
  end

  def test_we_can_make_a_result_entry_with_the_mhi_and_children_in_poverty
    result_entry = @headcount_analyst.statewide_average_result_entry_for_mhi_and_poverty

    assert result_entry.is_a?(ResultEntry)

    assert_equal 57408.0, result_entry.average_median_household_income
    assert_equal 0.163,    result_entry.children_in_poverty_rate
  end

  def test_number_of_districts_above_median_household_average_average
    assert_equal 2, @headcount_analyst.all_districts_with_high_cip_and_ami.count
  end

  def test_high_income_disparity_result_entry
    assert_instance_of ResultSet, @headcount_analyst.high_income_disparity
  end

  def test_median_income_variation_of_district_vs_state
    assert_equal 0.502, @headcount_analyst.kindergarten_participation_against_household_income("academy 20")
    assert_equal 1.088, @headcount_analyst.kindergarten_participation_against_household_income("ARCHULETA COUNTY 50 JT")
  end

  def test_check_kindergarden_participation_correlates_with_house_hold_income
    assert_equal false, @headcount_analyst.kindergarten_participation_correlates_with_household_income(for:"academy 20")
    assert_equal true, @headcount_analyst.kindergarten_participation_correlates_with_household_income(for:"COLORADO")

  end

  def test_check_percentage_of_districts_accorss_the_state_that_correllate_with_kindergarten_participation
    assert_equal false, @headcount_analyst.income_correlates_with_kindergarten(for:"academy 20")
  end

  def test_if_kindergarten_participation_correlates_with_household_income
    assert_equal false, @headcount_analyst.kindergarten_participation_correlates_with_household_income(:across => ['ACADEMY 20', 'YUMA SCHOOL DISTRICT 1', 'WILEY RE-13 JT', 'SPRINGFIELD RE-4'])
  end
end
