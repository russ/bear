generate(:controller, "admin/users index new create edit update destroy")

inject_into_file 'config/routes.rb', :after => "devise_for :users\n" do
<<-'FILE'
  namespace "admin" do
    resources :users
  end
FILE
end

inject_into_file 'app/controllers/admin/users_controller.rb', :after => "def index\n" do
<<-'FILE'
    @users = User.paginate :page => params[:page], :per_page => 50
FILE
end

inject_into_file 'app/controllers/admin/users_controller.rb', :after => "def new\n" do
<<-'FILE'
    @user = User.new
FILE
end

inject_into_file 'app/controllers/admin/users_controller.rb', :after => "def create\n" do
<<-'FILE'
    @user = User.new
    @user.attributes = params[:user]
    if @user.save
      flash[:notice] = "User created!"
      redirect_to(admin_users_path)
    else
      render(:action => "new")
    end
FILE
end

inject_into_file 'app/controllers/admin/users_controller.rb', :after => "def update\n" do
<<-'FILE'
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated #{@user.name}."
      redirect_to(admin_users_url)
    else
      render(:action => "edit")
    end
FILE
end

inject_into_file 'app/controllers/admin/users_controller.rb', :after => "def destroy\n" do
<<-'FILE'
    @user.destroy
    flash[:notice] = "User deleted."
    redirect_to(admin_users_path)
FILE
end

gsub_file 'app/controllers/admin/users_controller.rb', /ApplicationController/, 'Admin::BaseController'

inject_into_file 'app/controllers/admin/users_controller.rb', :after => "class Admin::UsersController < Admin::BaseController\n" do
<<-'FILE'
  before_filter :find_user, :only => [ :edit, :update, :destroy ]
    
  def find_user
    @user = User.find(params[:id])
  end
  
FILE
end

create_file 'app/views/admin/users/_form.html.haml' do
<<-'FILE'
= semantic_form_for([ :admin, @user ])  do |f|
  = f.semnatic_errors
  = f.inputs(:name, :email, :password, :password_confirmation)
  = f.buttons
FILE
end

create_file 'app/views/admin/users/edit.html.haml' do
<<-'FILE'
= render(:partial => "form")
FILE
end

create_file 'app/views/admin/users/new.html.haml' do
<<-'FILE'
= render(:partial => "form")
FILE
end

create_file 'app/views/admin/users/index.html.haml' do
<<-FILE
- if !@users.blank?
  %table
    %thead
      %tr
        %th Name
        %th Email
        %th
    %tbody
      - @users.each do |user|
        %tr
          %td= link_to(user.name, edit_admin_user_path(user), :class => "edit_link")
          %td= user.email
          %td
            - if user.id != current_user.id
              = link_to("Delete", admin_user_path(user), :confirm => 'Are you sure?', :method => :delete, :class => "delete_link")
            - else
              That's you!
  = will_paginate(@users)
- else
  %p No users
FILE
end

