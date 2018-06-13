module Views.Currencies.List exposing (view)

import Types exposing (Model, Msg(DeleteCurrency, FetchCurrencies), Currency)
import Html exposing (Html, a, br, button, div, h3, table, td, text, th, tr)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import RemoteData


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchCurrencies ]
            [ text "Refresh currencies" ]
        , br [] []
        , br [] []
        , a [ href "/currencies/new" ]
            [ text "Create new currency" ]
        , viewCurrenciesOrError model
        ]


viewCurrenciesOrError : Model -> Html Msg
viewCurrenciesOrError model =
    case model.currencies of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success currencies ->
            viewCurrencies currencies

        RemoteData.Failure httpError ->
            viewError (createErrorMessage httpError)


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


viewCurrencies : List Currency -> Html Msg
viewCurrencies currencies =
    div []
        [ h3 [] [ text "Currencies" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewCurrency currencies)
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Title" ]
        , th []
            [ text "Author" ]
        ]


viewCurrency : Currency -> Html Msg
viewCurrency currency =
    let
        currencyPath =
            "/currencies/" ++ (toString currency.id)
    in
        tr []
            [ td []
                [ text (toString currency.id) ]
            , td []
                [ text currency.title ]
            , td []
                [ a [ href currency.author.url ] [ text currency.author.name ] ]
            , td []
                [ a [ href currencyPath ] [ text "Edit" ] ]
            , td []
                [ button [ onClick (DeleteCurrency currency.id) ]
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