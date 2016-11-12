class UsersController < ApplicationController

  before_action :set_user, except: [:status, :create]

  def status
    render :plain => 'OK'
  end

  def create
    return head 403 if user_params[:token].nil?
    return head 403 if user_params[:token] != ENV['AI_TOKEN']

    user = User.create(name: 'Guest' + User.last.id.to_s,
                       token: SecureRandom.hex(16), 
                       rate: 0, 
                       time_attack: nil) unless User.last.nil?

    return render :json => user unless user.nil?
    return head 200
  end

  def update_name
    @user.update(name: user_params[:name])
    return render :json => @user
  end

  def ranking

    ranking_rate = @all.where.not('rate = ?', 'null').order('rate DESC')
    ranking_rate_top10 = ranking_rate.limit(10)
    ranking_rate_user = ranking_rate.to_a.index(@user)
    
    ranking_time_attack = @all.where.not('time_attack = ?', 'null').order('time_attack ASC')
    ranking_time_attack_top10 = ranking_time_attack.limit(10)
    ranking_time_attack_user = ranking_time_attack.to_a.index(@user)
    
    result = {
      rate: {
        rank: ranking_rate_user,
        top10: ranking_rate_top10
      },
      time_attack: {
        rank: ranking_time_attack_user,
        top10: ranking_time_attack_top10
      }
    }
    
    render :json => result.to_json(except: :token)
  end

  def time_attack
    @user.update(time_attack: user_params[:time_attack])
    render :json => @user.to_json(except: :token)
  end

  private

  def user_params
    params.permit(:id, :name, :token, :time_attack)
  end

  def set_user
    return head 403 if user_params[:token].nil?
    @all = User.all
    @user = @all.find_by_id(user_params[:id])
    return head 403 if user_params[:token] != @user[:token]
  end
end
