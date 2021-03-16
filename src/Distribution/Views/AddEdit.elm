module Distribution.Views.AddEdit exposing (view)

-- Add and Edit are very similar. Unify them thus...

import Category.Category exposing (CategoryShort)
import Category.Model
import Distribution.Model
import Distribution.MsgB exposing (MsgB(..))
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h1, input, label, option, p, select, table, td, text, tr)
import Html.Attributes exposing (checked, class, href, name, selected, type_, value)
import Html.Events exposing (onClick, onInput)
import IntField exposing (IntField(..), intFieldToString, intValidationClass)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx_save)
import Types exposing (AEMode(..), DRCR(..), DRCRFormat(..))
import Util exposing (getCategorySymbol, getCurrencySymbol)
import ViewHelpers exposing (viewHttpPanel)


addeditForm : Distribution.Model.Model -> DRCRFormat -> List (Html Msg) -> List (Html Msg) -> List (Html Msg) -> Html Msg
addeditForm distribution_model drcr_format accountOptions categoryOptions currencyOptions =
    div [ class "box" ]
        [ div [ class "box" ]
            [ h1 [ class "title is-4" ] [ text "Account selection" ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Filter on Currency" ]
                , div [ class "control" ]
                    [ div [ class "select" ]
                        [ select [ onInput (\newValue -> DistributionMsgA (UpdateFilterCurrencyID newValue)) ]
                            currencyOptions
                        ]
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Filter on Category" ]
                , div [ class "control" ]
                    [ div [ class "select" ]
                        [ select [ onInput (\newValue -> DistributionMsgA (UpdateFilterCategoryID newValue)) ]
                            categoryOptions
                        ]
                    ]
                ]
            , div [ class "field" ]
                [ label [ class "label" ] [ text "Account" ]
                , div [ class "control" ]
                    [ div [ class "select" ]
                        [ select [ onInput (\newValue -> DistributionMsgA (UpdateAccountID newValue)) ]
                            accountOptions
                        ]
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
                            , value (intFieldToString distribution_model.editBuffer.amount)
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



{-
   This function will build a List of select options for the accounts available to select from.

   The contents of this list depend upon whatever filter currency and/or category has been selected, if any,
   and whether or not this is a new or existing distribution record.
-}


buildAccountSelect : Int -> Model.Model -> List (Html Msg)
buildAccountSelect selected_currency_id model =
    let
        new_record =
            model.distributions.editBuffer.account_id == -1

        -- True means this is a new record
        -- filter accounts by category _or_ whichever account is already selected
        category_filter =
            if model.distributions.editBuffer.category_filter_id == -1 then
                \_ -> True
                -- no filter

            else
                let
                    category_symbol =
                        getCategorySymbol model.categories model.distributions.editBuffer.category_filter_id
                in
                \acct ->
                    case
                        ( List.filter (\cat -> cat.category_symbol == category_symbol) acct.categories
                        , acct.id == selected_currency_id
                        )
                    of
                        ( [], False ) ->
                            False

                        ( _, False ) ->
                            True

                        ( [], True ) ->
                            True

                        ( _, True ) ->
                            True

        -- filter accounts by currency _or_ whichever account is already selected
        currency_filter =
            if model.distributions.editBuffer.currency_filter_id == -1 then
                \_ -> True
                -- no filter

            else
                let
                    currency_symbol =
                        getCurrencySymbol model.currencies model.distributions.editBuffer.currency_filter_id
                in
                \acct -> acct.currency.symbol == currency_symbol || (acct.id == selected_currency_id)

        base_option_list =
            if new_record then
                [ option [ value "-1" ] [ text "None Selected" ] ]

            else
                []
    in
    List.append base_option_list <|
        List.map
            (\a ->
                option [ value (String.fromInt a.id), selected (a.id == selected_currency_id) ]
                    [ text a.title
                    , p [] [ text ("," ++ a.currency.symbol) ]
                    , viewCategories a.categories
                    ]
            )
        <|
            List.sortBy .title <|
                List.filter currency_filter <|
                    List.filter category_filter model.accounts.accounts



-- Give a Category.Model and a selected_id, return a List of option for the Categories


buildCategorySelect : Category.Model.Model -> Int -> List (Html msg)
buildCategorySelect model selected_id =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ] <|
        List.map
            (\category ->
                option
                    [ value (String.fromInt category.id), selected (category.id == selected_id) ]
                    [ text (category.symbol ++ "- " ++ category.title) ]
            )
        <|
            List.sortBy .title model.categories



-- This is duplicated from Account/Views/AddEdit.  Factor these out.


buildCurrencySelect : Model.Model -> Int -> List (Html msg)
buildCurrencySelect model selected_id =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        (List.map
            (\cur -> option [ value (String.fromInt cur.id), selected (cur.id == selected_id) ] [ text (cur.symbol ++ " " ++ cur.title) ])
            (List.sortBy .symbol model.currencies.currencies)
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
        [ h1 [ class "title is-3" ] [ text r_title ]
        , viewFlash model.flashMessages
        , a [ href "/distributions" ] [ text "Distributions index" ]
        , addeditForm model.distributions
            model.drcr_format
            (buildAccountSelect model.distributions.editBuffer.account_id model)
            (buildCategorySelect model.categories model.distributions.editBuffer.category_filter_id)
            (buildCurrencySelect model model.distributions.editBuffer.currency_filter_id)
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
                ++ "&amountbt="
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
