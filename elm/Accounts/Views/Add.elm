module Accounts.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (class, href, id, type_)
import Html.Events exposing (onClick, onInput)

import Template exposing (template)
import Types exposing
    ( Account
    , Model
    , Msg(CreateNewAccount, NewAccountTitle)
    )


view : Model -> Html Msg
view model =
    template (div [ id "accounts-add" ]
        [ h3 [ class "title is-3" ] [ text "Create New Account" ]
        , a [ id "accounts-index",  href "/accounts" ] [ text "Accounts" ]
        , newAccountForm model.editAccount
        ])


newAccountForm : Account -> Html Msg
newAccountForm account =
    Html.form []
        [ div []
            [ text "Title"
            , br [][]
            , input
                [ id "title", type_ "text"
                , onInput NewAccountTitle
                ]
                []
            ]
        , br [][]
        , div []
            [ button
                [ id "save"
                , onClick CreateNewAccount
                ]
                [ text "Submit" ]
            ]
        ]