module Transactions.Views.Edit exposing (view)

import Html exposing (Html, a, button, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Template exposing (template)
import Types exposing
    ( BWCore_Error
    , Model
    , Msg(SubmitUpdatedTransaction, UpdateTransactionDatetime, UpdateTransactionNote)
    , Transaction
    , TransactionPostHttpResponse(..)
    )

view : Model -> Html Msg
view model =
    template ( div [ id "transactions-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Transaction" ]
        , a [ id "transactions-index", href "/ui/transactions" ] [ text "Transactions index" ]
        , viewTransactionOrError model
        ] )


viewTransactionOrError : Model -> Html Msg
viewTransactionOrError model =
    case model.wdTransaction of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success aehr ->
            case aehr of
                ValidTransactionPostResponse wdTransaction ->
                    editForm model.editTransaction

                ErrorTransactionPostResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Transaction error..." ]

viewErrors : List BWCore_Error -> Html Msg
viewErrors errors =
    div [ id "errors"]
        [ h3 [] [ text "Errors" ]
        , table []
            [ thead [][viewTableHeader]
            , tbody [] (List.map viewError errors)
            ]
        ]

viewError : BWCore_Error -> Html Msg
viewError error =
    tr []
        [ td []
            [ text error.key ]
        , td []
            [ text error.value ]
        ]

viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "key" ]
        , th []
            [ text "value" ]
        ]

editForm : Transaction -> Html Msg
editForm transaction =
    Html.form []
        [ div [class "field"]
            [ label [class "label"][ text "Date/time"]
            , div [class "control"]
                [ input
                    [ id "datetime"
                    , class "input"
                    , type_ "text"
                    , value transaction.datetime
                    , onInput UpdateTransactionDatetime
                    ][]
                ]
            ]

        , div [class "field"]
            [ label [class "label"][ text "Note"]
            , div [class "control"]
                [ input
                    [ id "note"
                    , class "input"
                    , type_ "text"
                    , value transaction.note
                    , onInput UpdateTransactionNote
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick SubmitUpdatedTransaction ]
                [ text "Submit" ]
            ]
        ]
