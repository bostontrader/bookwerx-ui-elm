module Accounts.Views.List exposing (view)

import Template exposing (template)
import Types exposing (Model, Msg(DeleteAccount, FetchAccounts), Account)
import Html exposing (Html, a, button, div, h3, table, tbody, td, thead, text, th, tr)
import Html.Attributes exposing (class, href, id, style)
import Html.Events exposing (onClick)
import Http
import RemoteData


view : Model -> Html Msg
view model =
    template (div []
        [ h3 [ class "title is-3" ] [ text "Accounts" ]
        ,  a [ id "accounts-add", href "/accounts/add", class "button" ]
            [ text "Create new account" ]
        , viewAccountsOrError model
        ])


viewAccountsOrError : Model -> Html Msg
viewAccountsOrError model =
    case model.accounts of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success accounts ->
            if List.isEmpty accounts then
              div [ id "accounts-index" ]
              [ h3 [ id "accounts-empty" ][ text "No accounts present" ] ]
            else
              div [ id "accounts-index", style [("margin-top","1.0em")] ]
              (viewAccounts accounts)

        RemoteData.Failure httpError ->
            h3 [] [ text "Accounts error..." ]


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


viewAccounts : List Account -> List (Html Msg)
viewAccounts accounts =
    [ table [ class "table is-striped" ]
        [ thead [][viewTableHeader]
        , tbody [] (List.map viewAccount accounts)
        ]
    ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th [][ text "ID" ]
        , th [][ text "Title" ]
        , th [][] -- extra headers for edit and delete
        , th [][]
        ]


viewAccount : Account -> Html Msg
viewAccount account =
    let
        accountPath =
            "/accounts/" ++ account.id
    in
        tr []
            [ td []
                [ text account.id ]
            , td []
                [ text account.title ]
            , td []
                [ a [ id "accounts-edit", href accountPath, class "button" ] [ text "Edit" ] ]
            -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
            , td [ id "deleteAccount" ]
                [ button [ class "delete is-danger", onClick (DeleteAccount account.id) ]
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