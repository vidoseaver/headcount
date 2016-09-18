require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/state_wide_test_repository'
require './lib/statewide_test'
require 'pry'



class StatewideTestRepositoryTest < Minitest::Test

  def setup
    @state_wide_repo = StatewideTestRepository.new
    @state_wide_repo.load_data({
                      :enrollment        => { :kindergarten => "./data/Kindergartners in full-day program.csv",
                                              :high_school_graduation => "./data/High school graduation rates.csv"},
                      :statewide_testing => { :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                              :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                              :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                              :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                              :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})

  end

  def test_test_state_wide_testing_repo_is_a_class
      a = StatewideTestRepository.new

      assert_equal StatewideTestRepository, a.class
  end

  def test_can_make_an_instanceof_state_wide_testings
    row = {:location => "dummy_location"}
    assert_instance_of StatewideTest, @state_wide_repo.state_wide_testing_maker(row)
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

    expected = {"2008"=>{"Math"=>0.697, "Reading"=>0.703, "Writing"=>0.501}, "2009"=>{"Math"=>0.691, "Reading"=>0.726, "Writing"=>0.536}, "2010"=>{"Math"=>0.706, "Reading"=>0.698, "Writing"=>0.504}, "2011"=>{"Math"=>0.696, "Reading"=>0.728, "Writing"=>0.513}, "2012"=>{"Reading"=>0.739, "Math"=>0.71, "Writing"=>0.525}, "2013"=>{"Math"=>0.72295, "Reading"=>0.73256, "Writing"=>0.50947}, "2014"=>{"Math"=>0.71589, "Reading"=>0.71581, "Writing"=>0.51072}, 2005=>{"Math"=>0.083}}
    assert_equal expected, @state_wide_repo.populate_state_wide_test_1(row, "third_grade")
  end

  def  test_can_populate_8th_grade_data
    state_wide_testings = @state_wide_repo.state_wide_testings.values
    assert state_wide_testings.all? do |state_wide_testing|
      state_wide_testing.eighth_grade.nil?
    end
     row = {location: "COLORADO", score: "Math", timeframe: 2005, data: 0.083 }

    expected = {"2008"=>{"Math"=>0.469, "Reading"=>0.703, "Writing"=>0.529}, "2009"=>{"Math"=>0.499, "Reading"=>0.726, "Writing"=>0.528}, "2010"=>{"Math"=>0.51, "Reading"=>0.679, "Writing"=>0.549}, "2011"=>{"Reading"=>0.67, "Math"=>0.513, "Writing"=>0.543}, "2012"=>{"Math"=>0.515, "Writing"=>0.548, "Reading"=>0.671}, "2013"=>{"Math"=>0.51482, "Reading"=>0.66888, "Writing"=>0.55788}, "2014"=>{"Math"=>0.52385, "Reading"=>0.66351, "Writing"=>0.56183}, 2005=>{"Math"=>0.083}}
    assert_equal expected, @state_wide_repo.populate_state_wide_test_1(row, "eighth_grade")
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

  def test_math_data_has_been_loaded
    state_wide_tests = @state_wide_repo.state_wide_testings.values
    assert_equal 181, state_wide_tests.count

    assert state_wide_tests.all? do |state_test|
      state_test.math.values != nil
    end
  end

  def test_reading_data_has_been_loaded
    state_wide_tests = @state_wide_repo.state_wide_testings.values
    assert_equal 181, state_wide_tests.count

    assert state_wide_tests.all? do |state_test|
      state_test.reading.values != nil
    end
  end
end
