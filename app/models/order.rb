class Order < ApplicationRecord
  has_many :line_foods

  validates :total_price, numericality: { greater_than: 0 }

  #ここではLineFoodデータの更新と、Orderデータの保存を処理しています。これらの処理をトランザクションの中で行うようにすることで、この２つの処理のいずれかが失敗した場合に全ての処理をなかったことにするように配慮しています。
  def save_with_update_line_foods!(line_foods)
    ActiveRecord::Base.transaction do # 処理の結果、データ(間)の整合性が求められる場合にトランザクション(*1)を使います(ActiveRecord::Base.transaction do ... endというかたちで記述)
      line_foods.each do |line_food|
        line_food.update!(active: false, order: self)
      end
      self.save!
    end
  end
end

# (*1)トランザクションとは複数の処理を一つの処理と捉えて、その処理全てが成功/失敗するかどうかをチェックするもの(一連の処理とすべきものにのみ適用すべき)
# トランザクション内で例外が発生した場合にロールバックをするという特徴があります。 つまり、破壊的メソッドであるupdate_attributes!やsave!を使ってはじめて失敗時に例外をキャッチしてロールバックを行ってくれます。
# ここではline_food.update_attributes!とself.save!の２つの処理に対してトランザクションを張っていることがわかります。どちらか片方でも失敗した場合にこのsave_with_update_line_foods!は失敗となり、ロールバックしてくれます。
