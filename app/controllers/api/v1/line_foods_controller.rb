module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_food, only: %i[create replace] # :onlyオプションをつけることで、特定のアクションの実行前にだけ追加するということができます。

      def index
        line_foods = LineFood.active
        if line_foods.exists? # line_foodsが空かどうか？をチェックしています(本教材で作成するアプリケーションでは仮注文ページにはいつでもアクセスすることができます。つまり、仮注文をする前でもこのリクエスト自体は走る可能性があります。その場合を考慮して、line_foods.exists?というチェックをおこなっています。)
          render json: { # activeなLineFoodがある場合には正常パターンとしてこのようなJSON形式のデータを返します。
            line_food_ids: line_foods.map { |line_food| line_food.id }, # line_foodsというインスタンスそれぞれをline_foodという単数形の変数名でとって、line_food.idとして１つずつのidを取得しています。それが最終的にline_food_ids: ...のプロパティとなります。
            restaurant: line_foods[0].restaurant, # １つの仮注文につき１つの店舗という仕様のため、line_foodsの中にある先頭のline_foodインスタンスの店舗の情報を詰めています。
            count: line_foods.sum { |line_food| line_food[:count] }, # 各line_foodインスタンスには数量を表す:countがあります。
            amount: line_foods.sum { |line_food| line_food.total_amount }, # 各line_foodがインスタンスメソッドtotal_amountを呼んで、またその数値を合算しています。
          }, status: :ok
        else # activeなLineFoodが一つも存在しないケース
          render json: {}, status: :no_content # 空データがJSON形式で返されます。ステータスコードは「リクエストは成功したが、空データ」として204を返す
        end
      end

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

      def replace
        LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food| # 他店舗のactiveなLineFood一覧を取得し
          line_food.update_attribute(:active, false) # それぞれのline_food.activeをfalseに更新する
        end

        set_line_food(@ordered_food)

        if @line_food.save # createアクションと同様
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
