module Currencies.Views.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (href, id, type_, value)
import Html.Events exposing (onClick, onInput)

import Template exposing (template)
import Types exposing
    ( Currency
    , Model
    , Msg(CreateNewCurrency, NewCurrencySymbol, NewCurrencyTitle)
    )


view : Model -> Html Msg
view model =
    template ( div [ id "currencies-add" ]
        [ a [ id "currencies-index", href "/currencies" ] [ text "Currencies index" ]
        , h3 [] [ text "Create New Currency" ]
        , newCurrencyForm model.editCurrency
        ])

newCurrencyForm : Currency -> Html Msg
newCurrencyForm currency =
    Html.form []
        [ div []
            [ text "Symbol"
            , br [][]
            , input
                [ id "symbol", type_ "text", value currency.symbol
                , onInput NewCurrencySymbol
                ]
                []
            ]
        , br [][]
        , div []
            [ text "Title"
            , br [] []
            , input
                [ id "title", type_ "text", value currency.title
                , onInput NewCurrencyTitle
                ]
                []
            ]
        , br [][]
        , div []
            [ button
                [ id "save"
                , onClick CreateNewCurrency
                ]
                [ text "Submit" ]
            ]
        ]