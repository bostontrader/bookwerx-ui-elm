module Report.Model exposing (Model, StockOrFlow(..))

import Distribution.Distribution exposing (DistributionReport)
import IntField exposing (IntField(..))
import RemoteData exposing (WebData)


type alias Model =
    { distributionReports : List DistributionReport -- JSON decoded from wdAccounts
    , wdDistributionReports : WebData String -- the raw string http response
    , decimalPlaces : IntField
    , category_id : Int
    , startTime : String
    , sof : Maybe StockOrFlow
    , stopTime : String
    , uiLevel : Int
    }

type StockOrFlow
    = Stock
    | Flow
