import axios from 'axios';
import { restaurantsIndex } from '../urls/index';

// レストラン一覧のAPIを呼ぶ関数
export const fetchRestaurants =() => {
  return axios.get(restaurantsIndex) // getリクエスト(レストラン一覧ページ)
  .then(res => { // 成功した場合は返り値をresという名前で取得し、res.dataでレスポンスの中身だけをreturn
    return res.data
  })
  .catch((e) => console.error(e)) // 失敗した場合はエラーメッセージをコンソールに出す(本来的にはここでバリデーションエラーメッセージなどを返してあげることで、フロントエンドでそれを画面に表示できます)
}

// axiosはPromiseベースである(axiosを使う側でnew Promiseなどしなくても、非同期処理を実装することができます)
// 「axios.get().then().catch()」とすることができます
