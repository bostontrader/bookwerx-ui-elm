module Account.Views.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Template exposing (template)
import Msg exposing ( Msg( AccountMsgA ) )
import Model
import ViewHelpers exposing ( viewErrors, viewFlash )

import Account.Model
import Account.Plumbing exposing ( AccountGetOneHttpResponse(..) )

import Account.Account exposing ( Account )
import Account.AccountMsgB exposing
    ( AccountMsgB
        ( PatchAccount, UpdateAccountTitle )
    )


view : Model.Model -> Html Msg
view model =
    template (div [ id "accounts-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Account" ]
        , viewFlash model.flashMessages
        , a [ id "accounts-index", href "/#ui/accounts" ] [ text "Accounts index" ]
        , viewAccountOrError model.accounts
        ])


viewAccountOrError : Account.Model.Model -> Html Msg
viewAccountOrError model =
    case model.wdAccount of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success response ->
            case response of
                AccountGetOneDataResponse wdAccount ->
                    editForm model.editAccount

                AccountGetOneErrorsResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Account error..." ]


editForm : Account -> Html Msg
editForm account =
    -- don't use form lest the subsequent post xhr get fubared
    -- Html.form []
    div []
        [ div [class "field"]
            [ label [class "label"][ text "Title"]
            , div [class "control"]
                [ input
                    [ id "title"
                    , class "input"
                    , type_ "text"
                    , value account.title
                    , onInput ( \newValue -> AccountMsgA (UpdateAccountTitle newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (AccountMsgA PatchAccount) ]
                [ text "Submit" ]
            ]
        ]