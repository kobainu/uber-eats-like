module Api
  module V1
    class OrdersController < ApplicationController
      def create
        posted_line_foods = LineFood.where(id: params[:line_food_ids]) # 複数の仮注文があるため、複数のidの配列がパラメーターとしてフロントから送られてきます。[1,2,3]のようなかたちです。これらをLineFood.whereにわたすことで対象のidのデータを取得し、posted_line_foodsという変数に代入しています。
        order = Order.new( # それらを合算して一つのOrder.newし、orderインスタンスを生成しています。
          total_price: total_price(posted_line_foods),
        )
        if order.save_with_update_line_foods!(posted_line_foods)
          render json: {}, status: :no_content # order.save_with_update_line_foods!(posted_line_foods)が成功した場合にはstatus: :no_contentと空データを返します。
        else
          render json: {}, status: :internal_server_error # 失敗した場合にはstatus: :internal_server_errorを返しています。
        end
      end

      private

      def total_price(posted_line_foods)
        posted_line_foods.sum {|line_food| line_food.total_amount } + posted_line_foods.first.restaurant.fee
      end
    end
  end
end
