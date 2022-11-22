module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create] # :onlyオプションをつけることで、特定のアクションの実行前にだけ追加するということができます。

      def create
        if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?. # 例外パターンで早期リターン(「他店舗でアクティブなLineFood」をActiveRecord_Relationのかたちで取得します。そして、それが存在するかどうか？をexists?で判断しています。ここでtrueにある場合には、JSON形式のデータを返却してreturnして処理を終えます。)
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name,
          }, status: :not_acceptable # existing_restaurantですでに作成されている他店舗の情報と、new_restaurantでこのリクエストで作成しようとした新店舗の情報の２つを返しています。また、HTTPレスポンスステータスコードは406 Not Acceptableを返します。
        end

        set_line_food(@ordered_food) # 例外パターンに当てはまらず、正常に仮注文を作成する場合にはset_line_food(@ordered_food)でline_foodインスタンスを生成していきます。(*1)

        if @line_food.save # @line_foodをsaveで保存します。この時にエラーが発生した場合にはif @line_food.saveでfalseと判断されrender json: {}, status: :internal_server_errorが返ります。もしフロントエンドでエラーの内容に応じて表示を変えるような場合にここでHTTPレスポンスステータスコードが500系になることをチェックできます。
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end

      private

      def set_food # set_foodはこのコントローラーの中でしか呼ばれないアクションです。そのため、privateにします。
        @ordered_food = Food.find(params[:food_id])
      end

      def set_line_food(ordered_food) # (*1)
        if ordered_food.line_food.present? # すでに同じfoodに関するline_foodが存在する場合("present?" => 値が存在する場合trueを返す)
          @line_food = ordered_food.line_food # 既存のline_foodインスタンスの既存の情報を更新します。ここでは、countとactiveの２つを更新しています。
          @line_food.attributes = { # ("attributes" => 全てのモデルオブジェクトと属性を取得)
            count: ordered_food.line_food.count + params[:count],
            active: true
          }
        else # 全く新しくline_foodを作成する場合はordered_food.build_line_food(...でインスタンスを新規作成しています。
          @line_food = ordered_food.build_line_food(
            count: params[:count],
            restaurant: ordered_food.restaurant,
            active: true
          )
        end
      end
    end
  end
end
