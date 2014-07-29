RailsAdminMotd.config do |config|
  # signup for free at pusher.com
  config.pusher_app_id = ''
  config.pusher_key = ''
  config.pusher_secret = ''
  config.pusher_channel = 'rails_admin_motd'
  config.pusher_event_add = 'motd_add'
  config.pusher_event_remove = 'motd_remove'
  config.current_user_name_method = :name # a method that returns the current_user name
  config.history_limit = 10 # will keep x many motds
end