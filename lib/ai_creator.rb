# -*- coding: utf-8 -*-

names = [
         'OK牧場',
         '天才',
         '鈴木',
         '佐々木',
        ]

p ' -- Create AI -- '

names.each_with_index do |name, i|
  p i.to_s + ' : ' + name
  user = User.create(name: name, token: SecureRandom.hex, rate: 0, time_attack: 100.0)
  ai   = user.build_ai(min_interval: 0.3, max_interval: 0.5, correct_rate: 0.95).save
end

p ' -- End -- '
