-- API Level C.  See README.md
module Account.API.Patch exposing ( patchAccountCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( AccountMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( AccountsPatch ) )

import Account.API.JSON exposing ( accountDecoder, accountEncoder )
import Account.Plumbing exposing ( AccountPatchHttpResponse (..) )
import Account.Account exposing ( Account )
import Account.AccountMsgB exposing ( AccountMsgB ( AccountPatched ) )


patchAccountCommand : Account -> Cmd Msg
patchAccountCommand account =
    ( Http.request
        { method = "PATCH"
        , headers = []
        , url = ( extractUrlProxied AccountsPatch )  ++ account.id
        , body = Http.jsonBody (accountEncoder account)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map AccountPatched
    |> Cmd.map AccountMsgA


responseDecoder : Decoder AccountPatchHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorAccountPatchDecoder
        ]


dataResponseDecoderA : Decoder AccountPatchHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> AccountPatchDataResponse response.data)
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" accountDecoder
-- need this because I cannot substitute the literal
type alias Catfood = { data : Account }


errorAccountPatchDecoder : Decoder AccountPatchHttpResponse -- Same!
errorAccountPatchDecoder =
    Json.Decode.map
    (\response -> AccountPatchErrorsResponse response.errors)
    errorsResponseDecoder
