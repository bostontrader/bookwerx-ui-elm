module Account.Model exposing (Model)

import Account.Account exposing (Account, AccountJoined)
import Distribution.Distribution exposing (DistributionJoined)
import IntField exposing (IntField(..))
import RemoteData exposing (WebData)


type alias Model =
    { -- GetMany will respond with a 4 state RemoteData response.  If the response is "success" the response is a raw string that shall be decoded as a List of AccountJoined, -or- if it cannot be decoded it shall be assumed to be an error reported from the server. AccountJoined is the data for an Account with a few additional related fields joined as a UI convenience.
      accounts : List AccountJoined
    , wdAccounts : WebData String

    -- GetOne will respond with a 4 state RemoteData response.  If the response is "success" the response is a raw string that shall be decoded as a single Account, -or- if it cannot be decoded it shall be assumed to be an error reported from the server.  This is used for add/edit.  editBuffer is a conveniant place to assemble the value for a new Account or to modify the values of an existing Account, even if other joined fields are present.
    , editBuffer : Account
    , wdAccount : WebData String

    -- How many decimal places do we want to see in the Account's list of transactions?
    , decimalPlaces : Int

    -- GetAccountDistributionJoineds will get the distributionJoineds related to a particular account.
    , distributionJoineds : List DistributionJoined -- JSON decoded from wdDistributionsJoined
    , wdDistributionJoineds : WebData String -- the raw string response from GetTransactions
    }
