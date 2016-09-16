require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'minitest/pride'
require './lib/state_wide_testing_repository'
require './lib/state_wide_testing'
require 'pry'

class StateWideTestingTest < Minitest::Test

  def setup
    @state_wide_testing = StateWideTesting.new("name", "parent repo")
  end

  def test_test_state_wide_testing_repo_is_a_class
      assert_equal StateWideTesting, @state_wide_testing.class
  end

  def test_it_has_a_name
    assert_equal "NAME", @state_wide_testing.name
  end

  def test_third_grade_scoring_initializes_with_empty_hash
    assert @state_wide_testing.third_grade.empty?
  end

  def test_can_add_to_third_grade
    
  end

  def test_third_grade_initializes_with_empty_hash
    assert @state_wide_testing.third_grade.empty?
  end

  def test_eight_grade_score_initializes_with_empty_hash
    assert @state_wide_testing.eigth_grade.empty?
  end

  def test_math_initializes_with_empty_hash
    assert @state_wide_testing.math.empty?
  end

  def test_reading_test_initializes_with_empty_hash
    assert @state_wide_testing.reading.empty?
  end

  def test_writing_initializes_with_empty_hash
    assert @state_wide_testing.writing.empty?
  end

end
