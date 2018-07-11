module Transactions.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (class, href, id, type_)
import Html.Events exposing (onClick, onInput)

import Template exposing (template)
import Types exposing
    ( Transaction
    , Model
    , Msg(CreateNewTransaction, NewTransactionNote)
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
        [ div []
            [ text "Note"
            , br [][]
            , input
                [ id "note", type_ "text"
                , onInput NewTransactionNote
                ]
                []
            ]
        , br [][]
        , div []
            [ button
                [ id "save"
                , onClick CreateNewTransaction
                ]
                [ text "Submit" ]
            ]
        ]