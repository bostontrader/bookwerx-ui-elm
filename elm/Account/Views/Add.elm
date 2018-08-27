module Account.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, label, text)
import Html.Attributes exposing (class, href, id, type_)
import Html.Events exposing (onClick, onInput)

import Template exposing ( template )

import Model
import Msg exposing ( Msg( AccountMsgA ) )
import ViewHelpers exposing ( viewFlash )

import Account.Model
import Account.Account exposing ( Account )
import Account.AccountMsgB exposing
    ( AccountMsgB
        ( PostAccount, UpdateAccountTitle )
    )


view : Model.Model -> Html Msg
view model =
    template (div [ id "accounts-add" ]
        [ h3 [ class "title is-3" ] [ text "Create New Account" ]
        , viewFlash model.flashMessages
        , a [ id "accounts-index",  href "/#ui/accounts" ] [ text "Accounts" ]
        , newAccountForm model.accounts.editAccount
        ])


newAccountForm : Account -> Html Msg
newAccountForm account =
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
                    , onInput ( \newValue -> AccountMsgA (UpdateAccountTitle newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (AccountMsgA PostAccount) ]
                [ text "Submit" ]
            ]
        ]