# -*- coding: utf-8 -*-
class MatchChannel < ApplicationCable::Channel

  def subscribed
    set_redis
    stream_from user_channel
  end

  def unsubscribed
    # 既存のマッチが有れば削除
    user = User.find_by_id(@redis.get(self.session_id))
    user.match.destroy if user.present? && user.match.present?
  end

  def match data

    id    = data['id']
    token = data['token']

    user = User.find_by_id id

    _token = user[:token] unless user.nil?

    # 認証失敗
    return unless token.present? && _token == token

    @redis.set(self.session_id, id)

    # 既存のマッチが有れば削除
    user.match.destroy if user.match.present?

    # マッチ相手を探す(本当は古いところから探す)
    m = Match.last
    
    if m.present?
      
      # ゲーム開始時間(4秒後, 1秒マージン)
      t = Time.current.advance(seconds: 4)

      stage = Array.new(50) { |i| rand(4) }
      
      # ゲーム情報
      game = {
        match: true,
        time: {
          hour: t.hour,
          min: t.min,
          sec: t.sec
        },
        stage: stage
      }

      # マッチしたことを両者に伝える
      ActionCable.server.broadcast user_channel_id(m[:session_id]), game
      ActionCable.server.broadcast user_channel, game

      # 既存のマッチ情報を削除
      m.destroy
    else
      # マッチ相手が見つからなかったユーザー
      # 新しいマッチのデータ
      user.build_match(session_id: self.session_id).save
      # 待機させる
    end
  end

  def user_channel
    user_channel_id self.session_id
  end

  def user_channel_id sid
    'session_'+sid
  end
end
