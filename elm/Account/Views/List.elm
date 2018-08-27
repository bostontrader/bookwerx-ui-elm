module Account.Views.List exposing ( view )

import Html exposing  (Html, a, button, div, h3, table, tbody, td, thead, text, th, tr )
import Html.Attributes exposing ( class, href, id, style )
import Html.Events exposing ( onClick )
import Http
import RemoteData

import Model
import Msg exposing ( Msg ( AccountMsgA ) )
import Template exposing (template)
import ViewHelpers exposing ( viewFlash )

import Account.Model
import Account.Account exposing ( Account )
import Account.AccountMsgB exposing ( AccountMsgB ( DeleteAccount ) )


view : Model.Model -> Html Msg
view model =
    template (div []
        [ h3 [ class "title is-3" ] [ text "Accounts" ]
        , viewFlash model.flashMessages
        ,  a [ id "accounts-add", href "/#ui/accounts/add", class "button is-link" ]
             [ text "Create new account" ]
        , viewAccountsOrError model.accounts
        ])


viewAccountsOrError : Account.Model.Model -> Html Msg
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
            "/#ui/accounts/" ++ account.id
    in
        tr []
            [ td [] [ text account.id ]
            , td [] [ text account.title ]
            , td []
                [ a [ id "accounts-edit", href accountPath, class "button is-link" ] [ text "Edit" ] ]
            -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
            , td [ id "deleteAccount" ]
                [ button [ class "button is-link is-danger", onClick ( AccountMsgA ( DeleteAccount account.id) ) ]
                    [ text "Delete" ]
                ]
            ]
