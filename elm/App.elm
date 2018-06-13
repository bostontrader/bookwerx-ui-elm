module App exposing (main)

import Html exposing (program)
import State exposing (init, update)
import View exposing (view)
import Types exposing (Model, Msg(LocationChanged))
import Navigation


main : Program Never Model Msg
main =
    Navigation.program LocationChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }