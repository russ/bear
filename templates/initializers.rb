initializer("accessible_attributes.rb") do
<<-"FILE"
class ActiveRecord::Base
  attr_accessible
  attr_accessor :accessible

  private

  def mass_assignment_authorizer
    if accessible == :all
      self.class.protected_attributes
    else
      super + (accessible || [])
    end
  end
end
FILE
end

initializer("haml.rb") do
<<-"FILE"
Haml::Template.options[:format] = :html5
FILE
end
