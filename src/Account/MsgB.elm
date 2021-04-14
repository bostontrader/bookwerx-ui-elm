module Account.MsgB exposing (MsgB(..))

import Account.Plumbing
    exposing
        ( AccountPostHttpResponseString
        , AccountPutHttpResponseString
        )
import RemoteData exposing (WebData)


type
    MsgB
    -- delete
    = DeleteAccount String -- url
    | AccountDeleted (WebData String)
      -- getMany
    | GetManyAccounts String
    | AccountsReceived (WebData String)
      -- getManyDistributionJoineds
    | GetAccountDistributionJoineds String
    | AccountDistributionJoinedsReceived (WebData String)
      -- getOne
    | GetOneAccount String
    | AccountReceived (WebData String)
      -- put
    | PutAccount String String String -- url content-type body
    | AccountPutted (WebData AccountPutHttpResponseString)
      -- post
    | PostAccount String String String -- url content-type body
    | AccountPosted (WebData AccountPostHttpResponseString)
      -- edit
    | UpdateCurrencyID String
    | UpdateDecimalPlaces Int
    | UpdateFilterCategoryID String
    | ToggleFilterCategoryInvert
    | UpdateTitle String
