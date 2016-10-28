module ApplicationCable
  class Connection < ActionCable::Connection::Base

    identified_by :session_id
    
    def connect
      self.session_id = SecureRandom.urlsafe_base64
    end
  end
end
