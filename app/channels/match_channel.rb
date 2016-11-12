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

    # Redis上のデータ削除
    @redis.del(self.session_id)
  end

  def match data

    id    = data['id']
    token = data['token']

    user = User.find_by_id id

    _token = user[:token] unless user.nil?

    # 認証失敗
    return ActionCable.server.broadcast user_channel, {
      type: 'auth', 
      match: false
    } unless token.present? && _token == token
    
    @redis.set(self.session_id, id)

    # 既存のマッチが有れば削除
    user.match.destroy if user.match.present?

    # マッチ相手を探す(本当は古いところから探す)
    m = Match.last
    
    if m.present?

      # ステージの作成
      stage = Array.new(20) { |i| rand(4) }
      
      # ゲーム情報
      game = {
        type: 'match',
        stage: stage
      }

      # ユーザーのマッチング情報
      @redis.set('id_'+self.session_id, user[:id])
      @redis.set('matched_'+self.session_id, m[:session_id])
      @redis.set('stage_'+self.session_id, stage.join(','))
      @redis.set('step_'+self.session_id, 0)

      @redis.set('id_'+m[:session_id], m.user[:id])
      @redis.set('matched_'+m[:session_id], self.session_id)
      @redis.set('stage_'+m[:session_id], stage.join(','))
      @redis.set('step_'+m[:session_id], 0)
      
      # マッチしたことを両者に伝える
      game[:user] = user
      game[:matched] = m.user
      ActionCable.server.broadcast user_channel, game
      
      game[:user]= m.user
      game[:matched] = user
      ActionCable.server.broadcast user_channel_id(m[:session_id]), game

      # 既存のマッチ情報を削除
      m.destroy
    else
      # マッチ相手が見つからなかったユーザー
      # 新しいマッチのデータ
      user.build_match(session_id: self.session_id).save
      # 待機させる
    end
  end

  def step data

    # すでに終了しているか、不正なゲーム
    return logger.debug('Invalid game') unless @redis.exists('matched_'+self.session_id)

    matched = @redis.get('matched_'+self.session_id)
    stage = @redis.get('stage_'+self.session_id).split(',')
    step_count = @redis.get('step_'+self.session_id).to_i

    step = data['step'].to_i
    correct_step = stage[step_count].to_i

    # 相手にデータを送信
    ActionCable.server.broadcast user_channel_id(matched), {
      type: 'step',
      step: step,
      step_count: step_count
    }

    # ゴール    
    fin true, matched, 'goal' if correct_step == step && step_count == stage.length-1
    # 間違ったステップ
    fin false, matched, 'miss' if correct_step != step

    # 一歩すすめる
    @redis.set('step_'+self.session_id, step_count+1)

    logger.debug(' ----------------------------------- ')
  end

  # ゲーム終了
  def fin win, matched, msg

    # レーティングの変更
    user  = User.find_by_id(@redis.get('id_'+self.session_id).to_i)
    muser = User.find_by_id(@redis.get('id_'+matched).to_i)

    user.update(rate: user[:rate] + (win ? 1 : -1))
    muser.update(rate: muser[:rate] + (win ? -1 : 1))
    
    # ゲームデータ削除
    @redis.del('id_'+self.session_id)
    @redis.del('matched_'+self.session_id)
    @redis.del('stage_'+self.session_id)
    @redis.del('step_'+self.session_id)
    @redis.del('id_'+matched)
    @redis.del('matched_'+matched)
    @redis.del('stage_'+matched)
    @redis.del('step_'+matched)

    # 結果の送信

    ActionCable.server.broadcast user_channel, {
      type: 'fin',
      fin: win,
      msg: msg,
      user: user,
      matched: muser
    }

    ActionCable.server.broadcast user_channel_id(matched), {
      type: 'fin',
      fin: !win,
      msg: msg,
      user: muser,
      matched: user
    }
  end

  def cancel
    # 既存のマッチを削除
    user = User.find_by_id(@redis.get(self.session_id))
    user.match.destroy if user.present? && user.match.present?
  end

  def user_channel
    user_channel_id self.session_id
  end

  def user_channel_id sid
    'session_'+sid
  end
end
