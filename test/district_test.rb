require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'
require './lib/district_repository'
require "pry"

class DistrictTest < Minitest::Test

  def setup
      @district_repo = DistrictRepository.new
      @district_repo.load_data({enrollment: {kindergarten: "./data/Kindergartners in full-day program.csv"}})
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

  def test_enrollment_knows_kindergarten_particpation_by_year
    district = @district_repo.find_by_name("ACADEMY 20")
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end
end
