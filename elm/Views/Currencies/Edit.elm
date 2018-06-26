module Views.Currencies.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (Currency, CurrencyEditHttpResponse(..), BWCore_Error, Model, Msg(NewCurrencySymbol, NewCurrencyTitle))
import RemoteData

view : Model -> Html Msg
view model =
    div [ id "currencies-edit"]
        -- [ a [ href "/currencies" ] [ text "Back" ]
        --[ h3 [] [ text "Edit Currency" ]
        --, editForm currency
        [ viewCurrencyOrError model
        ]


viewCurrencyOrError : Model -> Html Msg
viewCurrencyOrError model =
    case model.currency of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success cehr ->
            case cehr of
                ValidCurrencyEditResponse currency ->
                    editForm currency

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
            , br [] []
            , input
                [ type_ "text"
                , value currency.symbol
                , onInput NewCurrencySymbol
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , value currency.title
                , onInput NewCurrencyTitle
                ]
                []
            ]
        , br [] []
        , div []
            [ --button [ onClick (SubmitUpdatedCurrency currency.id) ]
                --[ text "Submit" ]
            ]
        ]