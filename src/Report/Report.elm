module Report.Report exposing (..)

import Account.Account exposing (AccountCurrency, accountCurrencyDecoder)
import DecimalFP exposing (DFP, dfpDecoder, DFPi, dfpiDecoder)
import Json.Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)


-- This alias and decoder directly matches a struct in bookwerx-core.
type alias BalanceResultDecorated =
    { account : AccountCurrency
    , sum : DFP
    }

balanceResultDecoratedDecoder : Decoder BalanceResultDecorated
balanceResultDecoratedDecoder =
    Json.Decode.succeed BalanceResultDecorated
        |> required "account" accountCurrencyDecoder
        |> required "sum" dfpDecoder


balanceResultsDecoratedDecoder : Decoder (List BalanceResultDecorated)
balanceResultsDecoratedDecoder =
    Json.Decode.list balanceResultDecoratedDecoder



type alias SumsDecorated =
    { sums : List BalanceResultDecorated }


sumsDecoratedDecoder : Decoder SumsDecorated
sumsDecoratedDecoder =
    Json.Decode.succeed SumsDecorated
        |> required "sums" balanceResultsDecoratedDecoder