require 'thor'
require 'thor/actions'
require 'active_support/secure_random'

module Bear
  class CLI < Thor
    include Thor::Actions

    desc "new [app]", "Create a new Rails 3 application"
    long_desc <<-D
      Bear will ask you a few questions to determine what features you
      would like to generate. Based on your answers it will setup a new Rails 3 application.
    D
    method_option :auth, :type => :boolean, :default => true, :banner =>
      "Sets up devise for authentication."
    method_option :roles, :type => :boolean, :default => true, :banner =>
      "Sets up cancan for authorization with roles."
    method_option :admin, :type => :boolean, :default => true, :banner =>
      "Sets up very basic admin"
    def new(project)
      opts = options.dup

      # Can't build an admin or roles without devise
      if !opts[:auth]
        opts[:admin] = false;
        opts[:roles] = false;
      end

      # Env vars used in our template
      ENV['BEAR_AUTH']  = "true" if opts[:auth]
      ENV['BEAR_ADMIN'] = "true" if opts[:admin]
      ENV['BEAR_ROLES'] = "true" if opts[:roles]
      ENV['BEAR_USER_NAME'] = git_user_name if opts[:admin]
      ENV['BEAR_USER_EMAIL'] = git_user_email if opts[:admin]
      ENV['BEAR_USER_PASSWORD'] = user_password if opts[:admin]

      exec(<<-COMMAND)
        rails new #{project} \
          --template=#{template} \
          --skip-test-unit \
          --skip-prototype \
          --database=mysql
      COMMAND
    end

    desc "version", "Prints Bear's version information"
    def version
      say "Bear version #{Bear::VERSION}"
    end
    map %w(-v --version) => :version

    private

    def template
      File.expand_path(File.dirname(__FILE__) + "/../../templates/bootstrap.rb")
    end

    def git_user_name
      `git config --global user.name`.chomp || "Quick Left"
    end

    def git_user_email
      `git config --global user.email`.chomp || "me@me.com"
    end

    def user_password
      ActiveSupport::SecureRandom.base64(8)
    end

  end
end
