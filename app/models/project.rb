class Project
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :project, as: :name, type: String

  def test_runs
      TestRun.from self
  end
end
