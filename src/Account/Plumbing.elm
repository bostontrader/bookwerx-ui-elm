module Account.Plumbing
    exposing
        ( AccountPostHttpResponseString
        , AccountPutHttpResponseString
        )


-- We want to deal with the actual String of text returned by the POST as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.


--type alias AccountPostHttpResponseRecord =
--    Int

type alias AccountPostHttpResponseString =
    String



-- We want to deal with the actual String of text returned by the PUT as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias AccountPutHttpResponseRecord =
--{ last_insert_id : String }


type alias AccountPutHttpResponseString =
    String
