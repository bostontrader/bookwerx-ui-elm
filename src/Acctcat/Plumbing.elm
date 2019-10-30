module Acctcat.Plumbing exposing
    ( AcctcatPostHttpResponseString
    , AcctcatPutHttpResponseString
    )


-- We want to deal with the actual String of text returned by the POST as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.


--type alias AcctcatPostHttpResponseRecord =
--    Int

type alias AcctcatPostHttpResponseString =
    String



-- We want to deal with the actual String of text returned by the PUT as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias AcctcatPutHttpResponseRecord =
--{ last_insert_id : String }


type alias AcctcatPutHttpResponseString =
    String
