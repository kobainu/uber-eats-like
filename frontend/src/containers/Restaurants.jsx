import React, { Fragment, useEffect } from 'react';
// apis
import { fetchRestaurants } from '../apis/restaurants';

export const Restaurants = () => {
  useEffect(() => { // 「useEffect( 関数A, [値B])」 => "「値B」に変更があった場合にのみ「関数A」を実行する"
    fetchRestaurants()
    .then((data) =>
      console.log(data)
    )
  }, []) // []空配列の場合はコンポーネントを表示した初回のみ関数を実行する

  return (
    <Fragment>
      レストラン一覧
    </Fragment>
  )
}
