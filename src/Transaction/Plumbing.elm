module Transaction.Plumbing exposing
    ( TransactionPostHttpResponseString
    , TransactionPutHttpResponseString
    )

-- We want to deal with the actual String of text returned by the POST as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias TransactionPostHttpResponseRecord =
--Int


type alias TransactionPostHttpResponseString =
    String



-- We want to deal with the actual String of text returned by the PUT as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias TransactionPutHttpResponseRecord =
--{ last_insert_id : String }


type alias TransactionPutHttpResponseString =
    String
