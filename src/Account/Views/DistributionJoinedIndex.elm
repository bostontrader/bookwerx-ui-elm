module Account.Views.DistributionJoinedIndex exposing (view)

import Account.MsgB exposing (MsgB(..))
import Account.Model
import Decimal exposing (DV, dadd, dvColumnHeader, viewDV)
import Distribution.Distribution exposing (DistributionJoined)
import Flash exposing (viewFlash)
import Html exposing (Html, a, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, placeholder, style, type_, value)
import Html.Events exposing (onInput)
import IntField exposing (intFieldToInt, intFieldToString)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx, tx_edit)
import Types exposing (DRCRFormat(..))
--import Util exposing (, , roundingAlertStyle)


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
        (leftContent model) (rightContent model)


viewDistributionJoined : Language -> Int -> DV -> DistributionJoined -> DRCRFormat -> Html Msg
viewDistributionJoined language p runtot dj drcr =
    tr []
        (
            [ td [] [ text dj.tx_time ]
            , td [] [ text dj.tx_notes ]
            ]
            ++ viewDV (DV dj.amount dj.amount_exp) p drcr "has-text-right" [("","")]
                --( (roundingAlertStyle p dj.amount_exp) ++ [("padding-right","0em")] )
            ++ viewDV (dadd (DV dj.amount dj.amount_exp) runtot) p drcr "has-text-right" [("","")]
                --( (roundingAlertStyle p dj.amount_exp) ++ [("padding-right","0em")] )
            ++
                [ td []
                    [ a
                        [ href ("/transactions/" ++ String.fromInt dj.tid)
                        , class "button is-link"
                        ]
                        [ language |> tx_edit |> text ]
                    ]
                ]

        )


viewDistributionJoineds : Model.Model -> { amt : Int, exp : Int } -> List DistributionJoined -> List (Html Msg)
viewDistributionJoineds model runtot distributionJoined =
    case distributionJoined of
         -- this function should not be called if there are no distributionJoineds, so this case should never happen.  But try tellin' that to Elm!
        [] ->
            [ tr [] [ td [] [ text "max fubar error" ] ] ]

        [ x ] ->
            [ viewDistributionJoined model.language (intFieldToInt model.accounts.decimalPlaces) runtot x model.drcr_format ]

        x :: xs ->
            viewDistributionJoined model.language (intFieldToInt model.accounts.decimalPlaces) runtot x model.drcr_format
                :: viewDistributionJoineds model (dadd { amt = x.amount, exp = x.amount_exp } runtot) xs


viewRESTPanel : Model.Model -> Html Msg
viewRESTPanel model =
    div [ class "box" ] []


viewTableHeader : Language -> DRCRFormat -> Html Msg
viewTableHeader language drcr =
    tr []
        (
            [ th [] [ text "Time" ]
            , th [] [ text "Notes" ]
            ]
            ++ dvColumnHeader "Amount" drcr
            ++ dvColumnHeader "Run tot" drcr
            ++ [ th [][] ] -- extra header for edit button
        )


viewTransactionsPanel : Model.Model -> Account.Model.Model -> Html Msg
viewTransactionsPanel model account_model =
    div [ class "box" ]
        [ if List.isEmpty account_model.distributionJoineds then
            div []
                [ h3 [] [ text "This account does not have any transactions" ] ]

          else
            div [ style "margin-top" "1.0em"  ]
                [ div [ class "field" ]
                    [ label [ class "label" ]
                        [ text
                            (tx model.language { e = "Decimal places", c = "小数位", p = "xiǎoshù wèi" })
                        ]
                    , div [ class "control" ]
                        [ input
                            [ class "input"
                            , placeholder "decimal places"
                            , onInput (\newValue -> AccountMsgA (UpdateDecimalPlaces newValue))
                            , type_ "text"
                            , value (intFieldToString account_model.decimalPlaces)
                            ]
                            []
                        ]
                    ]
                , viewTransactionsTable model account_model.distributionJoineds
                ]
        ]


viewTransactionsTable : Model.Model -> List DistributionJoined -> Html Msg
viewTransactionsTable model distributionJoineds =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language model.drcr_format ]
        , tbody [] (viewDistributionJoineds model { amt = 0, exp = 0 } distributionJoineds)
        ]
