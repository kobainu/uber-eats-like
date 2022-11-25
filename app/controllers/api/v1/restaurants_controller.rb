module Api # 名前空間の指定
  module V1
    class RestaurantsController < ApplicationController # 「apiの下の、v1の下の、class RestaurantsController」となります。
      def index
        restaurants = Restaurant.all

        render json: { # render json: {}というかたちでJSON形式でデータを返却しています。
          restaurants: restaurants
        }, status: :ok # status: :okとすることで、リクエストが成功したこと、200 OKと一緒にデータを返すようになります。
      end
    end
  end
end

# このコントローラーではリクエストにパラメーターは不要で、Restaurant.allが返却されるだけということになります。
