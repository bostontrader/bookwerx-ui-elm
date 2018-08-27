module Model exposing ( Model )

import RemoteData exposing (WebData)
import Time exposing (Time)

import Route exposing ( Route )
import TypesB exposing ( Flags, FlashMsg)

import Account.Model exposing ( Model )
import Account.Account exposing ( Account )

import Category.Model exposing ( Model )
import Category.Category exposing ( Category )

import Currency.Model exposing ( Model )
import Currency.Currency exposing ( Currency )

import Transaction.Model exposing ( Model )
import Transaction.Transaction exposing ( Transaction )


type alias Model =
    { currentRoute : Route
    , flashMessages : List FlashMsg
    , nextFlashId : Int
    , currentTime : Time
    , runtimeConfig : Flags

    , accounts : Account.Model.Model
    , categories : Category.Model.Model
    , currencies : Currency.Model.Model
    , transactions : Transaction.Model.Model
    }
