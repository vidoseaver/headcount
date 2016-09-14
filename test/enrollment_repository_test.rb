require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

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
      assert_equal ({2007=>0.39465}) , enrollment_repository.find_by_name("COLORADO").kindergarten_enrollment_percentage

      enrollment_repository.add_data_to_enrollment({location:"Colorado", timeframe:"2008", dataformat:"Percent", data:"0.005"})

      assert_equal ({2007=>0.39465, 2008 =>0.005}) , enrollment_repository.find_by_name("COLORADO").kindergarten_enrollment_percentage


  end
end
