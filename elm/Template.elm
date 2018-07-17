module Template exposing (template)

import Html exposing (Html, a, div, img, nav, text)
import Html.Attributes exposing (class, height, href, id, src, style, width)

template: Html msg -> Html msg
template mainContent =
    div [ id "content" ]
        [ div [ id "header"]

-- Way ugly hack.  I don't want to figure out webpack and url-loader and elm's asset-loader and restify's static service facility, right now.  I just want a logo!  I'll figure this out later.
            [ img [height 50, width 65, src "data:image/png;base64,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"][]]
        , nav [ class "navbar" ]
            [ div [ class "navbar-brand" ]
                [ div [ class "navbar-burger" ][ text "BG"]
                ]
            , div [ class "navbar-menu" ]
                [ a [ id "transactions", href "/transactions", class "navbar-item button is-link", style [("margin-left","0.2em")] ] [ text "Transactions" ]
               , a [ id "accounts", href "/accounts", class "navbar-item button is-link", style [("margin-left","0.2em")] ] [ text "Accounts" ]
               , a [ id "currencies", href "/currencies", class "navbar-item button is-link", style [("margin-left","0.2em")] ] [ text "Currencies" ]
               ]
           ]
        , div [ id "middle", class "columns" ]
            [ div [ id "left-pane", class "has-background-warning column is-one-quarter" ][ text "left"]
           , div [ id "main-content", class "has-background-light column" ][ mainContent ]
           ]
        , div [ id "footer", class "has-background-danger"][ text "footer"]
        ]
