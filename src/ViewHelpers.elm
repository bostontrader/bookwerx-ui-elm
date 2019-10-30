module ViewHelpers exposing ( viewHttpPanel )

import Html exposing (Html, div, label, p, text)
import Html.Attributes exposing (class, style)
import Msg exposing (Msg)
import Translate exposing (Language, tx_request, tx_response)

viewHttpPanel : String -> String -> Language -> Html Msg
viewHttpPanel request response language =
    div [ class "box has-background-grey-lighter", style "margin-top" "0.5em" ]
        [ label [ class "label" ] [ language |> tx_request |> text ]
        , p [style "overflow-wrap" "anywhere"] [ text request ]
        , if (String.length <| response) > 0 then
            div []
                [ label [ class "label" ] [ language |> tx_response |> text ]
                , if String.length response > 200 then
                    p [ style "overflow-wrap" "anywhere"] [ text (String.slice 0 200 response ++ " ...") ]

                  else
                    p [ style "overflow-wrap" "anywhere"] [ text response ]
                ]

          else
            div [] []
        ]
