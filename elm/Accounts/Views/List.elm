module Accounts.Views.List exposing (view)

import Types exposing (Model, Msg(DeleteAccount, FetchAccounts), Account)
import Html exposing (Html, a, br, button, div, h3, table, tbody, td, thead, text, th, tr)
import Html.Attributes exposing (class, href, id)
import Html.Events exposing (onClick)
import Http
import RemoteData


view : Model -> Html Msg
view model =
    div []
        [ a [ id "accounts-add", href "/accounts/add" ]
            [ text "Create new account" ]
        , viewAccountsOrError model
        ]


viewAccountsOrError : Model -> Html Msg
viewAccountsOrError model =
    case model.accounts of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success accounts ->
            viewAccounts accounts

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


viewAccounts : List Account -> Html Msg
viewAccounts accounts =
    div [ id "accounts-index"]
        [ h3 [] [ text "Accounts" ]
        , table []
            [ thead [][viewTableHeader]
            , tbody [] (List.map viewAccount accounts)
            ]
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Title" ]
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
                [ a [ id "accounts-edit", href accountPath ] [ text "Edit" ] ]
            -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
            , td [ id "deleteAccount" ]
                [ button [ onClick (DeleteAccount account.id) ]
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