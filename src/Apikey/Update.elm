module Apikey.Update exposing (apikeyUpdate)

import Apikey.Model exposing (Model)
import Apikey.MsgB exposing (MsgB(..))
import Apikey.Plumbing exposing (ApikeyPostHttpResponseRecord)
import Apikey.Post exposing (postApikeyCommand)
import Json.Decode as D
import Msg exposing (Msg)
import RemoteData
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


apikeyUpdate : MsgB -> Language -> Model -> { apikeys : Model, cmd : Cmd Msg, log : List String }
apikeyUpdate apikeyMsgB language model =
    case apikeyMsgB of
        PostApikey url ->
            { apikeys =
                { model | wdApikey = RemoteData.Loading }
            , cmd = postApikeyCommand url
            , log = [ "POST " ++ url ]
            }

        ApikeyPosted response ->
            { apikeys =
                { model
                    | wdApikey = response
                    , apikey =
                        case D.decodeString apikeyDecoder (getRemoteDataStatusMessage response language) of
                            Ok value ->
                                value.apikey

                            Err error ->
                                D.errorToString error
                }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage response language ]
            }

        UpdateApikey newApikey ->
            { apikeys = { model | apikey = newApikey }
            , cmd = Cmd.none
            , log = []
            }


apikeyDecoder : D.Decoder ApikeyPostHttpResponseRecord
apikeyDecoder =
    D.map (\k -> { apikey = k })
        (D.at [ "apikey" ] D.string)
