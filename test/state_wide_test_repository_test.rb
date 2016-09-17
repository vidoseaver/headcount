require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/state_wide_test_repository'
require './lib/state_wide_test'
require 'pry'



class StateWideTestRepositoryTest < Minitest::Test

  def setup
    @state_wide_repo = StateWideTestingRepository.new
    @state_wide_repo.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

  end

  def test_test_state_wide_testing_repo_is_a_class
      a = StateWideTestingRepository.new

      assert_equal StateWideTestingRepository, a.class
  end

  def test_can_make_an_instanceof_state_wide_testings
    row = {:location => "dummy_location"}
    assert_instance_of StateWideTest, @state_wide_repo.state_wide_testing_maker(row)
  end

  def test_can_iterate_through_all_csv_to_make_all_state_wide_testings

    assert_equal 181, @state_wide_repo.state_wide_testings.count
  end

  def test_asserts_that_third_grade_data_is_empty
    state_wide_testings = @state_wide_repo.state_wide_testings.values
    assert state_wide_testings.all? do |state_wide_testing|
      state_wide_testing.third_grade.nil?
    end
  end

  def test_asserts_that_eigth_grade_data_is_empty
    state_wide_testings = @state_wide_repo.state_wide_testings.values
    assert state_wide_testings.all? do |state_wide_testing|
      state_wide_testing.eighth_grade.nil?
    end
  end

  def test_can_populate_thrid_grade_data
    state_wide_testings = @state_wide_repo.state_wide_testings.values
    assert state_wide_testings.all? do |state_wide_testing|
      state_wide_testing.eighth_grade.nil?
    end
     row = {location: "COLORADO", score: "Math", timeframe: 2005, data: 0.083 }

    expected = {"Math"=>{2005=>0.083}}
    assert_equal expected, @state_wide_repo.populate_3rd_and_8th_grade(row, "third_grade")
  end

  def  test_can_populate_8th_grade_data
    state_wide_testings = @state_wide_repo.state_wide_testings.values
    assert state_wide_testings.all? do |state_wide_testing|
      state_wide_testing.eighth_grade.nil?
    end
     row = {location: "COLORADO", score: "Math", timeframe: 2005, data: 0.083 }

    expected = {"Math"=>{2005=>0.083}}
    assert_equal expected, @state_wide_repo.populate_3rd_and_8th_grade(row, "eighth_grade")
  end

  def test_3rd_has_been_loaded
    state_wide_tests = @state_wide_repo.state_wide_testings.values
    assert_equal 181, state_wide_tests.count

    assert state_wide_tests.all? do |state_test|
      state_test.third_grade.values != nil
    end
  end

  def test_8th_has_been_loaded
    state_wide_tests = @state_wide_repo.state_wide_testings.values
    assert_equal 181, state_wide_tests.count

    assert state_wide_tests.all? do |state_test|
      state_test.eighth_grade.values != nil
    end
  end
end
