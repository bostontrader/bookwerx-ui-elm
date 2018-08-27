module Msg exposing ( Msg(..) )

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Time exposing (Time)

import Account.AccountMsgB exposing (..)
import Category.CategoryMsgB exposing (..)
import Currency.CurrencyMsgB exposing (..)
import Transaction.TransactionMsgB exposing (..)

type Msg
    = LocationChanged Location
    | UpdateCurrentTime Time
    --| CreateFlashElement String Int Time
    | TimeoutFlashElements Time

    | AccountMsgA AccountMsgB
    | CategoryMsgA CategoryMsgB
    | CurrencyMsgA CurrencyMsgB
    | TransactionMsgA TransactionMsgB
