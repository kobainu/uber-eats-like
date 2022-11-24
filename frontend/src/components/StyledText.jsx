// 複数コンポーネントから共通で使われる「styled-componentsで定義したテキストスタイル」を定義します
import styled from 'styled-components';
import { COLORS, FONT_SIZE } from '../style_constants';

// (文字が少し薄く、小さい)スタイル
export const SubText = styled.p`
  color: ${COLORS.SUB_TEXT};
  font-size: ${FONT_SIZE.BODY2};
`;
