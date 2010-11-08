create_file 'app/views/admin/dashboard/index.html.haml' do
<<-FILE
%h1 #{app_name.humanize} Admin
FILE
end

create_file 'app/views/layouts/admin.html.haml' do
<<-FILE
!!! 5
%html
  %head
    %meta{ "http-equiv" => "Content-Type", :content => "text/html; charset=utf-8" }
    %meta{ "http-equiv" => "X-UA-Compatible", :content => "IE=edge,chrome=1" }
    %title
      #{app_name.humanize}
      = yield(:title)
    %meta{ :name => "viewport", :content => "width=device-width; initial-scale=1.0" }
    = csrf_meta_tag
    = include_stylesheets(:admin, :media => "all")
    = yield(:head)
  %body
    - unless flash_messages.blank?
      #flash_messages= raw(flash_messages)

    = yield
    = include_javascripts(:common)
FILE
end
