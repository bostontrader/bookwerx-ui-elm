module Flash exposing (FlashMsg, FlashSeverity(..), expires, viewFlash)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Msg exposing (Msg)
import Time exposing (Posix)


type alias FlashMsg =
    { message : String
    , severity : FlashSeverity
    , expirationTime : Posix
    }


type FlashSeverity
    = FlashSuccess
    | FlashWarning
    | FlashError



-- Given the currentTime and a duration, return an expiration Posix time


expires : Posix -> Int -> Posix
expires currentTime duration =
    Time.millisToPosix (Time.posixToMillis currentTime + duration)


flashNotificationClass : FlashMsg -> String
flashNotificationClass flashMsg =
    case flashMsg.severity of
        FlashSuccess ->
            "notification is-success"

        FlashWarning ->
            "notification is-warning"

        FlashError ->
            "notification is-danger"


viewFlash : List FlashMsg -> Html Msg
viewFlash flashMsgs =
    div []
        (viewFlashElements flashMsgs)


viewFlashElements : List FlashMsg -> List (Html Msg)
viewFlashElements elements =
    List.map
        (\elem ->
            div
                [ class (flashNotificationClass elem) ]
                [ text elem.message ]
        )
        elements
