class Food < ApplicationRecord
  belongs_to :restaurant
  belongs_to :order, optional: true # optional: true => 関連付け先が存在しなくてもいいという意味
  has_one :line_food
end
