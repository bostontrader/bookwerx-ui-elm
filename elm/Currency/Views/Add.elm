module Currency.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, label, text)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)

import Template exposing (template)

import Model
import Msg exposing ( Msg( CurrencyMsgA ) )
import ViewHelpers exposing ( viewFlash )

import Currency.Model exposing ( Model )
import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing
    ( CurrencyMsgB
        ( PostCurrency, UpdateCurrencySymbol, UpdateCurrencyTitle )
    )


view : Model.Model -> Html Msg
view model =
    template ( div [ id "currencies-add" ]
        [ h3 [ class "title is-3" ] [ text "Create New Currency" ]
        , viewFlash model.flashMessages
        , a [ id "currencies-index", href "/#ui/currencies" ] [ text "Currencies index" ]
        , newCurrencyForm model.currencies.editCurrency
        ])


newCurrencyForm : Currency -> Html Msg
newCurrencyForm currency =
    -- don't use form lest the subsequent post xhr get fubared
    -- Html.form []
    div []
        [ div [class "field"]
            [ label [class "label"][ text "Symbol"]
            , div [class "control"]
                [ input
                    [ id "symbol"
                    , class "input"
                    , type_ "text", value currency.symbol
                    , onInput ( \newValue -> CurrencyMsgA (UpdateCurrencySymbol newValue) )
                    ][]
                ]
            ]

        , div [class "field"]
            [ label [class "label"][ text "Title"]
            , div [class "control"]
                [ input
                    [ id "title"
                    , class "input"
                    , type_ "text", value currency.title
                    , onInput ( \newValue -> CurrencyMsgA (UpdateCurrencyTitle newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (CurrencyMsgA PostCurrency) ]
                [ text "Submit" ]
            ]
        ]