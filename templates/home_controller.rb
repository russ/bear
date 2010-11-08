generate(:controller, "home index")

create_file "app/views/home/index.html.haml" do
<<-FILE
%h1 #{app_name.humanize}
FILE
end

route("root :to => \"home#index\"")
