require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'
require './lib/economic_profile'
require './lib/district_repository'
require "pry"

class DistrictTest < Minitest::Test

  def setup
      @district_repo ||= DistrictRepository.new
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
  end

  def test_that_destrict_repo_is_a_class
    a = District.new({:name => "ACADEMY 20"})

    assert_equal District, a.class
  end

  def test_name_method_returns_upcase_district_name
    a = District.new({:name => "academy 20"})

    assert_equal "ACADEMY 20", a.name
  end

  def test_district_has_a_copy_of_its_parent
    district_repo = DistrictRepository.new
    district = District.new({:name => "academy 20"}, district_repo)

    assert_instance_of DistrictRepository, district.district_repository
  end

  def test_district_knows_about_its_enrollments
     district = @district_repo.find_by_name("COLORADO")
     assert_instance_of Enrollment, district.enrollment
     assert_equal "COLORADO", district.enrollment.name
  end

  def test_district_knows_about_its_statewide_tests
     district = @district_repo.find_by_name("COLORADO")
     assert_instance_of StatewideTest, district.statewide_test
     assert_equal "COLORADO", district.statewide_test.name
  end

  def test_district_knows_about_its_economic_profiles
     district = @district_repo.find_by_name("COLORADO")
     assert_instance_of EconomicProfile, district.economic_profile
     assert_equal "COLORADO", district.economic_profile.name
  end

  def test_enrollment_knows_kindergarten_particpation_by_year
    district = @district_repo.find_by_name("ACADEMY 20")
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end
end
