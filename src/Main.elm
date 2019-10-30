--port module Main exposing (Model, Msg(..), add1, init, main, toJs, update, view)
module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Constants exposing (..)
import Init exposing (init)
import Model
import Msg exposing (Msg(..))
import Time
import Update exposing (update)
import Url
import View exposing (view)


main : Program () Model.Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }


subscriptions : Model.Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every flashMessagePollInterval UpdateCurrentTime
        , Time.every flashMessagePollInterval TimeoutFlashElements
        ]