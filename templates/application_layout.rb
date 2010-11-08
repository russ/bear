run "mkdir app/views/shared"

run "rm app/helpers/application_helper.rb"
create_file "app/helpers/application_helper.rb" do
<<-"FILE"
module ApplicationHelper
  def flash_messages
    %w(notice warning error).collect { |message|
      unless flash[message.to_sym].blank?
        content_tag(:p, flash[message.to_sym], :class => "message" + message)
      end
    }.join
  end
end
FILE
end

run "rm app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml" do
<<-FILE
!!! 5

%html
  %head
    %meta{ "http-equiv" => "Content-Type", :content => "text/html; charset=utf-8" }
    %meta{ "http-equiv" => "X-UA-Compatible", :content => "IE=edge,chrome=1" }
    %title
      #{app_name.humanize}
      = yield(:title)
    %meta{ :name => "description", :content => "" }
    %meta{ :name => "author", :content => "" }
    %meta{ :name => "viewport", :content => "width=device-width; initial-scale=1.0" }
    = csrf_meta_tag
    = include_stylesheets(:main, :media => "all")
    = yield(:head)

  %body
    #header
      .container_12
        .grid_12
          %h1= link_to("#{app_name.humanize}", root_path)
          %ul
            %li= link_to("Home", root_path)
        .clear

      - unless flash_messages.blank?
        .container_12
          .grid_12
            #flash_messages= raw(flash_messages)
          .clear

        #content
          .container_2
            = yield
            .clear

    .container_12
      .grid_12
        #footer
      .clear

    = include_javascripts(:common)
    = coffee_script_bundle
FILE
end
