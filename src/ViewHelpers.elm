module ViewHelpers exposing (dvColumnHeader, viewDFP, viewHttpPanel)

import DecimalFPx exposing (DFPx, DFPFmtx, dfp_absx, dfp_fmtx)
import DecimalFP exposing (DFP, DFPFmt, dfp_abs, dfp_fmt)
import Html exposing (Html, div, label, p, td, text, th)
import Html.Attributes exposing (class, style)
import Msg exposing (Msg)
import Translate exposing (Language, tx_request, tx_response)
import Types exposing (DRCRFormat(..))


dvColumnHeader : String -> DRCRFormat -> List (Html Msg)
dvColumnHeader heading drcr =
    case drcr of
        DRCR ->
            [ th [ style "padding-right" "0em" ] [ text heading ]
            , th [ style "padding-left" "0.3em" ] [] -- drcr column
            ]

        PlusAndMinus ->
            [ th [] [ text heading ] ]



-- Given a DFPFmt, determine which class, if any, to use in display CSS.


roClass : DFPFmtx -> String
roClass dfpfmt =
    if dfpfmt.r then
        "has-text-danger"

    else
        ""



{- This function will take a DFP and return suitable HTML for its display.  This function will also consider the quantity of decimal places desired to display as well as the desired DRCRFormat.  More particularly:

   DFP dv
   Int p - The quantity of decimal places to display.  Note that this function internally negates that in order to display according to the suitable power of 10.
   DRCRFormat drcr
-}


viewDFP : DFP -> Int -> DRCRFormat -> List (Html Msg)
viewDFP dv p drcr =
    [ td
        [ class "has-text-right"
        ]
        [ text "dfp_fmt2.s" ]
    , td [ style "padding-left" "0.3em" ] [ text "CR" ]
    ]

viewHttpPanel : String -> String -> Language -> Html Msg
viewHttpPanel request response language =
    div [ class "box has-background-grey-lighter", style "margin-top" "0.5em" ]
        [ label [ class "label" ] [ language |> tx_request |> text ]
        , p [ style "overflow-wrap" "anywhere" ] [ text request ]
        , if (String.length <| response) > 0 then
            div []
                [ label [ class "label" ] [ language |> tx_response |> text ]
                , if String.length response > 200 then
                    p [ style "overflow-wrap" "anywhere" ] [ text (String.slice 0 200 response ++ " ...") ]

                  else
                    p [ style "overflow-wrap" "anywhere" ] [ text response ]
                ]

          else
            div [] []
        ]
