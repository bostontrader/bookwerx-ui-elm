module Report.Update exposing (reportUpdate)

import Distribution.API.JSON exposing (distributionReportsDecoder)
import Json.Decode exposing (decodeString)
import Flash exposing (FlashMsg)
import IntField exposing (IntField(..))
import Msg exposing (Msg(..))
import Report.API.GetDistributions exposing (getDistributionsCmd)
import Report.Model exposing (StockOrFlow(..))
import RemoteData
import Report.MsgB exposing (MsgB(..))
import Translate exposing (Language)
--import TypesB exposing (, IntField(..))
import Util exposing (getRemoteDataStatusMessage)


reportUpdate : MsgB -> Language -> Report.Model.Model -> { report : Report.Model.Model, cmd : Cmd Msg, log : List String, flashMessages : List FlashMsg }
reportUpdate reportMsgB language model =

    case reportMsgB of

        GetDistributions url ->
            { report = { model | wdDistributionReports = RemoteData.Loading }
            , cmd = getDistributionsCmd url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        DistributionsReceived wdDistributionReports ->
            { report =
                { model | wdDistributionReports = wdDistributionReports
                    , distributionReports =
                        case decodeString distributionReportsDecoder (getRemoteDataStatusMessage wdDistributionReports language) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage wdDistributionReports language ]
            , flashMessages = []
            }

        UpdateCategoryID newValue ->
            { report =
                case newValue |> String.toInt of
                    Nothing ->
                        { model | category_id = -1, uiLevel = 1 }

                    Just v ->
                        { model | category_id = v, uiLevel = 1 }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }


        UpdateDecimalPlaces newValue ->
            { report =
                case newValue |> String.toInt of
                    Nothing ->
                        { model | decimalPlaces = IntField Nothing newValue }

                    Just v ->
                        { model | decimalPlaces = IntField (Just v) newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateSOF newValue ->
            { report =
                if newValue == "stock" then
                    { model | sof = Just Stock, uiLevel = 2 }
                else if newValue == "flow" then
                    { model | sof = Just Flow, uiLevel = 2 }
                else
                    model
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateStartTime newValue ->
            { report = { model | startTime = newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateStopTime newValue ->
            { report = { model | stopTime = newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }