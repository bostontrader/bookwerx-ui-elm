module Translate exposing (Language(..), tx, tx_accounts, tx_delete, tx_edit, tx_request, tx_response, tx_save)

type Language
    = English
    | Chinese
    | Pinyin

tx : Language -> { e : String, c : String, p : String } -> String
tx language t =
    case language of
        English ->
            t.e

        Chinese ->
            t.c

        Pinyin ->
            t.p


tx_accounts : Language -> String
tx_accounts language =
    tx language { e = "Accounts", c = "账户", p = "zhàng hù" }


tx_delete : Language -> String
tx_delete language =
    tx language { e = "Delete", c = "删除", p = "shān chú" }


tx_edit : Language -> String
tx_edit language =
    tx language { e = "Edit", c = "编辑", p = "biān jí" }


tx_request : Language -> String
tx_request language =
    tx language { e = "Request", c = "请求", p = "qǐng qiú" }


tx_response : Language -> String
tx_response language =
    tx language { e = "Response", c = "响应", p = "xiǎng yìng" }


tx_save : Language -> String
tx_save language =
    tx language { e = "Save", c = "保存", p = "bǎo cún" }
