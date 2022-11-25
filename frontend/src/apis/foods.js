import axios from 'axios';
import { foodsIndex } from '../urls/index' // URL文字列を返す関数をimport

export const fetchFoods =(restaurantId) => { // restaurantIdという変数名で受け取る
  return axios.get(foodsIndex(restaurantId)) // foodsIndex(restaurantId)はURL文字列を返す
  .then(res => {
    return res.data
  })
  .catch((e) => console.error(e))
}
