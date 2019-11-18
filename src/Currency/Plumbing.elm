module Currency.Plumbing exposing
    ( CurrencyPostHttpResponseString
    , CurrencyPutHttpResponseString
    )

-- We want to deal with the actual String of text returned by the POST as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias CurrencyPostHttpResponseRecord =
--Int


type alias CurrencyPostHttpResponseString =
    String



-- We want to deal with the actual String of text returned by the PUT as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias CurrencyPutHttpResponseRecord =
--{ last_insert_id : String }


type alias CurrencyPutHttpResponseString =
    String
