Rails.application.routes.draw do
  namespace :api do # namespace: hoge で名前空間を付与することができます。これはコントローラーをグルーピングし、またURLにもその情報を付与することを意味します。
    namespace :v1 do # アプリケーションの開発途中でAPIの仕様を大きく変更する必要がでる場合に備えてURL自体にバージョン番号を持たせます。(必要な場合のみ)
      resources :restaurants do # Restaurant一覧をGETできるようにします。
        resources :foods, only: %i[index]# 特定のRestaurantに紐づくFood一覧をGETします。(only: %i[index]のかたちで特定のルーティングしか生成しないという方法もあります。)
      end
      resources :line_foods, only: %i[index create]
      put 'line_foods/replace', to: 'line_foods#replace' # 'line_foods/replace'というURLに対してPUTリクエストがきたら、line_foods_controller.rbのreplaceメソッドを呼ぶ
      resources :orders, only: %i[create]
    end
  end
end
