module Report.View.ManyCategory exposing (viewManyCategories)

import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Msg exposing (Msg(..))
import Report.Model exposing (ManyCatTypes(..))
import Report.View.OneCategory as OneCat
import Translate exposing (Language)


viewManyCategories : ManyCatTypes -> Report.Model.Model -> Language -> Html Msg
viewManyCategories reportType model language =
    case reportType of
        BSm ->
            div [ class "manyCategories" ]
                [ p [ class "is-size-4" ] [ text "Balance Sheet" ]
                , p [ class "is-size-5" ]
                    [ text ("As of " ++ model.form.values.stopTime) ]
                , OneCat.viewOneCategory model model.wdDistributionReportsA model.distributionReportsA (Just "Assets") language
                , OneCat.viewOneCategory model model.wdDistributionReportsL model.distributionReportsL (Just "Liabilities") language
                , OneCat.viewOneCategory model model.wdDistributionReportsEq model.distributionReportsEq (Just "Equity") language
                , OneCat.viewOneCategory model model.wdDistributionReportsR model.distributionReportsR (Just "Revenue") language
                , OneCat.viewOneCategory model model.wdDistributionReportsEx model.distributionReportsEx (Just "Expenses") language
                ]

        PNLm ->
            div [ class "manyCategories" ]
                [ p [ class "is-size-4" ] [ text "Profit and Loss Statement" ]
                , p [ class "is-size-5" ]
                    [ text
                        ("During the period starting "
                            ++ model.form.values.startTime
                            ++ " and ending "
                            ++ model.form.values.stopTime
                        )
                    ]
                , OneCat.viewOneCategory model model.wdDistributionReportsR model.distributionReportsR (Just "Revenue") language
                , OneCat.viewOneCategory model model.wdDistributionReportsEx model.distributionReportsEx (Just "Expenses") language
                ]
