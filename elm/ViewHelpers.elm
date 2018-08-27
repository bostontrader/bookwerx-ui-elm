module ViewHelpers exposing
    ( viewErrors
    , viewFlash
    )

import Html exposing ( Html, div, h3, table, tbody, td, text, th, thead, tr )
import Html.Attributes exposing ( class, id )

import TypesB exposing
    ( BWCore_Error
    , FlashMsg
    , FlashSeverity(..)
    )

import Msg exposing ( Msg )

viewErrors : List BWCore_Error -> Html Msg
viewErrors errors =
    div [ id "errors"]
        [ h3 [] [ text "Errors" ]
        , table []
            [ thead [][ viewTableHeader ]
            , tbody [] ( List.map viewError errors )
            ]
        ]


viewError : BWCore_Error -> Html Msg
viewError error =
    tr []
        [ td [][ text error.key ]
        , td [][ text error.value ]
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "key" ]
        , th []
            [ text "value" ]
        ]


viewFlash : List FlashMsg -> Html Msg
viewFlash flashMsgs =
    div [  ]
        [ viewFlashB flashMsgs ]


viewFlashB : List FlashMsg -> Html Msg
viewFlashB elements =
    div []
        (viewFlashElements elements)


viewFlashElements : List FlashMsg -> List (Html Msg)
viewFlashElements elements =
    List.map
        ( \elem ->
            div
                [ class (flashNotificationClass elem) ]
                [text elem.message]
        )
        elements

flashNotificationClass : FlashMsg -> String
flashNotificationClass flashMsg =
    case flashMsg.severity of
        FlashSuccess ->
            "notification is-success"
        FlashWarning ->
            "notification is-warning"
        FlashError ->
            "notification is-danger"