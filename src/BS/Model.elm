module BS.Model exposing (Model, BSSection(..), BSURLs, FModel, FValues)

import Distribution.Distribution exposing (DistributionReport)
import Form.View
import RemoteData exposing (WebData)

type alias Model =
    { category_idA : Maybe Int -- assets
    , distributionReportsA : List DistributionReport -- JSON decoded from wdDistributionReportsA
    , wdDistributionReportsA : WebData String -- the raw string http response

    , category_idEq : Maybe Int -- equity
    , distributionReportsEq : List DistributionReport -- JSON decoded from wdDistributionReportsEq
    , wdDistributionReportsEq : WebData String -- the raw string http response

    , category_idEx : Maybe Int -- equity
    , distributionReportsEx : List DistributionReport -- JSON decoded from wdDistributionReportsEx
    , wdDistributionReportsEx : WebData String -- the raw string http response

    , category_idL : Maybe Int -- liabilities
    , distributionReportsL : List DistributionReport -- JSON decoded from wdDistributionReportsL -- liabilities
    , wdDistributionReportsL : WebData String -- the raw string http response

    , category_idR : Maybe Int -- equity
    , distributionReportsR : List DistributionReport -- JSON decoded from wdDistributionReportsR
    , wdDistributionReportsR : WebData String -- the raw string http response

    , decimalPlaces : Int
    , omitZeros : Bool

    , form : FModel
    , bsURLBase : String
    }


type alias FModel =
    Form.View.Model FValues

type alias FValues =
    { assetsCategory : String
    , equityCategory : String
    , expensesCategory : String
    , liabilitiesCategory : String
    , revenueCategory : String
    , asofTime : String
    }

type alias BSURLs =
    { assetsURL : String
    , equityURL : String
    , expensesURL : String
    , liabilitiesURL : String
    , revenueURL : String
    }

type BSSection
    = Assets
    | Equity
    | Expenses
    | Liabilities
    | Revenue
