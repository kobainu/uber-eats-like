class ApplicationController < ActionController::API
  before_action :fake_load

  def fake_load
    sleep(1) # 1秒だけプログラムの実行を止める(ローディング画面を確認するため)
  end
end

# ApplicationControllerを継承しているコントローラーでは全て一律に同様の処理を入れたい場合に採用されます。例えばユーザー認証に関するロジックが分かりやすいでしょう。ログインしていなければ使えないサービスでは、全ての処理に対して「ログインしているかどうか？」という判断が必要です。このような場合にApplicationControllerのberfore_actionなどで判断させたりします。
