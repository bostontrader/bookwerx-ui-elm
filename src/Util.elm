module Util exposing
    (  getAccountTitle
       --, getCurrencyTitle

    ,  getRemoteDataStatusMessage
       --, roundingAlertStyle
       --, updateTutorialLevel

    )

import Account.Model
import Http
import RemoteData exposing (WebData)
import Translate exposing (Language(..), tx)


getAccountTitle : Account.Model.Model -> Int -> String
getAccountTitle model cid =
    case List.head (List.filter (\c -> c.id == cid) model.accounts) of
        Just c ->
            c.title

        Nothing ->
            "not set"



--getCurrencyTitle : Currency.Model.Model -> Int -> String
--getCurrencyTitle model cid =
--case List.head (List.filter (\c -> c.id == cid) model.currencies) of
--Just c ->
--c.title
--Nothing ->
--"not set"


getRemoteDataStatusMessage : WebData String -> Language -> String
getRemoteDataStatusMessage response language =
    case response of
        RemoteData.NotAsked ->
            tx language { e = "Request not yet sent", c = "尚未发送的请求", p = "Request not yet sent" }

        RemoteData.Loading ->
            tx language { e = "Loading...", c = "装载", p = "zhuāngzǎi" }

        RemoteData.Success result ->
            result

        RemoteData.Failure httpError ->
            case httpError of
                Http.BadUrl _ ->
                    "badurl"

                Http.Timeout ->
                    "timeout"

                Http.NetworkError ->
                    tx language { e = "Network error", c = "网络错误", p = "wǎngluò cuòwù" }

                Http.BadStatus _ ->
                    "bad status"

                Http.BadBody s ->
                    "bad body" ++ s



--roundingAlertStyle : Int -> Int -> List ( String, String )
--roundingAlertStyle p exp =
--if p < exp then
--[ ( "background-color", "red" ) ]
--[]
--else
--[ ( "background-color", "green" ) ]
--[]
