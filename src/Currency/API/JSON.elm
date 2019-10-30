module Currency.API.JSON exposing
    ( currenciesDecoder
    , currencyDecoder
    , currencyShortDecoder
    )

import Currency.Currency exposing (Currency, CurrencyShort)
import Json.Decode exposing (Decoder, int, map, string)
import Json.Decode.Pipeline exposing (required)
import IntField exposing (IntField(..))


currenciesDecoder : Decoder (List Currency)
currenciesDecoder =
    Json.Decode.list currencyDecoder

currencyDecoder : Decoder Currency
currencyDecoder =
    Json.Decode.succeed Currency
        |> required "id" int
        |> required "apikey" string
        |> required "rarity" (map (\n -> IntField (Just n) (String.fromInt n)) int)
        |> required "symbol" string
        |> required "title" string


currencyShortDecoder : Decoder CurrencyShort
currencyShortDecoder =
    Json.Decode.succeed CurrencyShort
        |> required "symbol" string
        |> required "title" string
