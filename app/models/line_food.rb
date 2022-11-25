class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true # optional: true => 関連付け先が存在しなくてもいいという意味

  validates :count, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) } # 全てのLineFoodからwhereでactive: trueなもの一覧をActiveRecord_Relationのかたちで返す
  scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) } # restaurant_idが特定の店舗IDではないもの一覧を返す(「他の店舗のLineFood」があるかどうか？をチェックする際にこのscopeを利用します。もし「他の店舗のLineFood」があった場合、ここには１つ以上の関連するActiveRecord_Relationが入ります。)

  def total_amount #コントローラーではなく、モデルに記述することで、様々な箇所から呼び出すことができます
    food.price * count
  end
end
