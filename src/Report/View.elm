module Report.View exposing (view)

import Flash exposing (viewFlash)
import Form.View
import Html exposing (Html, button, div, input, label, text)
import Html.Attributes exposing (checked, class, style, type_, value)
import Html.Events exposing (onClick)
import Model
import Msg exposing (Msg(..))
import Report.Form exposing (form)
import Report.Model exposing (FModel, ManyCatTypes(..), ReportTypes(..))
import Report.Msg
import Report.View.ManyCategory as ManyCat
import Report.View.OneCategory as OneCat
import Template exposing (template)
import Translate exposing (Language, tx)


leftContent : Model.Model -> Html Msg
leftContent model =
    let
        cfg =
            Form.View.ViewConfig (\fmodel -> Report (Report.Msg.FormChanged fmodel)) "Produce Report" "loading" Form.View.ValidateOnSubmit
    in
    div []
        [ Form.View.asHtml cfg (form model.categories) model.report.form
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div [ class "rightContent" ]
        (viewFlash model.flashMessages
            :: viewReport model.report model.language
        )


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


viewReport : Report.Model.Model -> Language -> List (Html Msg)
viewReport model language =
    case model.reportType of
        Just Stock ->
            [ viewTweaker model language
            , OneCat.viewOneCategory model model.wdDistributionReports model.distributionReports Nothing language
            ]

        Just Flow ->
            [ viewTweaker model language
            , OneCat.viewOneCategory model model.wdDistributionReports model.distributionReports Nothing language
            ]

        Just BS ->
            [ viewTweaker model language
            , ManyCat.viewManyCategories BSm model language
            ]

        Just PNL ->
            [ viewTweaker model language
            , ManyCat.viewManyCategories PNLm model language
            ]

        _ ->
            [ div [] [ text "no report type specified" ] ]


viewTweaker : Report.Model.Model -> Language -> Html Msg
viewTweaker model language =
    div [ class "box tweaker" ]
        [ label [ class "label" ]
            [ text (tx language { e = "Decimal places", c = "小数位", p = "xiǎoshù wèi" }) ]
        , div [ class "control" ]
            [ input
                [ class "input"
                , type_ "text"
                , value (String.fromInt model.decimalPlaces)
                ]
                []
            ]
        , button
            [ class "button is-link"
            , style "margin-top" "0.3em"
            , onClick
                (Report (Report.Msg.UpdateDecimalPlaces (model.decimalPlaces + 1)))
            ]
            [ text "+" ]
        , button
            [ class "button is-link"
            , style "margin-left" "0.3em"
            , style "margin-top" "0.3em"
            , onClick
                (Report (Report.Msg.UpdateDecimalPlaces (model.decimalPlaces - 1)))
            ]
            [ text "-" ]
        , label [ class "label", style "margin-top" "0.5em" ]
            [ text
                (tx language { e = "Omit accounts with zero balances.", c = "忽略余额为零的帐户", p = "hūlüè yú'é wéi líng de zhànghù" })
            ]
        , input
            [ checked model.omitZeros
            , onClick (Report Report.Msg.ToggleOmitZeros)
            , type_ "checkbox"
            ]
            []
        ]
