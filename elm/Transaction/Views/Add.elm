module Transaction.Views.Add exposing ( view )

import Html exposing ( Html, a, br, button, div, h3, input, label, text )
import Html.Attributes exposing ( class, href, id, placeholder, type_ )
import Html.Events exposing ( onClick, onInput )

import Template exposing ( template )

import Model
import Msg exposing ( Msg( TransactionMsgA ) )
import ViewHelpers exposing ( viewFlash )

import Transaction.Model
import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing
    ( TransactionMsgB
        ( PostTransaction, UpdateTransactionDatetime, UpdateTransactionNote )
    )


view : Model.Model -> Html Msg
view model =
    template ( div [ id "transactions-add" ]
        [ h3 [ class "title is-3" ] [ text "Create New Transaction" ]
        , viewFlash model.flashMessages
        , a [ id "transactions-index",  href "/#ui/transactions" ] [ text "Transactions" ]
        , newTransactionForm model.transactions.editTransaction
        ] )


newTransactionForm : Transaction -> Html Msg
newTransactionForm transaction =
    -- don't use form lest the subsequent post xhr get fubared
    -- Html.form []
    div []
        [ div [class "field"]
            [ label [class "label"][ text "Date/time"]
            , div [class "control"]
                [ input
                    [ id "datetime"
                    , class "input"
                    , type_ "text"
                    , placeholder "yyyy-mm-ddThh:mm:ssZ"
                    , onInput ( \newValue -> TransactionMsgA (UpdateTransactionDatetime newValue) )
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
                    , onInput ( \newValue -> TransactionMsgA (UpdateTransactionNote newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (TransactionMsgA PostTransaction) ]
                [ text "Submit" ]
            ]
        ]
