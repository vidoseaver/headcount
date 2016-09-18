require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require './lib/headcount_analyst'
require './lib/district_repository'
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
                                              :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})
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
    expected = {2007=>0.992, 2006=>1.05, 2005=>0.961, 2004=>1.258, 2008=>0.718, 2009=>0.652, 2010=>0.681, 2011=>0.728, 2012=>0.689, 2013=>0.694, 2014=>0.661}
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
end
