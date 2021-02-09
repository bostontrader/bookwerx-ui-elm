module Distribution.MsgB exposing (MsgB(..))

import Distribution.Plumbing
    exposing
        ( DistributionPostHttpResponseString
        , DistributionPutHttpResponseString
        )
import RemoteData exposing (WebData)


type
    MsgB
    -- delete
    = DeleteDistribution String -- url
    | DistributionDeleted (WebData String)
      -- getMany
    | GetManyDistributionJoineds String
    | DistributionJoinedsReceived (WebData String)
      -- getOne
    | GetOneDistribution String
    | DistributionReceived (WebData String)
      -- put
    | PutDistribution String String String -- url content-type body
    | DistributionPutted (WebData DistributionPutHttpResponseString)
      -- post
    | PostDistribution String String String -- url content-type body
    | DistributionPosted (WebData DistributionPostHttpResponseString)
      -- edit
    | UpdateAccountID String
    | UpdateFilterCategoryID String
    | UpdateFilterCurrencyID String
    | UpdateAmount String
    | UpdateAmountExp String
    | UpdateDecimalPlaces Int
    | UpdateDRCR String
