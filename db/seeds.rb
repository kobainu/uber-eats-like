# seedファイルはアプリケーションの初期データを投入するのに使う
# seedファイルの中では、rubyをそのまま記述し、rails db:seedでそれを実行する

3.times do |n| # ここで3回Restaurant.new()させています。
  restaurant = Restaurant.new(
    name: "testレストラン_#{n}", # それぞれのnameはユニークなものにしたいので、"testレストラン_0", "testレストラン_1"...となるようにします。
    fee: 100, # feeやtime_requiredは固定の値を設定します。
    time_required: 10,
  )

  12.times do |m| # それぞれのrestaurantに１つにつき12個のfoodを作成します。
    restaurant.foods.build( # restaurant.foods.buildとすることで、Food.newすることなくリレーションを持ったfoodを生成することができます。
      name: "フード名_#{m}", # nameとdescriptionもそれぞれユニークなものを設定します。
      price: 500,
      description: "フード_#{m}の説明文です。"
    )
  end

  restaurant.save! # 例外をあげたい時には ! (エクスクラメーションマーク)つきのメソッドを使う(通常のメソッドはその処理が失敗するとfalseを返します。一方、 ! (エクスクラメーションマーク)がついたメソッド、例えばsave!、update!などが失敗すると例外を発生させます。)
  # <例外をあげさせることのメリット>
  # エラーが発生した場所、原因が拾いやすい
  # 例外が起きた場所で処理を止められる
end
