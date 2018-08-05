module App exposing (main)

import Html exposing (program)
import Navigation
import State exposing (init, update)
import Types exposing (Flags, Model, Msg(LocationChanged))
import View exposing (view)


--main : Program Never Model Msg
--main =
--    Navigation.program LocationChanged
--        { init = init
--        , view = view
--        , update = update
--        , subscriptions = \_ -> Sub.none
--        }

main : Program Flags Model Msg
main =
    Navigation.programWithFlags LocationChanged
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }