module Report.View exposing (view)

import Category.Model
import Decimal exposing (dadd, dvColumnHeader, viewDV)
import Distribution.Distribution exposing (DistributionReport)
import Flash exposing (viewFlash)
import Html exposing (Html, button, div, h3, label, input, option, p, select, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, name, placeholder, selected, style, type_, value)
import Html.Events exposing (onClick, onInput)
import IntField exposing (intFieldToInt, intFieldToString)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Report.Model exposing (StockOrFlow(..))
import Report.MsgB exposing (..)
import Template exposing (template)
import Translate exposing (tx)
import Util exposing (getAccountTitle, getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


buildCategorySelect : Category.Model.Model -> Int -> List (Html msg)
buildCategorySelect model selected_id =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        (List.map
            (\cur -> option [ value (String.fromInt cur.id), selected (cur.id == selected_id) ] [ text (cur.symbol ++ " " ++ cur.title) ])
            (List.sortBy .symbol model.categories)
        )

getURL : Model.Model -> String
getURL model = model.bservers.baseURL
    ++ "/balance?"
    ++ "apikey=" ++ model.apikeys.apikey
    ++ "&category_id=" ++ String.fromInt model.report.category_id
    ++ "&time=" ++ model.report.stopTime


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
        , p [ style "margin-top" "0.5em"  ]
            [ text
                (tx model.language
                    { e = "Flow- Display the changes of the balances of the accounts in a category during a period of time."
                    , c = "Flow- Display the changes of the balances of the accounts in a category during a period of time."
                    , p = "Flow- Display the changes of the balances of the accounts in a category during a period of time."
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
                    { e = "Report"
                    , c = "Report"
                    , p = "Report"
                    }
                )
            ]
        , viewFlash model.flashMessages

        , div [ class "field" ]
            [ label [ class "label" ] [ text "Category" ]
            , div [ class "control" ]
                [ div [ class "select" ]
                    [ select [
                        onInput (\newValue -> ReportMsgA (UpdateCategoryID newValue))
                        ]
                        (buildCategorySelect model.categories -1)
                    ]
                ]
            ]

        , if model.report.uiLevel >= 1 then
            div [ class "control" ]
                [ label [ class "radio" ]
                    [ input
                        [ name "sof"
                        , onInput (\newValue -> ReportMsgA (UpdateSOF newValue))
                        , type_ "radio"
                        , value "stock"
                        ]
                        []
                    , text "Stock"
                    ]
                , label [ class "radio" ]
                    [ input
                        [ name "sof"
                        , onInput (\newValue -> ReportMsgA (UpdateSOF newValue))
                        , type_ "radio"
                        , value "flow"
                        ]
                        []
                    , text "Flow"
                    ]
                ]
        else
            div[][]

        , if model.report.uiLevel >= 2 then
            viewTimeControls model
        else
            div[][]

        , if readyFreddie model then
            button
                [ class "button is-link"
                , onClick (ReportMsgA (Report.MsgB.GetDistributions (getURL model) ))
                , style "margin-top" "1.0em"
                ]
                [ text (tx model.language {e = "Produce report", c = "Produce report", p = "Produce report"}) ]
        else
            div[][]

        , viewReport model
        ]

--viewFlowControls : Html Msg
--viewFlowControls  =
    --div[] [
        --text "flow controls"
    --]

readyFreddie : Model.Model -> Bool
readyFreddie m =
    case m.report.sof of
        Just sof ->
            case sof of
                Stock ->
                    String.length m.report.stopTime > 0

                Flow ->
                    String.length m.report.startTime > 0 && String.length  m.report.stopTime > 0

        Nothing ->
            False

view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


--viewFlowReport : Model.Model -> Html Msg
--viewFlowReport model  =
    --div []
        --[ viewFlowControls
        --, text "flow report"
        --, viewReport model
        --]


viewTimeControls : Model.Model -> Html Msg
viewTimeControls model =
    case model.report.sof of
        Just sof ->
            div []
                [ case sof of
                    Stock ->
                        div[][]
                    Flow ->
                        div [ class "field" ]
                            [ label [ class "label" ] [ text "Start time" ]
                            , div [ class "control" ]
                                [ input
                                    [ class "input"
                                    , type_ "text"
                                    , value model.report.startTime
                                    , onInput (\newValue -> ReportMsgA (UpdateStartTime newValue))
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
                                        , onInput (\newValue -> ReportMsgA (UpdateStopTime newValue))
                                        , placeholder "2019-09-01T12:35:45.123Z"
                                        ]
                                        []
                                    ]
                                ]
                ]
        Nothing ->
            div[][]


viewReport : Model.Model -> Html Msg
viewReport model =
    div [ class "box", style  "margin-top" "1.0em" ]
        [




         case model.report.wdDistributionReports of
            RemoteData.Success s ->
                if List.isEmpty model.report.distributionReports then
                    h3 [] [ text "No data found for this report." ]
                else
                    div[]
                        [ div [ class "field" ]
                                      [ label [ class "label" ]
                                          [ text
                                              (tx model.language { e = "Decimal places", c = "小数位", p = "xiǎoshù wèi" })
                                          ]
                                      , div [ class "control" ]
                                        [ input
                                            [ class "input"
                                                , placeholder "decimal places"
                                                , onInput (\newValue -> ReportMsgA (UpdateDecimalPlaces newValue))
                                                , type_ "text"
                                                , value (intFieldToString model.report.decimalPlaces)
                                            ]
                                            []
                                        ]
                                      ]
                    , table[ class "table is-striped" ]
                            [ thead []
                                (
                                [ th [] [ text "Account ID"]
                                , th [] [ text "Title"]
                                ]
                                ++ dvColumnHeader "Amount" model.drcr_format
                                )
                            , tbody []
                                (List.map (\dogfood->
                                    tr []
                                        ([ td [] [ text (String.fromInt dogfood.account_id)]
                                        , td [] [ text (getAccountTitle model.accounts dogfood.account_id) ]
                                        --, td
                                            --[ class "has-text-right"
                                            --, style (roundingAlertStyle 2 dogfood.amount_exp)
                                            --]
                                            --[ text (dfmt (intFieldToInt model.report.decimalPlaces) { amt = dogfood.damt.amt, exp = dogfood.damt.exp }) ]

                                        ]
                                        ++ viewDV
                                            dogfood.damt
                                            ( intFieldToInt <| model.report.decimalPlaces)
                                            model.drcr_format
                                            "has-text-right" [("","")]
                                            --( (roundingAlertStyle ( intFieldToInt <| model.report.decimalPlaces) dogfood.damt.exp) ++ [("padding-right","0em")] )
                                            )
                                        ) (rollup model.report))


                            ]
                        ]
            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.report.wdDistributionReports model.language) ]

        ]


--viewStockControls : Html Msg
--viewStockControls  =
    --div[] [
        --text "stock controls"
    --]


--viewStockReport : Model.Model -> Html Msg
--viewStockReport model =
    --div []
        --[ viewStockControls
        --, text "stock report"
        --, viewReport model
        --]








type alias Dogfood =
    { account_id : Int
    , damt : {amt : Int, exp : Int}
    }


-- A wrapper to ensure that the List of DistributionReport is properly sorted, as well as to filter according to datetime
rollup : Report.Model.Model -> List Dogfood
rollup reportModel =
    rollupInner (List.sortBy .account_id (List.filter (\d -> d.time >= reportModel.startTime) reportModel.distributionReports ))


-- The List of DistributionReport must be sorted by account_id
rollupInner : List DistributionReport -> List Dogfood
rollupInner distributionReports =

    case List.head distributionReports of
        Just head ->
            case List.tail distributionReports of
                Just tail ->
                    Dogfood
                        head.account_id
                            ( List.foldl
                                add
                                {amt = head.amount, exp = head.amount_exp}
                                ( tail |> List.filter (\c -> c.account_id == head.account_id) ))

                    :: rollupInner (List.filter (\c -> c.account_id /= head.account_id) tail)

                Nothing ->
                    [Dogfood head.account_id {amt = head.amount, exp = head.amount_exp}]

        Nothing ->
            [] -- no head means empty list


add : DistributionReport -> { amt : Int, exp : Int } -> { amt : Int, exp : Int }
add dr b = dadd {amt = dr.amount, exp = dr.amount_exp} b
