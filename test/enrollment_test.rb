require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment'
require './lib/district_repository'


class EnrollmentTest < Minitest::Test
  def setup
    @enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation =>
      {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
      @district_repo = DistrictRepository.new
      @district_repo.load_data({
                        :enrollment        => { :kindergarten => "./data/Kindergartners in full-day program.csv",
                                                :high_school_graduation => "./data/High school graduation rates.csv"},
                        :statewide_testing => { :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                                :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                                :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                                :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})
      @enrollment_repository = @district_repo.enrollment_repository
  end


  def test_kindergarten_participation_by_year
      expected = {2010=>0.3915, 2011=>0.35356, 2012=>0.2677}
      assert_equal expected, @enrollment.kindergarten_participation_by_year
  end

  def test_kindergarten_participation_in_year_returns_nil_if_year_doesnt_exist
      assert_equal nil, @enrollment.kindergarten_participation_in_year(1991)
  end

  def test_kindergarten_participation_in_year_returns_specified_year
    assert_equal 0.391, @enrollment.kindergarten_participation_in_year(2010)
  end

  def test_wtm_takes_make_number_into_percentage_by_thousanths
    assert_equal 0.391, @enrollment.wtm(0.3915)
    assert_equal 0.39,  @enrollment.wtm(0.390)
    assert_equal 1, @enrollment.wtm(1)
  end

  def test_can_calculate_kindergarten_participation_rate
    enrollment = @enrollment_repository.find_by_name("ACADEMY 20")
    assert_equal 0.406, enrollment.kindergarten_participation_rate_average
  end

  def test_enrollment_graduation_rate_by_year
    enrollment = @enrollment_repository.find_by_name("ACADEMY 20")
    expected = {2010=>0.895, 2011=>0.895, 2012=>0.889, 2013=>0.913, 2014=>0.898}
    assert_equal expected, enrollment.graduation_rate_by_year
  end

  def test_graduation_rates_by_year
    enrollment = @enrollment_repository.find_by_name("ACADEMY 20")

    assert_equal nil, enrollment. graduation_rate_in_year(2020)
    assert_equal 0.895, enrollment.graduation_rate_in_year(2010)
  end

  def test_graduation_rates_averages
    enrollment = @enrollment_repository.find_by_name("ACADEMY 20")
    assert_equal 0.898, enrollment.high_school_graduation_rate_average
  end
end
