module App exposing ( main )

import Html exposing ( program )
import Navigation
import Time exposing ( every, second )

import Model exposing ( Model )
import Msg exposing (..)
import State exposing ( init, update )
import TypesB exposing ( Flags )
import View exposing ( view )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags LocationChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ every second UpdateCurrentTime
        , every second TimeoutFlashElements
        ]