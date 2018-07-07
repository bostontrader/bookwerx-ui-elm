module Transactions.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (href, id, type_)
import Html.Events exposing (onClick, onInput)
import Types exposing
    ( Transaction
    , Model
    , Msg(CreateNewTransaction, NewTransactionNote)
    )


view : Model -> Html Msg
view model =
    div [ id "transactions-add" ]
        [ a [ id "transactions-index",  href "/transactions" ] [ text "Transactions" ]
        , h3 [] [ text "Create New Transaction" ]
        , newTransactionForm model.editTransaction
        ]


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