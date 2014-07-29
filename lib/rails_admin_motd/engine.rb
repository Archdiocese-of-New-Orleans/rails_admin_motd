module RailsAdminMotd
  class Engine < ::Rails::Engine
    initializer "RailsAdmin precompile hook", group: :all do |app|
      app.config.assets.precompile += %w(rails_admin/rails_admin_motd.js rails_admin/rails_admin_motd.css)
    end
  end
end
