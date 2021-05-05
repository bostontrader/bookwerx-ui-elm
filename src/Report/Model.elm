module Report.Model exposing (..)

import Form.View
import RemoteData exposing (WebData)
import Report.Report exposing (SumsDecorated)


type alias Model =
    { -- stock or flow reports only need a single category
      distributionReports : SumsDecorated -- JSON decoded from wdDistributionReports
    , wdDistributionReports : WebData String -- the raw string http response

    -- We submit multiple parallel requests to get these so we need all of these to store the results.
    , distributionReportsA : SumsDecorated -- JSON decoded from wdDistributionReportsA
    , wdDistributionReportsA : WebData String -- the raw string http response
    , distributionReportsEq : SumsDecorated -- JSON decoded from wdDistributionReportsEq
    , wdDistributionReportsEq : WebData String -- the raw string http response
    , distributionReportsEx : SumsDecorated -- JSON decoded from wdDistributionReportsEx
    , wdDistributionReportsEx : WebData String -- the raw string http response
    , distributionReportsL : SumsDecorated -- JSON decoded from wdDistributionReportsL -- liabilities
    , wdDistributionReportsL : WebData String -- the raw string http response
    , distributionReportsR : SumsDecorated -- JSON decoded from wdDistributionReportsR
    , wdDistributionReportsR : WebData String -- the raw string http response
    , decimalPlaces : Int
    , omitZeros : Bool
    , form : FModel
    , reportType : Maybe ReportTypes
    , reportURLBase : String
    }


type alias FModel =
    Form.View.Model FValues


-- These are the raw values from the form.
type alias FValues =
    { category : String
    , categoryAssets : String
    , categoryEquity : String
    , categoryExpenses : String
    , categoryLiabilities : String
    , categoryRevenue : String
    , reportType : String
    , startTime : String
    , stopTime : String
    , title : String
    }


type alias ReportURLs =
    { assetsURL : String
    , equityURL : String
    , expensesURL : String
    , liabilitiesURL : String
    , revenueURL : String
    }


type ReportTypes
    = BS
    | Flow
    | PNL
    | Stock


type ManyCatTypes
    = BSm
    | PNLm


type ReportSection
    = Assets
    | Equity
    | Expenses
    | Liabilities
    | Revenue
