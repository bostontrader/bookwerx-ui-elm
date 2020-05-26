module BS.Update exposing (update)

import BS.API.GetDistributions exposing (getDistributionsCmd)
import BS.Model exposing (BSSection(..) )
import BS.MsgB exposing (MsgB(..))
import Distribution.API.JSON exposing (distributionReportsDecoder)
import Flash exposing (FlashMsg)
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Translate exposing (Language)
import Util exposing (getRemoteDataStatusMessage)


update : MsgB -> Language -> BS.Model.Model -> { bs : BS.Model.Model, cmd : Cmd Msg, log : List String, flashMessages : List FlashMsg }
update msgB language model =
    case msgB of
        GetDistributions assetsCategory liabilitiesCategory equityCategory revenueCategory expensesCategory asofTime ->
            let
                base = model.bsURLBase ++ "&time=" ++ asofTime ++ "&category_id="
                urls = { assetsURL = base ++ assetsCategory
                    , equityURL = base ++ equityCategory
                    , expensesURL = base ++ expensesCategory
                    , liabilitiesURL = base ++ liabilitiesCategory
                    , revenueURL = base ++ revenueCategory
                    }

            in

                { bs = { model
                    | wdDistributionReportsA = RemoteData.Loading
                    , wdDistributionReportsEq = RemoteData.Loading
                    , wdDistributionReportsEx = RemoteData.Loading
                    , wdDistributionReportsL = RemoteData.Loading
                    , wdDistributionReportsR = RemoteData.Loading
                    }
                , cmd = Cmd.batch
                    [ getDistributionsCmd urls.assetsURL Assets
                    , getDistributionsCmd urls.equityURL Equity
                    , getDistributionsCmd urls.expensesURL Expenses
                    , getDistributionsCmd urls.liabilitiesURL Liabilities
                    , getDistributionsCmd urls.revenueURL Revenue
                    ]

                , log =
                    [ "GET " ++ urls.assetsURL
                    , "GET " ++ urls.equityURL
                    , "GET " ++ urls.expensesURL
                    , "GET " ++ urls.liabilitiesURL
                    , "GET " ++ urls.revenueURL
                    ]
                , flashMessages = []
                }

        DistributionsReceived key wdDistributionReports ->
            let
                distributionReports =
                    case decodeString distributionReportsDecoder (getRemoteDataStatusMessage wdDistributionReports language) of
                        Ok value ->
                            value

                        Err _ ->
                            -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                            []
            in
                { bs = case key of
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

        FormChanged fmodel  ->
            { bs = { model | form = fmodel }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }
