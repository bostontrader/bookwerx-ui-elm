module Distribution.Update exposing (distributionsUpdate)

import Browser.Navigation as Nav
import Constants exposing (flashMessageDuration)
import Distribution.API.Delete exposing (deleteDistributionCommand)
import Distribution.API.GetManyDistributionJoineds exposing (getManyDistributionJoinedsCommand)
import Distribution.API.GetOne exposing (getOneDistributionCommand)
import Distribution.API.JSON
    exposing
        ( distributionDecoder
        , distributionJoinedsDecoder
        )
import Distribution.API.Post exposing (postDistributionCommand)
import Distribution.API.Put exposing (putDistributionCommand)
import Distribution.Distribution exposing (DistributionEB, DistributionRaw)
import Distribution.Model
import Distribution.MsgB exposing (MsgB(..))
import Flash exposing (FlashMsg, FlashSeverity(..), expires)
import IntField exposing (IntField(..), intFieldToInt)
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Route exposing (Route(..))
import Routing exposing (extractUrl)
import Time
import Translate exposing (Language(..))
import Types exposing (DRCR(..))
import Util exposing (getRemoteDataStatusMessage)


distributionsUpdate : MsgB -> Nav.Key -> Language -> Time.Posix -> Distribution.Model.Model -> { distributions : Distribution.Model.Model, cmd : Cmd Msg, log : List String, flashMessages : List FlashMsg }
distributionsUpdate distributionMsgB key language currentTime model =
    case distributionMsgB of
        -- delete
        DeleteDistribution url ->
            { distributions = model
            , cmd = deleteDistributionCommand url
            , log = [ "DELETE " ++ url ]
            , flashMessages = []
            }

        DistributionDeleted response ->
            { distributions = model
            , cmd = Nav.pushUrl key (extractUrl DistributionsIndex)
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- getManyDistributionJoineds
        GetManyDistributionJoineds url ->
            { distributions = { model | wdDistributionJoineds = RemoteData.Loading }
            , cmd = getManyDistributionJoinedsCommand url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        DistributionJoinedsReceived newDistributionJoineds ->
            { distributions =
                { model
                    | wdDistributionJoineds = newDistributionJoineds
                    , distributionJoineds =
                        case decodeString distributionJoinedsDecoder (getRemoteDataStatusMessage newDistributionJoineds language) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage newDistributionJoineds language ]
            , flashMessages = []
            }

        -- getOne
        GetOneDistribution url ->
            { distributions = { model | wdDistribution = RemoteData.Loading }
            , cmd = getOneDistributionCommand url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        DistributionReceived response ->
            { distributions =
                case decodeString distributionDecoder (getRemoteDataStatusMessage response language) of
                    Ok value ->
                        { model | editBuffer = raw2EB value }

                    Err _ ->
                        -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                        model
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = []
            }

        -- put
        PutDistribution url contentType body ->
            { distributions = model
            , cmd = putDistributionCommand url contentType body
            , log = [ "PUT " ++ url ++ " " ++ contentType ++ " " ++ body ]
            , flashMessages = []
            }

        DistributionPutted response ->
            { distributions = model
            , cmd = Nav.pushUrl key (extractUrl DistributionsIndex)
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- post
        PostDistribution url contentType body ->
            { distributions = model
            , cmd = postDistributionCommand url contentType body
            , log = [ "POST " ++ url ++ " " ++ contentType ++ " " ++ body ]
            , flashMessages = []
            }

        DistributionPosted response ->
            { distributions = model
            , cmd = Nav.pushUrl key (extractUrl DistributionsIndex)
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        UpdateAccountID newValue ->
            { distributions = { model | editBuffer = updateAccountID model.editBuffer newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateFilterCurrencyID newValue ->
            { distributions = { model | editBuffer = updateCurrencyFilterID model.editBuffer newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateAmount newValue ->
            { distributions = { model | editBuffer = updateAmount model.editBuffer newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateAmountExp newValue ->
            { distributions = { model | editBuffer = updateAmountExp model.editBuffer newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateDecimalPlaces newValue ->
            { distributions = { model | decimalPlaces = newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateDRCR newValue ->
            { distributions = { model | editBuffer = updateDRCR newValue model.editBuffer }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }


raw2EB : DistributionRaw -> DistributionEB
raw2EB raw =
    DistributionEB
        raw.id
        raw.apikey
        raw.account_id
        -1 -- no currency filter
        (IntField (Just raw.amount) (String.fromInt raw.amount))
        (IntField (Just raw.amount_exp) (String.fromInt raw.amount_exp))
        raw.transaction_id
        (if raw.amount >= 0 then
            DR

         else
            CR
        )


updateAccountID : DistributionEB -> String -> DistributionEB
updateAccountID d newValue =
    { d
        | account_id =
            case String.toInt newValue of
                Just v ->
                    v

                Nothing ->
                    -1
    }

updateCurrencyFilterID : DistributionEB -> String -> DistributionEB
updateCurrencyFilterID d newValue =
    { d
        | currency_filter_id =
            case String.toInt newValue of
                Just v ->
                    v

                Nothing ->
                    -1
    }

--updateAmount : DistributionEB -> String -> DistributionEB
--updateAmount d newValue =
--{ d
--| amount =
--case String.toInt newValue of
--Just v ->
--(IntField (Just v) (String.fromInt v) )
--Nothing ->
--IntField (Just -1) "-1"
--}


updateAmount : DistributionEB -> String -> DistributionEB
updateAmount d newValue =
    { d
        | amount =
            case String.toInt newValue of
                Just v ->
                    IntField (Just v) newValue

                Nothing ->
                    IntField Nothing newValue
    }


updateAmountExp : DistributionEB -> String -> DistributionEB
updateAmountExp d newValue =
    { d
        | amount_exp =
            case String.toInt newValue of
                Just v ->
                    IntField (Just v) newValue

                Nothing ->
                    IntField Nothing newValue
    }


updateDRCR : String -> DistributionEB -> DistributionEB
updateDRCR drcr d =
    let
        newDEB =
            if drcr == "dr" then
                { d | drcr = DR }

            else
                { d | drcr = CR }

        absAmount =
            abs <| intFieldToInt <| d.amount

        negAmount =
            -absAmount
    in
    case newDEB.drcr of
        DR ->
            { newDEB | amount = IntField (Just absAmount) (String.fromInt absAmount) }

        CR ->
            { newDEB | amount = IntField (Just negAmount) (String.fromInt negAmount) }
