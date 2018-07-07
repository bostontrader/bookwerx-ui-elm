module Transactions.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (href, id, type_)
import Html.Events exposing (onClick, onInput)
import Types exposing
    ( Transaction
    , Model
    , Msg(CreateNewTransaction, NewTransactionDesc)
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
            [ text "Description"
            , br [][]
            , input
                [ id "desc", type_ "text"
                , onInput NewTransactionDesc
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