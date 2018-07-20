module Currencies.Views.List exposing (view)

import Html exposing (Html, a, br, button, div, h3, table, tbody, td, thead, text, th, tr)
import Html.Attributes exposing (class, href, id, style)
import Html.Events exposing (onClick)
import Http
import RemoteData

import Template exposing (template)
import Types exposing (Model, Msg(DeleteCurrency), Currency)

view : Model -> Html Msg
view model =
    template ( div []
        [ h3 [ class "title is-3" ] [ text "Currencies" ]
          , a [ id "currencies-add", href "/currencies/add", class "button is-link" ]
              [ text "Create new currency" ]
        , viewCurrenciesOrError model
        ] )


viewCurrenciesOrError : Model -> Html Msg
viewCurrenciesOrError model =
    case model.currencies of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success currencies ->
            if List.isEmpty currencies then
              div [ id "currencies-index" ]
              [ h3 [ id "currencies-empty" ][ text "No currencies present" ] ]
            else
              div [ id "currencies-index", style [("margin-top","1.0em")]  ]
              (viewCurrencies currencies)

        RemoteData.Failure httpError ->
            h3 [] [ text "Currencies error..." ]


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
        div []
            [ h3 [] [ text errorHeading ]
            , text ("Error: " ++ errorMessage)
            ]


viewCurrencies : List Currency -> List (Html Msg)
viewCurrencies currencies =
    [ table [ class "table is-striped" ]
        [ thead [][viewTableHeader]
        , tbody [] (List.map viewCurrency currencies)
        ]
    ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th [][ text "ID" ]
        , th [][ text "Symbol" ]
        , th [][ text "Title" ]
        , th [][] -- extra headers for edit and delete
        , th [][]
        ]


viewCurrency : Currency -> Html Msg
viewCurrency currency =
    let
        currencyPath =
            "/currencies/" ++ currency.id
    in
        tr []
            [ td []
                [ text currency.id ]
            , td []
                [ text currency.symbol ]
            , td []
                [ text currency.title ]
            , td []
                [ a [ id "currencies-edit", href currencyPath, class "button is-link" ] [ text "Edit" ] ]
            -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
            , td [ id "deleteCurrency" ]
                [ button [ class "button is-link is-danger", onClick (DeleteCurrency currency.id) ]
                    [ text "Delete" ]
                ]
            ]


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message
