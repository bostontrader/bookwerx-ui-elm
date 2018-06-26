module App exposing (main)

import Html exposing (program)
import Navigation
import State exposing (init, update)
import Types exposing (Model, Msg(LocationChanged))
import View exposing (view)


main : Program Never Model Msg
main =
    Navigation.program LocationChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }