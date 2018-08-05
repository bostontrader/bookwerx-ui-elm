module Accounts.Views.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Template exposing (template)
import Types exposing
    ( BWCore_Error
    , Model
    , Msg(SubmitUpdatedAccount, UpdateAccountTitle)
    , Account
    , AccountPostHttpResponse(..)
    )

view : Model -> Html Msg
view model =
    template (div [ id "accounts-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Account" ]
        , a [ id "accounts-index", href "/ui/accounts" ] [ text "Accounts index" ]
        , viewAccountOrError model
        ])


viewAccountOrError : Model -> Html Msg
viewAccountOrError model =
    case model.wdAccount of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success aehr ->
            case aehr of
                ValidAccountPostResponse wdAccount ->
                    editForm model.editAccount

                ErrorAccountPostResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Account error..." ]

viewErrors : List BWCore_Error -> Html Msg
viewErrors errors =
    div [ id "errors"]
        [ h3 [] [ text "Errors" ]
        , table []
            [ thead [][viewTableHeader]
            , tbody [] (List.map viewError errors)
            ]
        ]

viewError : BWCore_Error -> Html Msg
viewError error =
    tr []
        [ td []
            [ text error.key ]
        , td []
            [ text error.value ]
        ]

viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "key" ]
        , th []
            [ text "value" ]
        ]

editForm : Account -> Html Msg
editForm account =
    Html.form []
        [ div []
            [ text "Title"
            , br [][]
            , input
                [ id "title", type_ "text"
                , value account.title
                , onInput (UpdateAccountTitle)
                ]
                []
            ]
        , br [][]
        , div []
            [ button
                [ id "save"
                , onClick SubmitUpdatedAccount
                ]
                [ text "Submit" ]
            ]
        ]