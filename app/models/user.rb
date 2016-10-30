class User < ApplicationRecord
  has_one :match
  has_one :ai
end
