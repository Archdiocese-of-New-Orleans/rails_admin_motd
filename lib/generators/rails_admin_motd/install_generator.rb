require 'rails/generators'

module RailsAdminMotd
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
    def install
      copy_file "rails_admin_motd.rb", "config/initializers/rails_admin_motd.rb"
      copy_file "rails_admin_motd.yml", "config/rails_admin_motd.yml"
    end
  end
end

