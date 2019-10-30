module Distribution.Plumbing exposing
    ( -- DistributionId
     DistributionPostHttpResponseString
    , DistributionPutHttpResponseString
    )

--import Distribution.Distribution exposing (Distribution)
--import Http
--import RemoteData exposing (WebData)
--import TypesB exposing (BWCore_Error, FlashMsg)


--type alias DistributionId =
    --Int



-- We want to deal with the actual String of text returned by the POST as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.


--type alias DistributionPostHttpResponseRecord =
    --{ last_insert_id : String }


type alias DistributionPostHttpResponseString =
    String



-- We want to deal with the actual String of text returned by the PUT as well as a suitably structured record that can be filled by interpreting the String as JSON and decoding into a record.
--type alias DistributionPutHttpResponseRecord =
--{ last_insert_id : String }


type alias DistributionPutHttpResponseString =
    String
