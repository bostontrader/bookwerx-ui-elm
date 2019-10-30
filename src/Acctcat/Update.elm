module Acctcat.Update exposing (acctcatsUpdate)

import Acctcat.API.Delete exposing (deleteAcctcatCommand)
import Acctcat.API.GetMany exposing (getManyAcctcatsCommand)
import Acctcat.API.JSON exposing (acctcatsDecoder)
import Acctcat.API.Post exposing (postAcctcatCommand)
import Acctcat.Acctcat exposing (Acctcat)
import Acctcat.MsgB exposing (MsgB(..))
import Acctcat.Model
import Browser.Navigation as Nav
import Constants exposing (flashMessageDuration)
import Flash exposing (FlashMsg, FlashSeverity(..), expires)
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Route exposing (..)
import Routing exposing (extractUrl)
import Time
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


acctcatsUpdate : MsgB -> Nav.Key -> Language -> Time.Posix -> Acctcat.Model.Model -> { acctcats : Acctcat.Model.Model, cmd : Cmd Msg, log : List String, flashMessages : List FlashMsg }
acctcatsUpdate   acctcatMsgB key language currentTime model =

    case acctcatMsgB of
        -- delete
        DeleteAcctcat url ->
            { acctcats = model
            , cmd = deleteAcctcatCommand url
            , log = [ "DELETE " ++ url ]
            , flashMessages = []
            }

        AcctcatDeleted response ->
            { acctcats = model
            , cmd = Nav.pushUrl key (extractUrl CategoriesIndex)
            , log = [ getRemoteDataStatusMessage response English ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- edit
        --UpdateRarity newValue ->
        --{ acctcats = { model | editBuffer = updateRarity model.editBuffer newValue }
        --, cmd = Cmd.none
        --, log = []
        --, flashMessages = []
        --}
        -- edit
        UpdateAccountID newAccountID ->
            { acctcats = { model | editBuffer = updateAccountID model.editBuffer newAccountID }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        --UpdateRarityFilter newValue ->
        --{ acctcats = case newValue |> String.toInt |> Result.toMaybe of
        --Nothing ->
        --{ model | rarityFilter = IntField Nothing newValue }
        --Just v ->
        --{ model | rarityFilter = IntField (Just v) newValue }
        --, cmd = Cmd.none
        --, log = []
        --, flashMessages = []
        --}
        --UpdateAcctcatAccount newSymbol ->
        --let
        --n = Debug.log "select" newSymbol
        --in
        --{ acctcats = model
        --, cmd = Cmd.none
        --, log = []
        --, flashMessages = []
        --}
        -- getMany
        GetManyAcctcats category_id url ->
            { acctcats = { model | wdAcctcats = RemoteData.Loading, category_id = category_id }
            , cmd = getManyAcctcatsCommand url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        AcctcatsReceived newAcctcatsB ->
            { acctcats =
                { model
                    | wdAcctcats = newAcctcatsB
                    , acctcats =
                        case decodeString acctcatsDecoder (getRemoteDataStatusMessage newAcctcatsB English) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage newAcctcatsB English ]
            , flashMessages = []
            }

        -- getOne
        --GetOneAcctcat url ->
        --{ acctcats = { model | wdAcctcat = RemoteData.Loading }
        --, cmd = getOneAcctcatCommand url
        --, log = [ "GET " ++ url ]
        --, flashMessages = []
        --}
        --AcctcatReceived response ->
        --{ acctcats =
        --case decodeString acctcatDecoder (getRemoteDataStatusMessage response) of
        --Ok value ->
        --{ model | editBuffer = value }
        --Err error ->
        -- in case of err, see the wdAcctcats raw string
        --model
        --, cmd = Cmd.none
        --, log = [ getRemoteDataStatusMessage response ]
        --, flashMessages = []
        --}
        -- post
        PostAcctcat url contentType body ->
            --( model, postAcctcatCommand model model.acctcats.editAcctcat )
            { acctcats = model
            , cmd = postAcctcatCommand url contentType body
            , log = [ "POST " ++ url ++ " " ++ contentType ++ " " ++ body ]
            , flashMessages = []
            }

        AcctcatPosted response ->
            { acctcats = model
            , cmd = Nav.pushUrl key (extractUrl CategoriesIndex)
            , log = [ getRemoteDataStatusMessage response English ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }


updateAccountID : Acctcat -> String -> Acctcat
updateAccountID c newValue =
    { c
        | account_id =
            case String.toInt newValue of
                Just v ->
                    v

                Nothing ->
                    -1
    }
