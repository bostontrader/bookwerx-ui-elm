module Distribution.Views.AddEdit exposing (view)

-- Add and Edit are very similar. Unify them thus...

import Account.Model
import Category.Category exposing (CategoryShort)
import Distribution.Model
import Distribution.MsgB exposing (MsgB(..))
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, input, label, option, p, select, table, td, text, tr)
import Html.Attributes exposing (checked, class, href, name, selected, type_, value)
import Html.Events exposing (onClick, onInput)
import IntField exposing (IntField(..), intFieldToInt, intFieldToString, intValidationClass)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx_save)
import Types exposing (AEMode(..), DRCR(..), DRCRFormat(..))
import ViewHelpers exposing (viewHttpPanel)


addeditForm : Distribution.Model.Model -> DRCRFormat -> List (Html Msg) -> Html Msg
addeditForm distribution_model drcr_format accountOptions =
    div [ class "box" ]
        [ div [ class "field" ]
            [ label [ class "label" ] [ text "Account" ]
            , div [ class "control" ]
                [ div [ class "select" ]
                    [ select [ onInput (\newValue -> DistributionMsgA (UpdateAccountID newValue)) ]
                        accountOptions
                    ]
                ]
            ]
        , case drcr_format of
            DRCR ->
                div [ class "control" ]
                    [ label [ class "radio" ]
                        [ input
                            [ checked (distribution_model.editBuffer.drcr == DR)
                            , name "drcr"
                            , onInput (\newValue -> DistributionMsgA (UpdateDRCR newValue))
                            , type_ "radio"
                            , value "dr"
                            ]
                            []
                        , text "DR"
                        ]
                    , label [ class "radio" ]
                        [ input
                            [ checked (distribution_model.editBuffer.drcr == CR)
                            , name "drcr"
                            , onInput (\newValue -> DistributionMsgA (UpdateDRCR newValue))
                            , type_ "radio"
                            , value "cr"
                            ]
                            []
                        , text "CR"
                        ]
                    ]

            PlusAndMinus ->
                div [] []
        , case drcr_format of
            DRCR ->
                div [ class "field" ]
                    [ label [ class "label" ] [ text "Amount" ]
                    , div [ class "control" ]
                        [ input
                            [ class "input"
                            , class (intValidationClass distribution_model.editBuffer.amount)
                            , type_ "text"
                            , onInput (\newValue -> DistributionMsgA (UpdateAmount newValue))
                            , case distribution_model.editBuffer.amount of
                                IntField Nothing _ ->
                                    value ""

                                IntField (Just _) _ ->
                                    value (String.fromInt <| abs <| intFieldToInt <| distribution_model.editBuffer.amount)
                            ]
                            []
                        ]
                    ]

            PlusAndMinus ->
                div [ class "field" ]
                    [ label [ class "label" ] [ text "Amount" ]
                    , div [ class "control" ]
                        [ input
                            [ class "input"
                            , class (intValidationClass distribution_model.editBuffer.amount)
                            , type_ "text"
                            , onInput (\newValue -> DistributionMsgA (UpdateAmount newValue))
                            , value (intFieldToString distribution_model.editBuffer.amount)
                            ]
                            []
                        ]
                    ]
        , div [ class "field" ]
            [ label [ class "label" ] [ text "Amount Exp" ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , class (intValidationClass distribution_model.editBuffer.amount_exp)
                    , type_ "text"
                    , onInput (\newValue -> DistributionMsgA (UpdateAmountExp newValue))
                    , value (intFieldToString distribution_model.editBuffer.amount_exp)
                    ]
                    []
                ]
            ]
        ]


buildAccountSelect : Int -> Account.Model.Model -> List (Html Msg)
buildAccountSelect selected_id model =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        (List.map
            (\a ->
                option [ value (String.fromInt a.id), selected (a.id == selected_id) ]
                    [ text a.title
                    , p [] [ text ("," ++ a.currency.symbol) ]
                    , viewCategories a.categories
                    ]
            )
            (List.sortBy .title (List.filter (\a -> True || (a.id == selected_id)) model.accounts))
        )


leftContent : String -> DRCRFormat -> Language -> Html Msg
leftContent logMsg drcr_format language =
    div []
        [ p [] [ text "An amount is represented using two integers, using scientific notation." ]
        , p [] [ text "For example:" ]
        , table [ class "table" ]
            [ tr []
                [ td [] [ text "100" ]
                , td [] [ text "1" ]
                , td [] [ text "2" ]
                ]
            , tr []
                [ td [] [ text "1.5" ]
                , td [] [ text "15" ]
                , td [] [ text "-1" ]
                ]
            , tr []
                [ td [] [ text "0.00000042" ]
                , td [] [ text "42" ]
                , td [] [ text "-8" ]
                ]
            ]
        , case drcr_format of
            DRCR ->
                p [] [ text "Because your settings specify the use of DR/CR, you should make all amounts positive." ]

            PlusAndMinus ->
                p [] [ text "Use positive numbers to mean DR and negative to mean CR." ]
        , viewHttpPanel logMsg "" language
        ]


rightContent : String -> Msg -> Model.Model -> Html Msg
rightContent r_title r_onclick model =
    div []
        [ h3 [ class "title is-3" ] [ text r_title ]
        , viewFlash model.flashMessages
        , a [ href "/distributions" ] [ text "Distributions index" ]
        , addeditForm model.distributions
            model.drcr_format
            (buildAccountSelect model.distributions.editBuffer.account_id model.accounts)
        , div []
            [ button
                [ class "button is-link"
                , onClick r_onclick
                ]
                [ model.language |> tx_save |> text ]
            ]
        ]


view : Model.Model -> AEMode -> Html Msg
view model aemode =
    let
        postParams =
            "apikey="
                ++ model.apikeys.apikey
                ++ "&account_id="
                ++ String.fromInt model.distributions.editBuffer.account_id
                ++ "&amount="
                ++ intFieldToString model.distributions.editBuffer.amount
                ++ "&amount_exp="
                ++ intFieldToString model.distributions.editBuffer.amount_exp
                ++ "&transaction_id="
                ++ String.fromInt model.transactions.editBuffer.id

        putParams =
            postParams
                ++ "&id="
                ++ String.fromInt model.distributions.editBuffer.id

        r =
            case aemode of
                Add ->
                    { title = "Create New Distribution"
                    , onClick =
                        DistributionMsgA
                            (PostDistribution
                                (model.bservers.baseURL ++ "/distributions")
                                "application/x-www-form-urlencoded"
                                postParams
                            )
                    , logMsg =
                        "POST application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/distributions "
                            ++ postParams
                    }

                Edit ->
                    { title = "Edit Distribution"
                    , onClick =
                        DistributionMsgA
                            (PutDistribution
                                (model.bservers.baseURL ++ "/distributions")
                                "application/x-www-form-urlencoded"
                                putParams
                            )
                    , logMsg =
                        "PUT application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/distributions "
                            ++ putParams
                    }
    in
    template model
        (leftContent r.logMsg model.drcr_format model.language)
        (rightContent r.title r.onClick model)


viewCategories : List CategoryShort -> Html Msg
viewCategories categories =
    div [] (List.map (\c -> p [] [ text ("," ++ c.category_symbol) ]) categories)
