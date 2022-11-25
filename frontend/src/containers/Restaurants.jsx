import React, { Fragment, useReducer, useEffect } from 'react';
import styled from 'styled-components';
import { Link } from "react-router-dom";
// components
import Skeleton from '@material-ui/lab/Skeleton'; // Material UIというUIライブラリのコンポーネントをimport
// apis
import { fetchRestaurants } from '../apis/restaurants';
// reducers
import {
  initialState,
  restaurantsActionTypes,
  restaurantsReducer,
} from '../reducers/restaurants';
// constants
import { REQUEST_STATE } from '../constants';
// images
import MainLogo from '../images/logo.png';
import MainCoverImage from '../images/main-cover-image.png';
import RestaurantImage from '../images/restaurant-image.jpg';

const HeaderWrapper = styled.div`
  display: flex;
  justify-content: flex-start;
  padding: 8px 32px;
`;

const MainLogoImage = styled.img`
  height: 90px;
`

const MainCoverImageWrapper = styled.div`
  text-align: center;
`;

const MainCover = styled.img`
  height: 600px;
`;

const RestaurantsContentsList = styled.div`
  display: flex;
  justify-content: space-around;
  margin-bottom: 150px;
`;

const RestaurantsContentWrapper = styled.div`
  width: 400px;
  height: 300px;
  padding: 48px;
`; // width: 450pxから変更

const RestaurantsImageNode = styled.img`
  width: 100%;
`;

const MainText = styled.p`
  color: black;
  font-size: 18px;
`;

const SubText = styled.p`
  color: black;
  font-size: 12px;
`;

export const Restaurants = () => {
  const [state, dispatch] = useReducer(restaurantsReducer, initialState); // コンポーネント内で初期化

  useEffect(() => { // 「useEffect( 関数A, [値B])」 => "「値B」に変更があった場合にのみ「関数A」を実行する"
    dispatch({ type: restaurantsActionTypes.FETCHING }); // stateの中のfetchStateはREQUEST_STATE.LOADINGに変更されます
    fetchRestaurants()
    .then((data) =>
      dispatch({ // dispatchはreducerを通じて間接的に、stateを変更させます
        type: restaurantsActionTypes.FETCH_SUCCESS, // fetchStateの変更と、payloadに渡したデータがrestaurantsListに入れられます
        payload: { // (※1)
          restaurants: data.restaurants
        }
      })
    )
  }, []) // []空配列の場合はコンポーネントを表示した初回のみ関数を実行する

  return (
    <Fragment>
      <HeaderWrapper>
        <MainLogoImage src={MainLogo} alt="main logo" />
      </HeaderWrapper>
      <MainCoverImageWrapper>
        <MainCover src={MainCoverImage} alt="main cover" />
      </MainCoverImageWrapper>
      <RestaurantsContentsList>
        { // JSの変数を参照するため{...}でさらに囲っています
          state.fetchState === REQUEST_STATE.LOADING ? // ↓ローディング中の処理
            <Fragment>
              <Skeleton variant="rect" width={450} height={300} />
              <Skeleton variant="rect" width={450} height={300} />
              <Skeleton variant="rect" width={450} height={300} />
            </Fragment> // SkeletonはスマホアプリやSPAでよく使われる「ロード状態」を表すUIパーツです
          : // ↓ローディング後の処理
            state.restaurantsList.map((item, index) =>
              <Link to={`/restaurants/${item.id}/foods`} key={index} style={{ textDecoration: 'none' }}>
                <RestaurantsContentWrapper>
                  <RestaurantsImageNode src={RestaurantImage} />
                  <MainText>{item.name}</MainText>
                  <SubText>{`配送料：${item.fee}円 ${item.time_required}分`}</SubText>
                </RestaurantsContentWrapper>
              </Link>
            )
        }
      </RestaurantsContentsList>
    </Fragment>
  )
};

// (※1)payloadとはReactやuseReducerに限って用いられる言葉ではなく、通信に含まれるデータのことを「ペイロードデータ」ということから慣例的に付けられています。ここをdata: {...としても問題はありませんが、ここではpayloadと名付けておきます。

