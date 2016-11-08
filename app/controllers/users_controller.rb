class UsersController < ApplicationController

  before_action :set_user, except: [:status, :create]

  def status
    render :plain => 'OK'
  end

  def create
    user = User.create(name: user_params[:name], token: SecureRandom.hex(16), rate: 0, time_attack: nil)
    render :json => user
  end

  def ranking

    ranking_rate = @all.order('rate DESC')
    ranking_rate_top10 = ranking_rate.limit(10)
    ranking_rate_user = ranking_rate.to_a.index(@user)
    
    ranking_time_attack = @all.order('time_attack ASC')
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
