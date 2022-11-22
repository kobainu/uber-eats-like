import React, { Fragment, useEffect } from 'react';
import styled from 'styled-components';

// apis
import { fetchRestaurants } from '../apis/restaurants';

// images
import MainLogo from '../images/logo.png';
import MainCoverImage from '../images/main-cover-image.png';

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

export const Restaurants = () => {
  useEffect(() => { // 「useEffect( 関数A, [値B])」 => "「値B」に変更があった場合にのみ「関数A」を実行する"
    fetchRestaurants()
    .then((data) =>
      console.log(data)
    )
  }, []) // []空配列の場合はコンポーネントを表示した初回のみ関数を実行する

  return (
    <Fragment>
      <h1>test</h1>
      <HeaderWrapper>
        <MainLogoImage src={MainLogo} alt="main logo" />
      </HeaderWrapper>
      <MainCoverImageWrapper>
        <MainCover src={MainCoverImage} alt="main cover" />
      </MainCoverImageWrapper>
    </Fragment>
  )
};
