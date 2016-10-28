module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def set_redis
      @redis = Redis.new(Rails.application.config_for('cable'))
    end
  end
end
