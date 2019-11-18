module Account.Views.AddEdit exposing (view)

-- Add and Edit are very similar. Unify them thus...

import Account.Account exposing (Account)
import Account.MsgB exposing (MsgB(..))
import Currency.Model
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, input, label, option, select, text)
import Html.Attributes exposing (class, href, placeholder, selected, type_, value)
import Html.Events exposing (onClick, onInput)
import IntField
    exposing
        ( intFieldToString
        , intValidationClass
        )
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx, tx_save)
import Types exposing (AEMode(..))
import ViewHelpers exposing (viewHttpPanel)


addeditForm : Language -> Account -> List (Html Msg) -> Html Msg
addeditForm language editBuffer currencyOptions =
    div [ class "box" ]
        [ div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Title", c = "标题", p = "biāotí" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , value editBuffer.title
                    , onInput (\newValue -> AccountMsgA (UpdateTitle newValue))
                    ]
                    []
                ]
            ]
        , div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Currency", c = "货币", p = "huòbì" }) ]
            , div [ class "control" ]
                [ div [ class "select" ]
                    [ select [ onInput (\newValue -> AccountMsgA (UpdateCurrencyID newValue)) ]
                        currencyOptions
                    ]
                ]
            ]
        , div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Rarity", c = "常用", p = "chángyòng" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , class (intValidationClass editBuffer.rarity)
                    , placeholder "rarity"
                    , type_ "text"
                    , onInput (\newValue -> AccountMsgA (UpdateRarity newValue))
                    , value (intFieldToString editBuffer.rarity)
                    ]
                    []
                ]
            ]
        ]


buildCurrencySelect : Currency.Model.Model -> Int -> List (Html msg)
buildCurrencySelect model selected_id =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        (List.map
            (\cur -> option [ value (String.fromInt cur.id), selected (cur.id == selected_id) ] [ text (cur.symbol ++ " " ++ cur.title) ])
            (List.sortBy .symbol model.currencies)
        )


leftContent : String -> Language -> Html Msg
leftContent logMsg language =
    div []
        [ viewHttpPanel logMsg "" language ]


rightContent : String -> Msg -> Model.Model -> Html Msg
rightContent r_title r_onclick model =
    div []
        [ h3 [ class "title is-3" ] [ text r_title ]
        , viewFlash model.flashMessages
        , a [ href "/accounts" ]
            [ text (tx model.language { e = "Accounts Index", c = "返回账户目录", p = "fanhui zhànghù mulu" }) ]
        , addeditForm model.language
            model.accounts.editBuffer
            (buildCurrencySelect model.currencies model.accounts.editBuffer.currency_id)
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
                ++ "&currency_id="
                ++ String.fromInt model.accounts.editBuffer.currency_id
                ++ "&rarity="
                ++ intFieldToString model.accounts.editBuffer.rarity
                ++ "&title="
                ++ model.accounts.editBuffer.title

        putParams =
            postParams
                ++ "&id="
                ++ String.fromInt model.accounts.editBuffer.id

        r =
            case aemode of
                Add ->
                    { title = tx model.language { e = "Create new account", c = "创建新账户", p = "chuàngjiàn xīn zhànghù" }
                    , onClick =
                        AccountMsgA
                            (PostAccount
                                (model.bservers.baseURL ++ "/accounts")
                                "application/x-www-form-urlencoded"
                                postParams
                            )
                    , logMsg =
                        "POST application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/accounts "
                            ++ postParams
                    }

                Edit ->
                    { title = tx model.language { e = "Edit Account", c = "编辑账户", p = "biānjí zhànghù" }
                    , onClick =
                        AccountMsgA
                            (PutAccount
                                (model.bservers.baseURL ++ "/accounts")
                                "application/x-www-form-urlencoded"
                                putParams
                            )
                    , logMsg =
                        "PUT application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/accounts "
                            ++ putParams
                    }
    in
    template model (leftContent r.logMsg model.language) (rightContent r.title r.onClick model)
