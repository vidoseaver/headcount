require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @district_repo = DistrictRepository.new
    @district_repo.load_data({enrollment: {kindergarten: "./data/Kindergartners in full-day program.csv"}})
    @enrollment_repository = @district_repo.enrollment_repository
  end

  def test_that_destrict_repo_is_a_class
    enrollment_repository= EnrollmentRepository.new

    assert_equal EnrollmentRepository, enrollment_repository.class
  end

  def test_load_data_can_load_file_and_contain_an_instance_of_enrollment
    enrollment_repository = EnrollmentRepository.new
    enrollment_repository.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })

      enrollment = enrollment_repository.find_by_name("ACADEMY 20")
      assert_equal "ACADEMY 20", enrollment.name
  end

  def test_can_add_data_to_enrollment_with_out_over_writting

    enrollment_repository = EnrollmentRepository.new
    enrollment_repository.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
        }
      })
      assertion = {2007=>0.39465, 2006=>0.33677, 2005=>0.27807, 2004=>0.24014, 2008=>0.5357, 2009=>0.598, 2010=>0.64019, 2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118}
      assert_equal (assertion), enrollment_repository.find_by_name("COLORADO").kindergarten_enrollment_percentage

  end


end
