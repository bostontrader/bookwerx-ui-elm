module Apikey.Plumbing exposing
    ( ApikeyPostHttpResponseRecord
    ,  ApikeyPostHttpResponseString
    )


-- We want to deal with the actual String of text returned by the POST as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.


type alias ApikeyPostHttpResponseRecord =
    { apikey : String }


type alias ApikeyPostHttpResponseString =
    String
