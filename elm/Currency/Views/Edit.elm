module Currency.Views.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Template exposing (template)
import Msg exposing ( Msg( CurrencyMsgA ) )
import Model
import ViewHelpers exposing ( viewErrors, viewFlash )

import Currency.Model
import Currency.Plumbing exposing ( CurrencyGetOneHttpResponse(..) )

import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing
    ( CurrencyMsgB
        ( PatchCurrency, UpdateCurrencySymbol, UpdateCurrencyTitle )
    )


view : Model.Model -> Html Msg
view model =
    template ( div [ id "currencies-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Currency" ]
        , viewFlash model.flashMessages
        , a [ id "currencies-index", href "/#ui/currencies" ] [ text "Currencies index" ]
        , viewCurrencyOrError model.currencies
        ] )


viewCurrencyOrError : Currency.Model.Model -> Html Msg
viewCurrencyOrError model =
    case model.wdCurrency of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success response ->
            case response of
                CurrencyGetOneDataResponse wdCurrency ->
                    editForm model.editCurrency

                CurrencyGetOneErrorsResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Currency error..." ]


editForm : Currency -> Html Msg
editForm currency =
    -- don't use form lest the subsequent post xhr get fubared
    -- Html.form []
    div []
        [ div [class "field"]
            [ label [class "label"][ text "Symbol"]
            , div [class "control"]
                [ input
                    [ id "symbol"
                    , class "input"
                    , type_ "text"
                    , value currency.symbol
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
                    , type_ "text"
                    , value (Debug.log "editForm title:"  currency.title)
                    , onInput ( \newValue -> CurrencyMsgA (UpdateCurrencyTitle newValue) )
                    ][]
                ]
            ]

        , div []
            [ button [ id "save", class "button is-link", onClick (CurrencyMsgA PatchCurrency) ]
                [ text "Submit" ]
            ]
        ]
