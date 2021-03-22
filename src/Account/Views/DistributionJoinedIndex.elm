module Account.Views.DistributionJoinedIndex exposing (view)

import Account.Model
import Account.MsgB exposing (MsgB(..))
import DecimalFP exposing (DFP, Sign(..), dfp_add, dfp_fromStringExp)
import Distribution.Distribution exposing (DistributionJoined)
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, style, type_, value)
import Html.Events exposing (onClick)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx, tx_edit)
import Types exposing (DRCRFormat(..))
import ViewHelpers exposing (dvColumnHeader, viewDFP)


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ viewRESTPanel model ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ] [ text "Transactions for Account: " ]
        , viewFlash model.flashMessages
        , viewTransactionsPanel model model.accounts
        ]


view : Model.Model -> Html Msg
view model =
    template model
        (leftContent model)
        (rightContent model)



{- This function will display the next row of a collection of DistributionJoined. In order to do so properly it needs:

   A Langugage
   An Int p that specifies the number of decimal places after the zero to display.
   A DFP representation of the running total from the previous invocations.
   A DistributedJoined
   The specification of which DRCRFormat to use

   It will return the Html needed to display the row.
-}


viewDistributionJoined : Language -> Int -> DFP -> DistributionJoined -> DRCRFormat -> Html Msg
viewDistributionJoined language p runtot dj drcr =
    tr []
        ([ td [] [ text dj.tx_time ]
         , td [] [ text dj.tx_notes ]
         ]
            ++ viewDFP (dfp_fromStringExp dj.amountbt dj.amount_exp) p drcr
            ++ viewDFP (DecimalFP.dfp_add ( dfp_fromStringExp dj.amountbt dj.amount_exp) runtot) p drcr

            ++ [ td []
                    [ a
                        [ href ("/transactions/" ++ String.fromInt dj.tid)
                        , class "button is-link"
                        ]
                        [ language |> tx_edit |> text ]
                    ]
               ]
        )


viewDistributionJoineds : Model.Model -> DFP -> List DistributionJoined -> List (Html Msg)
viewDistributionJoineds model runtot distributionJoined =
    case distributionJoined of
        -- this function should not be called if there are no distributionJoineds, so this case should never happen.  But try tellin' that to Elm!
        [] ->
            [ tr [] [ td [] [ text "max fubar error" ] ] ]

        [ x ] ->
            [ viewDistributionJoined model.language model.accounts.decimalPlaces runtot x model.drcr_format ]

        x :: xs ->
            viewDistributionJoined model.language model.accounts.decimalPlaces runtot x model.drcr_format
                :: viewDistributionJoineds model (DecimalFP.dfp_add (dfp_fromStringExp x.amountbt x.amount_exp) runtot) xs


viewRESTPanel : Model.Model -> Html Msg
viewRESTPanel _ =
    div [ class "box" ] []


viewTableHeader : Language -> DRCRFormat -> Html Msg
viewTableHeader _ drcr =
    tr []
        ([ th [] [ text "Time" ]
         , th [] [ text "Notes" ]
         ]
            ++ dvColumnHeader "Amount" drcr
            ++ dvColumnHeader "Run tot" drcr
            ++ [ th [] [] ]
         -- extra header for edit button
        )


viewTransactionsPanel : Model.Model -> Account.Model.Model -> Html Msg
viewTransactionsPanel model account_model =
    div [ class "box" ]
        [ if List.isEmpty account_model.distributionJoineds then
            div []
                [ h3 [] [ text "This account does not have any transactions" ] ]

          else
            div [ style "margin-top" "1.0em" ]
                [ label [ class "label" ]
                    [ text
                        (tx model.language { e = "Decimal places: ", c = "小数位: ", p = "xiǎoshù wèi: " })
                    ]
                , div [ class "control" ]
                    [ input
                        [ class "input"
                        , type_ "text"
                        , value (String.fromInt account_model.decimalPlaces)
                        ]
                        []
                    ]
                , button
                    [ class "button is-link"
                    , style "margin-top" "0.3em"
                    , onClick
                        (AccountMsgA (UpdateDecimalPlaces (account_model.decimalPlaces + 1)))
                    ]
                    [ text "+" ]
                , button
                    [ class "button is-link"
                    , style "margin-left" "0.3em"
                    , style "margin-top" "0.3em"
                    , onClick
                        (AccountMsgA (UpdateDecimalPlaces (account_model.decimalPlaces - 1)))
                    ]
                    [ text "-" ]
                , viewTransactionsTable model account_model.distributionJoineds
                ]
        ]


viewTransactionsTable : Model.Model -> List DistributionJoined -> Html Msg
viewTransactionsTable model distributionJoineds =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language model.drcr_format ]
        , tbody [] (viewDistributionJoineds model (DFP [] 0 Zero) distributionJoineds)
        ]
