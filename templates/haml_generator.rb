inject_into_file "config/application.rb", :after => "# Configure the default encoding used in templates for Ruby 1.9.\n" do
<<-RUBY
    config.generators do |g|
      g.template_engine :haml
    end
RUBY
end
