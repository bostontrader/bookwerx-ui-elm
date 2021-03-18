module Acctcat.Update exposing (acctcatsUpdate)

import Acctcat.API.Delete exposing (deleteAcctcatCommand)
import Acctcat.API.GetMany exposing (getManyAcctcatsCommand)
import Acctcat.API.JSON exposing (acctcatsDecoder)
import Acctcat.API.Post exposing (postAcctcatCommand)
import Acctcat.Acctcat exposing (Acctcat)
import Acctcat.Model
import Acctcat.MsgB exposing (MsgB(..))
import Browser.Navigation as Nav
import Constants exposing (flashMessageDuration)
import Flash exposing (FlashMsg, FlashSeverity(..), expires)
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Route
import Routing exposing (extractUrl)
import Time
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


acctcatsUpdate : MsgB -> Nav.Key -> Language -> Time.Posix -> Acctcat.Model.Model -> { acctcats : Acctcat.Model.Model, cmd : Cmd Msg, flashMessages : List FlashMsg }
acctcatsUpdate acctcatMsgB key language currentTime model =
    case acctcatMsgB of
        -- delete
        DeleteAcctcat url ->
            { acctcats = model
            , cmd = deleteAcctcatCommand url
            , flashMessages = []
            }

        AcctcatDeleted response ->
            { acctcats = model
            , cmd = Nav.pushUrl key (extractUrl Route.CategoriesIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- edit
        UpdateAccountID newAccountID ->
            { acctcats = { model | editBuffer = updateAccountID model.editBuffer newAccountID }
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- getMany
        GetManyAcctcats category_id url ->
            { acctcats = { model | wdAcctcats = RemoteData.Loading, category_id = category_id }
            , cmd = getManyAcctcatsCommand url
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
            , flashMessages = []
            }


        -- post
        PostAcctcat url contentType body ->
            --( model, postAcctcatCommand model model.acctcats.editAcctcat )
            { acctcats = model
            , cmd = postAcctcatCommand url contentType body
            , flashMessages = []
            }

        AcctcatPosted response ->
            { acctcats = model
            , cmd = Nav.pushUrl key (extractUrl Route.CategoriesIndex)
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
