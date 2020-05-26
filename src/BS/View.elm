module BS.View exposing (view)

import Distribution.Distribution exposing (DistributionReport)
import BS.Form exposing (form)
import BS.Model exposing (FModel)
import BS.MsgB exposing (MsgB(..))
import Report.Report exposing (AccountSummary)
import Report.Transform exposing (xform1, xform2, xform2a, xform3)
import DecimalFP exposing (DFP, dfp_add)
import Dict
import Flash exposing (viewFlash)
import Form.View
import Html exposing (Html, div, h3, h4, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, style)
import Model
import Msg exposing (Msg(..))
import RemoteData exposing (WebData)
import Template exposing (template)
import Translate exposing (tx)
import Types exposing (DRCRFormat(..))
import Util exposing (getAccountTitle, getRemoteDataStatusMessage)
import ViewHelpers exposing (dvColumnHeader, viewDFP)


calcSum : List AccountSummary -> DFP
calcSum list =
    List.foldl
        (\a b -> dfp_add a.damt b)
        (DFP 0 0)
        list


leftContent : Model.Model -> Html Msg
leftContent model =

    let
        cfg = Form.View.ViewConfig (\fmodel -> BSMsgA (BS.MsgB.FormChanged fmodel)) "Produce Report" "loading" Form.View.ValidateOnSubmit
    in
        div[][ Form.View.asHtml cfg (form model.categories) model.bs.form ]


rightContent : Model.Model -> Html Msg
rightContent model =

    div []
        [ h3 [ class "title is-3" ]
            [ text
                (tx model.language
                    { e = "Balance Sheet", c = "资产负债表", p = "zīchǎn fùzhài biǎo" }
                )
            ]
        , viewFlash model.flashMessages
        , viewReport model
        ]


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)

viewBSSection : String -> Model.Model -> List DistributionReport -> WebData String -> Html Msg
viewBSSection heading model distributionReports wdDistributionReports =
    div [ class "box", style "margin-top" "1.0em" ]
        [ h4[][ text heading]
        , case wdDistributionReports of
            RemoteData.Success _ ->
                if List.isEmpty distributionReports then
                    h3 []
                        [ text
                            (tx model.language
                                { e = "No data found for this report"
                                , c = "找不到此报告的数据"
                                , p = "zhǎo bù dào cǐ bàogào de shùjù"
                                }
                            )
                        ]

                else
                    div []
                        (List.map (\n -> viewCurrencySection n model)
                            (Dict.toList
                                (xform3
                                    (xform2a model.report.omitZeros
                                        (xform2
                                            (xform1 "" model.bs.form.values.asofTime distributionReports)
                                        )
                                    )
                                    model.accounts
                                )
                            )
                        )


            RemoteData.Loading ->
                h3[][ text "loading"]

            _ ->
                h3 [] [ text ((getRemoteDataStatusMessage wdDistributionReports model.language)) ]
        ]


viewCurrencySection : ( String, List AccountSummary ) -> Model.Model -> Html Msg
viewCurrencySection cs model =
    div [ class "box", style "margin-top" "0.5em" ]
        [ p [] [ text (Tuple.first cs) ]
        , table [ class "table is-striped" ]
            [ thead []
                ([ th [] [ text (tx model.language { e = "Account ID", c = "账户号码", p = "zhànghù haoma" }) ]
                 , th [] [ text (tx model.language { e = "Title", c = "标题", p = "biāotí" }) ]
                 ]
                    ++ dvColumnHeader (tx model.language { e = "Amount", c = "量", p = "Liàng" }) model.drcr_format
                )
            , tbody []
                (List.map
                    (\line ->
                        tr []
                            ([ td [] [ text (String.fromInt line.account_id) ]
                             , td [] [ text (getAccountTitle model.accounts line.account_id) ]
                             ]
                                ++ viewDFP
                                    line.damt
                                    model.report.decimalPlaces
                                    model.drcr_format
                            )
                    )
                    (Tuple.second cs)
                    ++ [ tr []
                            ([ td [] [], td [ class "has-text-right has-text-weight-bold" ] [ text (tx model.language { e = "Total", c = "总", p = "zǒng" }) ] ]
                                ++ viewDFP
                                    (calcSum (Tuple.second cs))
                                    model.report.decimalPlaces
                                    model.drcr_format
                            )
                       ]
                )
            ]
        ]


viewReport : Model.Model -> Html Msg
viewReport model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ viewBSSection "Assets" model model.bs.distributionReportsA model.bs.wdDistributionReportsA
        , viewBSSection "Liabilities" model model.bs.distributionReportsL model.bs.wdDistributionReportsL
        , viewBSSection "Equity" model model.bs.distributionReportsEq model.bs.wdDistributionReportsEq
        , viewBSSection "Revenue" model model.bs.distributionReportsR model.bs.wdDistributionReportsR
        , viewBSSection "Expenses" model model.bs.distributionReportsEx model.bs.wdDistributionReportsEx
        ]
