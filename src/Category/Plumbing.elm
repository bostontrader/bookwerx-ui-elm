module Category.Plumbing exposing
    ( CategoryPostHttpResponseString
    , CategoryPutHttpResponseString
    )

-- We want to deal with the actual String of text returned by the POST as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias CategoryPostHttpResponseRecord =
--Int


type alias CategoryPostHttpResponseString =
    String



-- We want to deal with the actual String of text returned by the PUT as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias CategoryPutHttpResponseRecord =
--{ last_insert_id : String }


type alias CategoryPutHttpResponseString =
    String
