module Util exposing
    ( getAccountTitle
    , getCurrencySymbol
    , getRemoteDataStatusMessage
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



-- Given an account_id, return the associated currency symbol


getCurrencySymbol : Account.Model.Model -> Int -> String
getCurrencySymbol model account_id =
    case List.head (List.filter (\c -> c.id == account_id) model.accounts) of
        Just c ->
            c.currency.symbol

        Nothing ->
            ""



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
