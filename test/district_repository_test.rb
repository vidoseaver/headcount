require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/district'


class DistrictRepositoryTest < Minitest::Test
  def setup
    @district_repo = DistrictRepository.new
    @district_repo.load_data({
                      enrollment: {
                      kindergarten: "./data/Kindergartners in full-day program.csv"}})
  end

  def test_that_that_district_repo_is_a_class
    assert_equal DistrictRepository, @district_repo.class
  end


  def test_can_load_csv_file_and_populate_district
    assert @district_repo.districts.values.all? {|district| district.is_a?(District)}
  end

  def test_search_districts_by_name_and_returns_instance_of_district
      assert_instance_of District, @district_repo.find_by_name("ACADEMY 20")
      assert_equal "ACADEMY 20", @district_repo.find_by_name("ACADEMY 20").name
  end

  def test_find_all_matching_returns_empty_array_if_nothing_matches
      assert_equal [], @district_repo.find_all_matching("Sparta")
  end

  def test_find_all_matching_returns_aray_of_districts_containing_word_fragment
    districts = @district_repo.find_all_matching("rado")
    
    assert_equal true, districts.all? { |district| district.name.include?("RADO") }
  end

  def test_find_all_matching_distring_word_fragement
    assert_equal 2, @district_repo.find_all_matching("rado").count
  end

  def test_that_district_hash_is_not_empty_after_loaded_file
     refute @district_repo.districts.nil?
  end

end
