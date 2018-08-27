module Transaction.Views.Edit exposing ( view )

import Html exposing (Html, a, br, button, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing ( class, href, id, type_, value )
import Html.Events exposing ( onClick, onInput )
import RemoteData

import Template exposing ( template )
import Msg exposing ( Msg( TransactionMsgA ) )
import Model
import ViewHelpers exposing ( viewErrors, viewFlash )

import Transaction.Model
import Transaction.Plumbing exposing ( TransactionGetOneHttpResponse(..) )

import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing
    ( TransactionMsgB
        ( PatchTransaction, UpdateTransactionDatetime, UpdateTransactionNote )
    )


view : Model.Model -> Html Msg
view model =
    template ( div [ id "transactions-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Transaction" ]
        , viewFlash model.flashMessages
        , a [ id "transactions-index", href "/#ui/transactions" ] [ text "Transactions index" ]
        , viewTransactionOrError model.transactions
        ] )


viewTransactionOrError : Transaction.Model.Model -> Html Msg
viewTransactionOrError model =
    case model.wdTransaction of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success response ->
            case response of
                TransactionGetOneDataResponse wdTransaction ->
                    editForm model.editTransaction

                TransactionGetOneErrorsResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Transaction error..." ]


editForm : Transaction -> Html Msg
editForm transaction =
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
                    , value transaction.datetime
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
                    , value transaction.note
                    , onInput ( \newValue -> TransactionMsgA (UpdateTransactionNote newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (TransactionMsgA PatchTransaction) ]
                [ text "Submit" ]
            ]
        ]
