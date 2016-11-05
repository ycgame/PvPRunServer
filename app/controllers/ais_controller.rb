class AisController < ApplicationController

  require 'net/http'

  def req

    return head 403 if params[:token] != ENV['AI_TOKEN']

    ai = Ai.offset(rand(Ai.count)).first

    uri  = URI.parse("http://localhost:6767/request")
    http = Net::HTTP.new(uri.host, uri.port)
    req  = Net::HTTP::Post.new(uri.path)
    
    req.set_form_data({
                        token: ENV['AI_TOKEN'],
                        data: ai.to_json(include: :user)
                      })
    
    res = http.request(req)
    return head 200
  end
  
end
