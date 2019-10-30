module Distribution.Model exposing (Model)

import Distribution.Distribution exposing (
    DistributionEB,
    DistributionJoined
    )

import RemoteData exposing (WebData)
import Types exposing (DRCR)
--import TypesB exposing (IntField(..))


type alias Model =
    { -- GetOne will respond with a 4 state RemoteData response.  If the response is "success" the response is a raw string that shall be decoded as a single of Distribution, -or- if it cannot be decoded it shall be assumed to be an error reported from the server.
      wdDistribution : WebData String
    , editBuffer : DistributionEB

    -- GetManyDistributionJoineds will respond with a 4 state RemoteData response.  If the response is "success" the response is a raw string that shall be decoded as a List of DistributionJoined, -or- if it cannot be decoded it shall be assumed to be an error reported from the server. DistributionJoined is the data for a Distribution with a few additional related fields joined as a UI convenience.
    , distributionJoineds : List DistributionJoined
    , wdDistributionJoineds : WebData String



    --, amountLHS : IntField
    --, amountRHS : IntField

    }
