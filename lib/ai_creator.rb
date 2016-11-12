# -*- coding: utf-8 -*-

p ' -- Create AI -- '

n = User.count
r = Random.new

(0..100).each_with_index do |name, i|

  min = r.rand(0.05..0.25)
  max = r.rand(0.3..0.5)

  cr = r.rand(0.99..0.999)

  p "Min: "+min.to_s
  p "Max: "+max.to_s
  p "Correct rate: "+cr.to_s
  
  time = r.rand(25.0..50.0)
  
  user = User.create(name: 'Guest'+(n+i).to_s, token: SecureRandom.hex, rate: 0, time_attack: time)
  ai   = user.build_ai(min_interval: min, max_interval: max, correct_rate: cr).save
end

p ' -- End -- '
