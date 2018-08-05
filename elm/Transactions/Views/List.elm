module Transactions.Views.List exposing (view)

import Html exposing (Html, a, br, button, div, h3, table, tbody, td, thead, text, th, tr)
import Html.Attributes exposing (class, href, id, style)
import Html.Events exposing (onClick)
import Http
import RemoteData

import Template exposing (template)
import Types exposing (Model, Msg(
    DeleteTransaction
    --FetchTransactions
    )
    , Transaction)

view : Model -> Html Msg
view model =
    template ( div []
        [ h3 [ class "title is-3" ] [ text "Transactions" ]
          , a [ id "transactions-add", href "/ui/transactions/add", class "button is-link" ]
              [ text "Create new transaction" ]
        , viewTransactionsOrError model
        ] )

viewTransactionsOrError : Model -> Html Msg
viewTransactionsOrError model =
    case model.transactions of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success transactions ->
            if List.isEmpty transactions then
              div [ id "transactions-index" ]
              [ h3 [ id "transactions-empty" ][ text "No transactions present" ] ]
            else
              div [ id "transactions-index", style [("margin-top","1.0em")]  ]
              (viewTransactions transactions)

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


viewTransactions : List Transaction -> List (Html Msg)
viewTransactions transactions =
    [ table [ class "table is-striped" ]
        [ thead [][viewTableHeader]
        , tbody [] (List.map viewTransaction transactions)
        ]
    ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th [][ text "ID" ]
        , th [][ text "Datetime" ]
        , th [][ text "Note" ]
        , th [][] -- extra headers for edit and delete
        , th [][]
        ]


viewTransaction : Transaction -> Html Msg
viewTransaction transaction =
    let
        transactionPath =
            "/ui/transactions/" ++ transaction.id
    in
        tr []
            [ td [] [ text transaction.id ]
            , td [] [ text transaction.datetime ]
            , td [] [ text transaction.note ]
            , td []
                [ a [ id "transactions-edit", href transactionPath, class "button is-link" ] [ text "Edit" ] ]
            -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
            , td [ id "deleteTransaction" ]
                [ button [ class "button is-link is-danger", onClick (DeleteTransaction transaction.id) ]
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