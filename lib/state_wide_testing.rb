class StateWideTesting
  attr_reader :name,
              :third_grade,
              :eigth_grade,
              :math,
              :reading,
              :writing,
              :state_wide_testing
  def initialize(name, parent_repository)
    @name = name.upcase
    @third_grade = Hash.new
    @eigth_grade   = Hash.new
    @math                = Hash.new
    @reading             = Hash.new
    @writing             = Hash.new
    @state_wide_testing  = parent_repository
  end
end
