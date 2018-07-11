module Currencies.Views.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Template exposing (template)
import Types exposing
    ( BWCore_Error
    , Model
    , Msg(SubmitUpdatedCurrency, UpdateCurrencySymbol, UpdateCurrencyTitle)
    , Currency
    , CurrencyEditHttpResponse(..)
    )

view : Model -> Html Msg
view model =
    template ( div [ id "currencies-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Currency" ]
        , a [ id "currencies-index", href "/currencies" ] [ text "Currencies index" ]
        , viewCurrencyOrError model
        ] )


viewCurrencyOrError : Model -> Html Msg
viewCurrencyOrError model =
    case model.wdCurrency of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success cehr ->
            case cehr of
                ValidCurrencyEditResponse wdCurrency ->
                    editForm model.editCurrency

                ErrorCurrencyEditResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Currency error..." ]

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

editForm : Currency -> Html Msg
editForm currency =
    Html.form []
        [ div []
            [ text "Symbol"
            , br [][]
            , input
                [ id "symbol", type_ "text"
                , value currency.symbol
                , onInput UpdateCurrencySymbol
                ]
                []
            ]
        , br [][]
        , div []
            [ text "Title"
            , br [][]
            , input
                [ id "title", type_ "text"
                , value (Debug.log "editForm title:"  currency.title)
                , onInput UpdateCurrencyTitle
                ]
                []
            ]
        , br [][]
        , div []
            [ button
                [ id "save"
                , onClick SubmitUpdatedCurrency
                ]
                [ text "Submit" ]
            ]
        ]
