require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/district_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @district_repo = DistrictRepository.new
    @district_repo.load_data({enrollment:
      {:kindergarten => "./data/Kindergartners in full-day program.csv",
       :high_school_graduation => "./data/High school graduation rates.csv"}})
    @enrollment_repository = @district_repo.enrollment_repository
  end

  def test_that_destrict_repo_is_a_class
    enrollment_repository= EnrollmentRepository.new

    assert_equal EnrollmentRepository, enrollment_repository.class
  end

  def test_load_data_can_load_file_and_contain_an_instance_of_enrollment
      enrollment = @enrollment_repository.find_by_name("ACADEMY 20")
      assert_equal "ACADEMY 20", enrollment.name
  end

  def test_can_add_data_to_enrollment_with_out_over_writting
      assertion = {2007=>0.39465, 2006=>0.33677, 2005=>0.27807, 2004=>0.24014, 2008=>0.5357, 2009=>0.598, 2010=>0.64019, 2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118}
      assert_equal (assertion), @enrollment_repository.find_by_name("COLORADO").kindergarten_enrollment_percentage

  end

  def test_can_add_data_to_high_school_enrollment
    enrollment = @enrollment_repository.find_by_name("academy 20")
    assertion =  {2010=>0.895, 2011=>0.895, 2012=>0.88983, 2013=>0.91373, 2014=>0.898}

    assert_equal assertion, enrollment.high_school_graduation

    assertion_with_new_timeframe_added = {2010=>0.895, 2011=>0.895, 2012=>0.88983, 2013=>0.91373, 2014=>0.898, 2000 => 1}
    @enrollment_repository.add_data_to_high_school_enrollment({location:"academy 20", timeframe:2000, dataformat:"Percent", data:1})

    assert_equal assertion_with_new_timeframe_added, enrollment.high_school_graduation
  end

  def test_high_school_graduation_percentage_is_populated
    enrollments = @enrollment_repository.enrollments.values

     assert enrollments.any? do |enrollment|
       enrollment.high_school_graduation.nil?
     end
  end
end
