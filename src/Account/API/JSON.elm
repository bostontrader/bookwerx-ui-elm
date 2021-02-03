module Account.API.JSON exposing
    ( accountDecoder
    , accountJoinedsDecoder
    , accountsDecoder
    )

import Account.Account exposing (Account, AccountJoined)
import Category.API.JSON exposing (categoryShortDecoder)
import Currency.API.JSON exposing (currencyShortDecoder)
import IntField exposing (IntField(..))
import Json.Decode exposing (Decoder, int, map, string)
import Json.Decode.Pipeline exposing (optional, required)


accountsDecoder : Decoder (List Account)
accountsDecoder =
    Json.Decode.list accountDecoder


accountDecoder : Decoder Account
accountDecoder =
    Json.Decode.succeed Account
        |> required "id" int
        |> required "apikey" string
        |> required "currency_id" int
        |> required "title" string


accountJoinedsDecoder : Decoder (List AccountJoined)
accountJoinedsDecoder =
    Json.Decode.list accountJoinedDecoder


accountJoinedDecoder : Decoder AccountJoined
accountJoinedDecoder =
    Json.Decode.succeed AccountJoined
        |> required "id" int
        |> required "apikey" string
        |> required "categories" (Json.Decode.list categoryShortDecoder)
        |> required "currency" currencyShortDecoder
        |> required "title" string
