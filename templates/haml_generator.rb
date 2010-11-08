inject_into_file "config/application.rb", :after => "class Application < Rails::Application\n" do
<<-RUBY
    config.generators do |g|
      g.template_engine :haml
    end
RUBY
end
