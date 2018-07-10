module Template exposing (template)

import Html exposing (Html, a, div, nav, text)
import Html.Attributes exposing (class, href, id)

template: Html msg -> Html msg
template mainContent =
    div [ id "content" ]
        [ div [ id "header", class "has-background-primary"][ text "header"]
        , nav [ class "navbar" ]
            [ div [ class "navbar-brand" ]
                [ div [ class "navbar-item" ][ text "BW" ]
                , div [ class "navbar-burger" ][ text "BG"]
                ]
            , div [ class "navbar-menu" ]
                [ a [ id "transactions", href "/transactions", class "navbar-item" ] [ text "Transactions" ]
               , a [ id "accounts", href "/accounts", class "navbar-item" ] [ text "Accounts" ]
               , a [ id "currencies", href "/currencies", class "navbar-item" ] [ text "Currencies" ]
               ]
           ]
        , div [ id "middle", class "columns" ]
            [ div [ id "left-pane", class "has-background-warning column is-one-quarter" ][ text "left"]
           , div [ id "main-content", class "has-background-light column" ][ mainContent ]
           ]
        , div [ id "footer", class "has-background-danger"][ text "footer"]
        ]
