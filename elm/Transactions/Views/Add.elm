module Transactions.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, label, text)
import Html.Attributes exposing (class, href, id, placeholder, type_)
import Html.Events exposing (onClick, onInput)

import Template exposing (template)
import Types exposing
    ( Transaction
    , Model
    , Msg(CreateNewTransaction, NewTransactionDatetime, NewTransactionNote)
    )


view : Model -> Html Msg
view model =
    template ( div [ id "transactions-add" ]
        [ h3 [ class "title is-3" ] [ text "Create New Transaction" ]
        , a [ id "transactions-index",  href "/transactions" ] [ text "Transactions" ]
        , newTransactionForm model.editTransaction
        ] )


newTransactionForm : Transaction -> Html Msg
newTransactionForm transaction =
    Html.form []
        [ div [class "field"]
            [ label [class "label"][ text "Date/time"]
            , div [class "control"]
                [ input
                    [ id "datetime"
                    , class "input"
                    , type_ "text"
                    , placeholder "yyyy-mm-ddThh:mm:ssZ"
                    , onInput NewTransactionDatetime
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
                    , onInput NewTransactionNote
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick CreateNewTransaction ]
                [ text "Submit" ]
            ]
        ]