import axios from 'axios';
import { lineFoods, lineFoodsReplace } from '../urls/index' // lineFoodsは仮注文のAPIのURL文字列です

export const postLineFoods =(params) => {
  return axios.post(lineFoods, // lineFoods対してPOSTリクエストを送りたいので、axios.post(引数にリクエスト先のURL文字列)を使います。(仮注文のデータを新たに作成する場合はPOST、あるいはPUT)
    { // 第二引数にパラメーターを渡します(今回はfood_idとcountの２つをオブジェクト形式で渡します)
      food_id: params.foodId,
      count: params.count,
    } // => サーバーサイドではparams[:food_id], params[:count]のかたちでそれぞれの値を読み取ることができます
  )
  .then(res => {
    return res.data
  })
  .catch((e) => { throw e; }) // eとはあくまで変数名ですが中身はAPIからのエラーレスポンスで、オブジェクトです。そしてその中からe.response.statusとすることで、そのエラーのHTTPステータスコード(200や404などのこと)を取得することができます
};

export const replaceLineFoods = (params) => {
  return axios.put(lineFoodsReplace, // PUT: リソース(仮注文のデータ)の作成、あるいは更新(すでに存在する仮注文データを更新する場合はPUTか、PATCH)
    {
      food_id: params.foodId,
      count: params.count,
    }
  )
  .then(res => {
    return res.data
  })
  .catch((e) => { throw e; })
};
