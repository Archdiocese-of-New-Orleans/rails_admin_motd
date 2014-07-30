require "rails_admin_motd/engine"
require "pusher"
require 'yaml'

module RailsAdminMotd
  mattr_accessor :pusher_app_id
  mattr_accessor :pusher_key
  mattr_accessor :pusher_secret
  mattr_accessor :pusher_channel
  mattr_accessor :pusher_event_add
  mattr_accessor :pusher_event_remove
  mattr_accessor :current_user_name_method
  mattr_accessor :history_limit

  def self.config
    yield self
  end

end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class Motd < Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :root? do
          true
        end

        register_instance_option :only do
          true
        end

        register_instance_option :controller do
          Proc.new do

            def motds
              @motds ||= YAML.load_file(yml_path)
            end

            def next_motd_id
              motds['messages'].length + 1
            end

            def yml_path
              Rails.root.join("config", "rails_admin_motd.yml")
            end

            def update_motd(motd={})
              motds['messages'].unshift(motd)
              write_yml
            end

            def write_yml
              File.open(yml_path, 'w') {|f| f.write motds.to_yaml }
            end

            def remove_motd_from_yml(motd_id)
              index = motds['messages'].index{|m| m['id'] = motd_id }
              if index
                motds['messages'].delete_at(index)
                write_yml
              end
            end

            if request.post?
              @motd = params[:motd]
              Pusher.url = "http://#{RailsAdminMotd.pusher_key}:#{RailsAdminMotd.pusher_secret}@api.pusherapp.com/apps/#{RailsAdminMotd.pusher_app_id}"
              Pusher.logger = Rails.logger
              @name = current_user.try(RailsAdminMotd.current_user_name_method)
              if @motd.present?
                begin
                  Pusher["#{RailsAdminMotd.pusher_channel}"].trigger("#{RailsAdminMotd.pusher_event_add}", {
                    id: next_motd_id,
                    user_id: current_user.id,
                    name: @name,
                    date: DateTime.now.to_s,
                    message: @motd
                  })
                  # save state to the yml file
                  update_motd( { 'id' => next_motd_id, 'user_id' => current_user.id, 'name' => @name, 'date' => DateTime.now.to_s, 'message' => @motd } )
                rescue Pusher::Error => e
                  p e.message
                  @error = e.message
                end
              else
                @error = I18n.t('admin.actions.motd.message_required')
              end
            elsif request.delete?
              begin
                motd = motds['messages'].find{|m| m['id'] == params[:id] } #find the motd from the yml
                if can? :manage, :all || motd.user_id == current_user.id #delete it if they are auth.
                  Pusher["#{RailsAdminMotd.pusher_channel}"].trigger("#{RailsAdminMotd.pusher_event_remove}", {
                    id: params[:id]
                  })
                  remove_motd_from_yml(params[:id])
                end
              rescue Pusher::Error => e
                @error = e.message
              end
            else
              @motds = motds['messages']
            end

            respond_to do |format|
              format.html
              format.js
            end
          end
        end

        register_instance_option :link_icon do
          'icon-bullhorn'
        end

        register_instance_option :http_methods do
          [:get, :post, :delete]
        end

        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end

