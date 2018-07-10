module Accounts.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (href, id, type_)
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
        [ a [ id "accounts-index",  href "/accounts" ] [ text "Accounts" ]
        , h3 [] [ text "Create New Account" ]
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