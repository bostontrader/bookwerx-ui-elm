module Transactions.Views.List exposing (view)

import Types exposing (Model, Msg(DeleteTransaction, FetchTransactions), Transaction)
import Html exposing (Html, a, br, button, div, h3, table, tbody, td, thead, text, th, tr)
import Html.Attributes exposing (class, href, id)
import Html.Events exposing (onClick)
import Http
import RemoteData


view : Model -> Html Msg
view model =
    div []
        [ a [ id "transactions-add", href "/transactions/add" ]
            [ text "Create new transaction" ]
        , viewTransactionsOrError model
        ]


viewTransactionsOrError : Model -> Html Msg
viewTransactionsOrError model =
    case model.transactions of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success transactions ->
            viewTransactions transactions

        RemoteData.Failure httpError ->
            h3 [] [ text "Transactions error..." ]


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]


viewTransactions : List Transaction -> Html Msg
viewTransactions transactions =
    div [ id "transactions-index"]
        [ h3 [] [ text "Transactions" ]
        , table []
            [ thead [][viewTableHeader]
            , tbody [] (List.map viewTransaction transactions)
            ]
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Description" ]
        ]


viewTransaction : Transaction -> Html Msg
viewTransaction transaction =
    let
        transactionPath =
            "/transactions/" ++ transaction.id
    in
        tr []
            [ td []
                [ text transaction.id ]
            , td []
                [ text transaction.desc ]
            , td []
                [ a [ id "transactions-edit", href transactionPath ] [ text "Edit" ] ]
            -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
            , td [ id "deleteTransaction" ]
                [ button [ onClick (DeleteTransaction transaction.id) ]
                    [ text "Delete" ]
                ]
            ]


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message