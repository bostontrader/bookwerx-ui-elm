module Lint.Update exposing (lintUpdate)

import Flash exposing (FlashMsg)
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import Lint.API.GetLints exposing (getLintsCmd)
import Lint.API.JSON exposing (lintsDecoder)
import Lint.Model
import Lint.MsgB exposing (MsgB(..))
import RemoteData
import Translate exposing (Language)
import Util exposing (getRemoteDataStatusMessage)


lintUpdate : MsgB -> Language -> Lint.Model.Model -> { lint : Lint.Model.Model, cmd : Cmd Msg, log : List String, flashMessages : List FlashMsg }
lintUpdate lintMsgB language model  =

    case lintMsgB of

       GetLintCategories url ->
            { lint = { model | wdLints = RemoteData.Loading, linter = "categories" }
            , cmd = getLintsCmd url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

       GetLintCurrencies url ->
            { lint = { model | wdLints = RemoteData.Loading, linter = "currencies" }
            , cmd = getLintsCmd url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

       LintsReceived wdLints ->
            { lint =
                { model | wdLints = wdLints
                    , lints =
                        case decodeString lintsDecoder (getRemoteDataStatusMessage wdLints language) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage wdLints language ]
            , flashMessages = []
            }

        --UpdatePrecision newValue ->
            --{ lint =
                --case newValue |> String.toInt |> Result.toMaybe of
                    --Nothing ->
                        --{ model | precision = IntField Nothing newValue }

                    --Just v ->
                        --{ model | precision = IntField (Just v) newValue }
            --, cmd = Cmd.none
            --, log = []
            --, flash = []
            --}

        --UpdateSOF newValue ->
            --{ lint =
                --if newValue == "stock" then
                    --{ model | sof = Just(Stock) }
                --else if newValue == "flow" then
                    --{ model | sof = Just(Flow) }
                --else
                    --model
            --, cmd = Cmd.none
            --, log = []
            --, flash = []
            --}