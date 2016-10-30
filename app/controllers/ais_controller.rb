class AisController < ApplicationController

  def show
    
    return head 403 if params[:aitoken] != ENV['AI_TOKEN']
    
    logger.debug('AI will be launch')
    
    ai = Ai.find_by_id(params[:id])
    render :json => ai.to_json(include: :user)
  end
  
end
