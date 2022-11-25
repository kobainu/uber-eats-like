import { REQUEST_STATE } from '../constants'; // 複数のファイル間で「いまAPIがどの状態なのか？」を参照しあうために使います

export const initialState = { // initialStateは初期stateです
  fetchState: REQUEST_STATE.INITIAL, // GET APIの状態を表すfetchState(一般的にAPIからデータを取得する時にfetch...というのでこのように命名)
  restaurantsList: [], // APIから取得したレストラン一覧が入ってきます。初期値は空配列として、[]を入れておきます。
};

export const restaurantsActionTypes = {
  FETCHING: 'FETCHING',
  FETCH_SUCCESS: 'FETCH_SUCCESS'
}

export const restaurantsReducer = (state, action) => { // restaurantsReducerは指定されたaction.typeに沿って、加工されたstateを返します
// reducer関数はstateとactionを引数にとります。これはuseReducerで使われるreducer関数としては固定、と考えていいでしょう
// stateとは初期状態であれば先ほど定義したinitialStateが、あるいは加工後のstateが入ります
// actionにはreducerを使う側が指定したrestaurantsActionTypesのいずれかが入ります
  switch (action.type) { // switch ... case ... defaultを使って、マッチするrestaurantsActionTypsが引数に渡されたら、それに対応するstateを返す
    case restaurantsActionTypes.FETCHING: // API取得中 => fetchStateはLOADINGにスイッチする
      return {
        ...state,
        fetchState: REQUEST_STATE.LOADING,
      };
    case restaurantsActionTypes.FETCH_SUCCESS: // API取得完了 => fetchStateをOKにスイッチし、restaurantsListにデータを入れる
      return {
        fetchState: REQUEST_STATE.OK,
        restaurantsList: action.payload.restaurants,
      };
    default:
      throw new Error();
  }
}

// reducerも要はコンポーネント側で注文した内容（action)と、それに対応するstateが返ってくるというだけ
