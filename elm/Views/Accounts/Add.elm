module Views.Accounts.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (href, id, type_)
import Html.Events exposing (onClick, onInput)
import Types exposing (Msg(CreateNewAccount, NewAccountTitle))


view : Html Msg
view =
    div [ id "accounts-add" ]
        [ a [ href "/accounts" ] [ text "Back" ]
        , h3 [] [ text "Create New Account" ]
        , newAccountForm
        ]


newAccountForm : Html Msg
newAccountForm =
    Html.form []
        [ div [] []
            --[ text "Symbol"
            --, br [] []
            --, input
            --    [ id "symbol", type_ "text"
            --    , onInput NewAccountSymbol
            --    ]
            --    []
            --]
        , br [] []
        , div []
            [ text "Title"
            , br [] []
            , input
                [ id "title", type_ "text"
                , onInput NewAccountTitle
                ]
                []
            ]
        , br [] []
        , div []
            [ button
                [ id "save"
                , onClick CreateNewAccount
                ]
                [ text "Submit" ]
            ]
        ]