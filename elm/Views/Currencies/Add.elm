module Views.Currencies.Add exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (href, id, type_)
import Html.Events exposing (onClick, onInput)
import Types exposing (Msg(CreateNewCurrency, NewCurrencySymbol, NewCurrencyTitle))


view : Html Msg
view =
    div [ id "currencies-add" ]
        [ a [ href "/currencies" ] [ text "Back" ]
        , h3 [] [ text "Create New Currency" ]
        , newCurrencyForm
        ]


newCurrencyForm : Html Msg
newCurrencyForm =
    Html.form []
        [ div []
            [ text "Symbol"
            , br [] []
            , input
                [ id "symbol", type_ "text"
                , onInput NewCurrencySymbol
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Title"
            , br [] []
            , input
                [ id "title", type_ "text"
                , onInput NewCurrencyTitle
                ]
                []
            ]
        , br [] []
        , div []
            [ button
                [ id "save"
                , onClick CreateNewCurrency
                ]
                [ text "Submit" ]
            ]
        ]