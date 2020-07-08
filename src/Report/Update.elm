module Report.Update exposing (update)

import Flash exposing (FlashMsg)
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Report.API.GetDistributions exposing (getDistributionsCmdA, getDistributionsCmdB)
import Report.Model exposing (ReportSection(..), ReportTypes(..))
import Report.Msg
import Report.Report exposing (SumsDecorated, sumsDecoratedDecoder)
import Translate exposing (Language)
import Util exposing (getRemoteDataStatusMessage)


update : Report.Msg.Msg -> Language -> Report.Model.Model -> { report : Report.Model.Model, cmd : Cmd Msg, log : List String, flashMessages : List FlashMsg }
update msgB language model =
    case msgB of
        Report.Msg.DistributionsReceivedA key wdDistributionReports ->
            let
                distributionReports =
                    case decodeString sumsDecoratedDecoder (getRemoteDataStatusMessage wdDistributionReports language) of
                        Ok value ->
                            value

                        Err _ ->
                            -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                            SumsDecorated []
            in
            { report =
                case key of
                    Assets ->
                        { model
                            | wdDistributionReportsA = wdDistributionReports
                            , distributionReportsA = distributionReports
                        }

                    Equity ->
                        { model
                            | wdDistributionReportsEq = wdDistributionReports
                            , distributionReportsEq = distributionReports
                        }

                    Expenses ->
                        { model
                            | wdDistributionReportsEx = wdDistributionReports
                            , distributionReportsEx = distributionReports
                        }

                    Liabilities ->
                        { model
                            | wdDistributionReportsL = wdDistributionReports
                            , distributionReportsL = distributionReports
                        }

                    Revenue ->
                        { model
                            | wdDistributionReportsR = wdDistributionReports
                            , distributionReportsR = distributionReports
                        }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage wdDistributionReports language ]
            , flashMessages = []
            }

        Report.Msg.DistributionsReceivedB wdDistributionReports ->
            { report =
                { model
                    | wdDistributionReports = wdDistributionReports
                    , distributionReports =
                        case decodeString sumsDecoratedDecoder (getRemoteDataStatusMessage wdDistributionReports language) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                SumsDecorated []
                }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage wdDistributionReports language ]
            , flashMessages = []
            }

        Report.Msg.FormChanged fmodel ->
            { report = { model | form = fmodel }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        Report.Msg.StockForm category stopTime ->
            let
                url =
                    model.reportURLBase ++ "&category_id=" ++ category ++ "&time_stop=" ++ stopTime ++ "&decorate=true"
            in
            { report = { model | wdDistributionReports = RemoteData.Loading, reportType = Just Stock }
            , cmd = getDistributionsCmdB url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        Report.Msg.FlowForm category startTime stopTime ->
            let
                url =
                    model.reportURLBase ++ "&category_id=" ++ category ++ "&time_start=" ++ startTime ++ "&time_stop=" ++ stopTime ++ "&decorate=true"
            in
            { report = { model | wdDistributionReports = RemoteData.Loading, reportType = Just Flow }
            , cmd = getDistributionsCmdB url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        Report.Msg.BSForm catA catL catEq catR catEx stopTime ->
            let
                baseUrl =
                    model.reportURLBase ++ "&time_stop=" ++ stopTime ++ "&decorate=true" ++ "&category_id="

                urls =
                    { assetsURL = baseUrl ++ catA
                    , liabilitiesURL = baseUrl ++ catL
                    , equityURL = baseUrl ++ catEq
                    , revenueURL = baseUrl ++ catR
                    , expensesURL = baseUrl ++ catEx
                    }
            in
            { report =
                { model
                    | reportType = Just BS
                    , wdDistributionReportsA = RemoteData.Loading
                    , wdDistributionReportsL = RemoteData.Loading
                    , wdDistributionReportsEq = RemoteData.Loading
                    , wdDistributionReportsR = RemoteData.Loading
                    , wdDistributionReportsEx = RemoteData.Loading
                }
            , cmd =
                Cmd.batch
                    [ getDistributionsCmdA urls.assetsURL Assets
                    , getDistributionsCmdA urls.liabilitiesURL Liabilities
                    , getDistributionsCmdA urls.equityURL Equity
                    , getDistributionsCmdA urls.revenueURL Revenue
                    , getDistributionsCmdA urls.expensesURL Expenses
                    ]
            , log =
                [ "GET " ++ urls.assetsURL
                , "GET " ++ urls.liabilitiesURL
                , "GET " ++ urls.equityURL
                , "GET " ++ urls.revenueURL
                , "GET " ++ urls.expensesURL
                ]
            , flashMessages = []
            }

        Report.Msg.PNLForm catR catEx startTime stopTime ->
            let
                baseUrl =
                    model.reportURLBase ++ "&time_start=" ++ startTime ++ "&time_stop=" ++ stopTime ++ "&decorate=true" ++ "&category_id="

                urls =
                    { revenueURL = baseUrl ++ catR
                    , expensesURL = baseUrl ++ catEx
                    }
            in
            { report =
                { model
                    | reportType = Just PNL
                    , wdDistributionReportsR = RemoteData.Loading
                    , wdDistributionReportsEx = RemoteData.Loading
                }
            , cmd =
                Cmd.batch
                    [ getDistributionsCmdA urls.revenueURL Revenue
                    , getDistributionsCmdA urls.expensesURL Expenses
                    ]
            , log =
                [ "GET " ++ urls.revenueURL
                , "GET " ++ urls.expensesURL
                ]
            , flashMessages = []
            }

        Report.Msg.ToggleOmitZeros ->
            { report = { model | omitZeros = not model.omitZeros }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        Report.Msg.UpdateDecimalPlaces newValue ->
            { report = { model | decimalPlaces = newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }
