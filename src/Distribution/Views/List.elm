module Distribution.Views.List exposing (view)

import DecimalFP exposing (DFP, Sign(..), md_fromString)
import Distribution.Distribution exposing (DistributionJoined)
import Distribution.Model
import Distribution.MsgB exposing (MsgB(..))
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, input, label, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, style, type_, value)
import Html.Events exposing (onClick)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Template exposing (template)
import Translate exposing (Language, tx, tx_delete, tx_edit)
import Types exposing (DRCRFormat(..))
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (dvColumnHeader, viewDFP, viewHttpPanel)


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ viewHttpPanel
            ("GET "
                ++ model.bservers.baseURL
                ++ "/distributions/for_tx?apikey="
                ++ model.apikeys.apikey
                ++ "&transaction_id="
                ++ String.fromInt model.transactions.editBuffer.id
            )
            (getRemoteDataStatusMessage model.distributions.wdDistributionJoineds model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ] [ text ("Distributions for Transaction # " ++ String.fromInt model.transactions.editBuffer.id) ]
        , viewFlash model.flashMessages
        , a [ href "/distributions/add", class "button is-link" ]
            [ text "Create new distribution" ]
        , viewDistributionsPanel model model.distributions
        ]


view : Model.Model -> Html Msg
view model =
    template model
        (leftContent model)
        (rightContent model)


viewDistribution : Model.Model -> DistributionJoined -> Html Msg
viewDistribution model distributionJoined =
    let
        distributionPath =
            "/distributions/" ++ String.fromInt distributionJoined.id

        ( md, sign ) =
            md_fromString distributionJoined.amountbt
    in
    tr []
        ([ td [] [ text (String.fromInt distributionJoined.id) ]
         , td [] [ text distributionJoined.account_title ]
         ]
            --++ viewDFP (DFP distributionJoined.amount distributionJoined.amount_exp) model.distributions.decimalPlaces model.drcr_format
            ++ viewDFP (DFP md distributionJoined.amount_exp sign) model.distributions.decimalPlaces model.drcr_format
            --( (roundingAlertStyle (intFieldToInt model.accounts.decimalPlaces) distributionJoined.amount_exp) ++ [("padding-right","0em")] )
            --, --td
            --[ class "has-text-right"
            --, style (roundingAlertStyle p dj.amount_exp)
            --]
            --[ text (dfmt (intFieldToInt model.accounts.precision) { amt = distributionJoined.amount, exp = distributionJoined.amount_exp }) ]
            --[ text "" ]
            ++ [ td []
                    [ a [ href distributionPath, class "button is-link" ] [ model.language |> tx_edit |> text ] ]
               , td []
                    [ button
                        [ class "button is-link is-danger"
                        , onClick
                            (DistributionMsgA
                                (DeleteDistribution
                                    ((model.bservers.baseURL ++ "/distribution/")
                                        ++ String.fromInt distributionJoined.id
                                        ++ "?apikey="
                                        ++ model.apikeys.apikey
                                        ++ "&transaction_id=666"
                                    )
                                )
                            )
                        ]
                        [ model.language |> tx_delete |> text ]
                    ]
               ]
        )


viewDistributionsPanel : Model.Model -> Distribution.Model.Model -> Html Msg
viewDistributionsPanel model distribution_model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ case model.distributions.wdDistributionJoineds of
            RemoteData.Success _ ->
                if List.isEmpty distribution_model.distributionJoineds then
                    h3 [] [ text "This transaction does not have any distributions" ]

                else
                    div [ style "margin-top" "1.0em" ]
                        [ label [ class "label" ]
                            [ text
                                (tx model.language { e = "Decimal places", c = "小数位", p = "xiǎoshù wèi" })
                            ]
                        , div [ class "control" ]
                            [ input
                                [ class "input"

                                --, class (intValidationClass distribution_model.decimalPlaces)
                                --, placeholder "decimal places"
                                --, onInput (\newValue -> DistributionMsgA (UpdateDecimalPlaces newValue))
                                , type_ "text"
                                , value (String.fromInt distribution_model.decimalPlaces)
                                ]
                                []
                            ]
                        , button
                            [ class "button is-link"
                            , style "margin-top" "0.3em"
                            , onClick
                                (DistributionMsgA (UpdateDecimalPlaces (distribution_model.decimalPlaces + 1)))
                            ]
                            [ text "+" ]
                        , button
                            [ class "button is-link"
                            , style "margin-left" "0.3em"
                            , style "margin-top" "0.3em"
                            , onClick
                                (DistributionMsgA (UpdateDecimalPlaces (distribution_model.decimalPlaces - 1)))
                            ]
                            [ text "-" ]
                        , viewDistributionsTable model distribution_model.distributionJoineds
                        ]

            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.distributions.wdDistributionJoineds model.language) ]
        ]


viewDistributionsTable : Model.Model -> List DistributionJoined -> Html Msg
viewDistributionsTable model distributionJoineds =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language model.drcr_format ]
        , tbody [] (List.map (viewDistribution model) distributionJoineds)
        ]


viewTableHeader : Language -> DRCRFormat -> Html Msg
viewTableHeader language drcr =
    tr []
        ([ th [] [ text (tx language { e = "ID", c = "号码", p = "hao ma" }) ]
         , th [] [ text "Account" ]
         ]
            ++ dvColumnHeader "Amount" drcr
            ++ [ th [] [] -- extra headers for edit and delete
               , th [] []
               ]
        )
