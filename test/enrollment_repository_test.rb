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
      enrollment: {
        kindergarten: "./data/Kindergartners in full-day program.csv"
        }
      })

      enrollment = enrollment_repository.find_by_name("ACADEMY 20")
      assert_equal "ACADEMY 20", enrollment.name
  end
end
