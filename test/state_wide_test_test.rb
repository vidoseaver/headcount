require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/state_wide_test_repository'
require './lib/statewide_test'
require 'pry'

class StatewideTestTest < Minitest::Test

  def setup
    @state_wide_testing = StatewideTest.new("name", "parent repo")
      @state_wide_repo = StatewideTestRepository.new
      @state_wide_repo.load_data({
                        :enrollment        => { :kindergarten => "./data/Kindergartners in full-day program.csv",
                                                :high_school_graduation => "./data/High school graduation rates.csv"},
                        :statewide_testing => { :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
                                                :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
                                                :math         => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
                                                :reading      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
                                                :writing      => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"}})
      @colorado = @state_wide_repo.state_wide_testings["COLORADO"]
  end

  def test_test_state_wide_testing_repo_is_a_class
      assert_equal StatewideTest, @state_wide_testing.class
  end

  def test_it_has_a_name
    assert_equal "NAME", @state_wide_testing.name
  end

  def test_third_grade_scoring_initializes_with_empty_hash
    assert @state_wide_testing.third_grade.values.empty?
  end

  def test_can_add_to_third_grade

  end

  def test_third_grade_initializes_with_empty_hash
    assert @state_wide_testing.third_grade.values.empty?
  end

  def test_eight_grade_score_initializes_with_empty_hash
    assert @state_wide_testing.eighth_grade.values.empty?
  end

  def test_math_initializes_with_empty_hash
    assert @state_wide_testing.math.values.empty?
  end

  def test_reading_test_initializes_with_empty_hash
    assert @state_wide_testing.reading.values.empty?
  end

  def test_writing_initializes_with_empty_hash
    assert @state_wide_testing.writing.values.empty?
  end

  def test_it_knows_it_is_proficient_by_third_grade
    expected =  {"2008"=>{"Math"=>"0.697", "Reading"=>"0.703", "Writing"=>"0.501"}, "2009"=>{"Math"=>"0.691", "Reading"=>"0.726", "Writing"=>"0.536"}, "2010"=>{"Math"=>"0.706", "Reading"=>"0.698", "Writing"=>"0.504"}, "2011"=>{"Math"=>"0.696", "Reading"=>"0.728", "Writing"=>"0.513"}, "2012"=>{"Reading"=>"0.739", "Math"=>"0.71", "Writing"=>"0.525"}, "2013"=>{"Math"=>"0.72295", "Reading"=>"0.73256", "Writing"=>"0.50947"}, "2014"=>{"Math"=>"0.71589", "Reading"=>"0.71581", "Writing"=>"0.51072"}}
    assert_equal expected, @colorado.proficient_by_grade(3)
  end

  def test_it_knows_it_is_proficient_by_eighth_grade
    expected = {"2008"=>{"Math"=>"0.469", "Reading"=>"0.703", "Writing"=>"0.529"}, "2009"=>{"Math"=>"0.499", "Reading"=>"0.726", "Writing"=>"0.528"}, "2010"=>{"Math"=>"0.51", "Reading"=>"0.679", "Writing"=>"0.549"}, "2011"=>{"Reading"=>"0.67", "Math"=>"0.513", "Writing"=>"0.543"}, "2012"=>{"Math"=>"0.515", "Writing"=>"0.548", "Reading"=>"0.671"}, "2013"=>{"Math"=>"0.51482", "Reading"=>"0.66888", "Writing"=>"0.55788"}, "2014"=>{"Math"=>"0.52385", "Reading"=>"0.66351", "Writing"=>"0.56183"}}
    assert_equal expected, @colorado.proficient_by_grade(8)
  end

  def test_dummy
    testing = @state_wide_repo.state_wide_testings["AULT-HIGHLAND RE-9"]
    assert_raises UnknownDataError do
    testing.proficient_by_grade(1)
    end
  end

  def test_proficient_by_race_and_ethnicity
    testing = @state_wide_repo.find_by_name("WOODLAND PARK RE-2")
    expected = {"2011"=>{:math=>0.451, :reading=>0.688, :writing=>0.503}, "2012"=>{:math=>0.467, :reading=>0.75, :writing=>0.528}, "2013"=>{:math=>0.473, :reading=>0.738, :writing=>0.531}, "2014"=>{:math=>0.418, :reading=>0.006, :writing=>0.453}}
   assert_equal expected, testing.proficient_by_race_or_ethnicity(:hispanic)
  end

  def test_can_return_unknown_data_error_if_subject_doesnt_exist
    assert_raises UnknownDataError do
    @colorado.proficient_for_subject_by_grade_in_year(:science, 3, 2008)
    end
  end

  def test_can_return_unknown_data_error_if_grade_doest_exist
    assert_raises UnknownDataError do
    @colorado.proficient_for_subject_by_grade_in_year(:math, 5, 2008)
    end
  end

  def test_can_return_unknown_data_error_if_year_doest_exist
    assert_raises UnknownDataError do
    @colorado.proficient_for_subject_by_grade_in_year(:math, 3, 2016)
    end
  end


  def test_proficient_for_subject_by_race_in_year
      testing = @state_wide_repo.find_by_name("ACADEMY 20")

      assert_equal 0.653, testing.proficient_for_subject_by_grade_in_year(:math, 8, 2011)
  end



  # def test_dummy
  #   testing = @state_wide_repo.find_by_name("AULT-HIGHLAND RE-9")
  # assert_equal 0.611, testing.proficient_for_subject_by_race_in_year(:math, :white, 2012)
  # assert_equal 0.310, testing.proficient_for_subject_by_race_in_year(:math, :hispanic, 2014)
  # assert_equal 0.794, testing.proficient_for_subject_by_race_in_year(:reading, :white, 2013)
  # assert_equal 0.278, testing.proficient_for_subject_by_race_in_year(:writing, :hispanic, 2014)


end
