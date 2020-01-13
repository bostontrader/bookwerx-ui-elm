module Report.View exposing (view)

import Category.Model
import DecimalFP exposing (DFP, dfp_add)
import Dict
import Flash exposing (viewFlash)
import Html exposing (Html, button, div, h3, input, label, option, p, select, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (checked, class, name, placeholder, selected, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Report.Model exposing (StockOrFlow(..))
import Report.MsgB
import Report.Report exposing (AccountSummary)
import Report.Transform exposing (xform1, xform2, xform2a, xform3)
import Template exposing (template)
import Translate exposing (tx)
import Types exposing (DRCRFormat(..))
import Util exposing (getAccountTitle, getRemoteDataStatusMessage)
import ViewHelpers exposing (dvColumnHeader, viewDFP, viewHttpPanel)


buildCategorySelect : Category.Model.Model -> Int -> List (Html msg)
buildCategorySelect model selected_id =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        (List.map
            (\cur -> option [ value (String.fromInt cur.id), selected (cur.id == selected_id) ] [ text (cur.symbol ++ " " ++ cur.title) ])
            (List.sortBy .symbol model.categories)
        )


getURL : Model.Model -> String
getURL model =
    model.bservers.baseURL
        ++ "/balance?"
        ++ "apikey="
        ++ model.apikeys.apikey
        ++ "&category_id="
        ++ String.fromInt model.report.category_id
        ++ "&time="
        ++ model.report.stopTime


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ p []
            [ text
                (tx model.language
                    { e = "Stock- Display the balances of the accounts in a category as of an instant in time."
                    , c = "Stock- Display the balances of the accounts in a category as of an instant in time."
                    , p = "Stock- Display the balances of the accounts in a category as of an instant in time."
                    }
                )
            ]
        , p [ style "margin-top" "0.5em" ]
            [ text
                (tx model.language
                    { e = "Flow- Display the changes of the balances of the accounts in a category during a period of time."
                    , c = "Flow- Display the changes of the balances of the accounts in a category during a period of time."
                    , p = "Flow- Display the changes of the balances of the accounts in a category during a period of time."
                    }
                )
            ]
        , p [ style "margin-top" "0.5em" ]
            [ text
                (tx model.language
                    { e = "The API call retrieves all relevant distributions for transactions <= the stop date.  It is the job of the client to filter, fold, and sort these distributions into a sensible output format."
                    , c = "The API call retrieves all relevant distributions for transactions <= the stop date.  It is the job of the client to filter, fold, and sort these distributions into a sensible output format."
                    , p = "The API call retrieves all relevant distributions for transactions <= the stop date.  It is the job of the client to filter, fold, and sort these distributions into a sensible output format."
                    }
                )
            ]
        , viewHttpPanel
            (getURL model)
            (getRemoteDataStatusMessage model.report.wdDistributionReports model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text
                (tx model.language
                    { e = "Report", c = "汇报", p = "Huìbào" }
                )
            ]
        , viewFlash model.flashMessages
        , div [ class "field" ]
            [ label [ class "label" ] [ text (tx model.language { e = "Category", c = "类别", p = "lèibié" }) ]
            , div [ class "control" ]
                [ div [ class "select" ]
                    [ select
                        [ onInput (\newValue -> ReportMsgA (Report.MsgB.UpdateCategoryID newValue)) ]
                        (buildCategorySelect model.categories -1)
                    ]
                ]
            ]
        , if model.report.uiLevel >= 1 then
            div [ class "control" ]
                [ label [ class "radio" ]
                    [ input
                        [ name "sof"
                        , onInput (\newValue -> ReportMsgA (Report.MsgB.UpdateSOF newValue))
                        , type_ "radio"
                        , value "stock"
                        ]
                        []
                    , text "Stock"
                    ]
                , label [ class "radio" ]
                    [ input
                        [ name "sof"
                        , onInput (\newValue -> ReportMsgA (Report.MsgB.UpdateSOF newValue))
                        , type_ "radio"
                        , value "flow"
                        ]
                        []
                    , text "Flow"
                    ]
                ]

          else
            div [] []
        , if model.report.uiLevel >= 2 then
            viewTimeControls model

          else
            div [] []
        , if readyFreddie model then
            button
                [ class "button is-link"
                , onClick (ReportMsgA (Report.MsgB.GetDistributions (getURL model)))
                , style "margin-top" "1.0em"
                ]
                [ text (tx model.language { e = "Produce report", c = "产生报告", p = "chǎnshēng bàogào" }) ]

          else
            div [] []
        , viewReport model
        ]


readyFreddie : Model.Model -> Bool
readyFreddie m =
    case m.report.sof of
        Just sof ->
            case sof of
                Stock ->
                    String.length m.report.stopTime > 0

                Flow ->
                    String.length m.report.startTime > 0 && String.length m.report.stopTime > 0

        Nothing ->
            False


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


viewTimeControls : Model.Model -> Html Msg
viewTimeControls model =
    case model.report.sof of
        Just sof ->
            div []
                [ case sof of
                    Stock ->
                        div [] []

                    Flow ->
                        div [ class "field" ]
                            [ label [ class "label" ] [ text "Start time" ]
                            , div [ class "control" ]
                                [ input
                                    [ class "input"
                                    , type_ "text"
                                    , value model.report.startTime
                                    , onInput (\newValue -> ReportMsgA (Report.MsgB.UpdateStartTime newValue))
                                    , placeholder "2019-09-01T12:35:45.123Z"
                                    ]
                                    []
                                ]
                            ]
                , div [ class "field" ]
                    [ label [ class "label" ] [ text "Stop time" ]
                    , div [ class "control" ]
                        [ input
                            [ class "input"
                            , type_ "text"
                            , value model.report.stopTime
                            , onInput (\newValue -> ReportMsgA (Report.MsgB.UpdateStopTime newValue))
                            , placeholder "2019-09-01T12:35:45.123Z"
                            ]
                            []
                        ]
                    ]
                ]

        Nothing ->
            div [] []


viewReport : Model.Model -> Html Msg
viewReport model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ case model.report.wdDistributionReports of
            RemoteData.Success _ ->
                if List.isEmpty model.report.distributionReports then
                    h3 []
                        [ text
                            (tx model.language
                                { e = "No data found for this report"
                                , c = "找不到此报告的数据"
                                , p = "Zhǎo bù dào cǐ bàogào de shùjù"
                                }
                            )
                        ]

                else
                    div []
                        [ label [ class "label" ]
                            [ text
                                (tx model.language { e = "Decimal places", c = "小数位", p = "xiǎoshù wèi" })
                            ]
                        , div [ class "control" ]
                            [ input
                                [ class "input"
                                , type_ "text"
                                , value (String.fromInt model.report.decimalPlaces)
                                ]
                                []
                            ]
                        , button
                            [ class "button is-link"
                            , style "margin-top" "0.3em"
                            , onClick
                                (ReportMsgA (Report.MsgB.UpdateDecimalPlaces (model.report.decimalPlaces + 1)))
                            ]
                            [ text "+" ]
                        , button
                            [ class "button is-link"
                            , style "margin-left" "0.3em"
                            , style "margin-top" "0.3em"
                            , onClick
                                (ReportMsgA (Report.MsgB.UpdateDecimalPlaces (model.report.decimalPlaces - 1)))
                            ]
                            [ text "-" ]
                        , label [ class "label", style "margin-top" "0.5em" ]
                            [ text
                                (tx model.language { e = "Omit accounts with zero balances.", c = "忽略余额为零的帐户", p = "hūlüè yú'é wéi líng de zhànghù" })
                            ]
                        , input
                            [ checked model.report.omitZeros
                            , onClick (ReportMsgA Report.MsgB.ToggleOmitZeros)
                            , type_ "checkbox"
                            ]
                            []
                        , div []
                            (List.map (\n -> viewCurrencySection n model)
                                (Dict.toList
                                    (xform3
                                        (xform2a model.report.omitZeros
                                            (xform2
                                                (xform1 model.report.startTime model.report.stopTime model.report.distributionReports)
                                            )
                                        )
                                        model.accounts
                                    )
                                )
                            )
                        ]

            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.report.wdDistributionReports model.language) ]
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


calcSum : List AccountSummary -> DFP
calcSum list =
    List.foldl
        (\a b -> dfp_add a.damt b)
        (DFP 0 0)
        list
