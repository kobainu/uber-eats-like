// 例外時(他の店舗における仮注文がある状態で、別の店舗で仮注文を新規作成しようとしたケース)に出すモーダルコンポーネント

import React from 'react';

// components
import { DialogContent, Dialog, DialogTitle } from '@material-ui/core';
import { OrderButton } from './Buttons/OrderButton';

export const NewOrderConfirmDialog = ({
  isOpen,
  onClose,
  existingRestaurantName, // 他店舗の名前
  newRestaurantName,      // いま選択した店舗の名前
  onClickSubmit,           // 仮注文の置き換えAPIを呼ぶ(「新規注文を開始しますか？ => はい => 置き換えAPIを呼ぶ」という流れになります)
}) => (
  <Dialog
    open={isOpen}
    onClose={onClose}
    maxWidth="xs"
  >
    <DialogTitle>
      新規注文を開始しますか？
    </DialogTitle>
    <DialogContent>
      <p>
        {
          `ご注文に ${existingRestaurantName} の商品が含まれています。
          新規の注文を開始して ${newRestaurantName} の商品を追加してください。`
        }
      </p>
      {/* 先ほど作ったOrderButtonをここで使用 */}
      <OrderButton onClick={onClickSubmit}>
        新規注文
      </OrderButton>
    </DialogContent>
  </Dialog>
);
