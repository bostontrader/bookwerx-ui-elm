module Currency.Views.AddEdit exposing (view)

-- Add and Edit are very similar. Unify them thus...

import Currency.Currency exposing (Currency)
import Currency.MsgB exposing( MsgB(..))
import Html exposing (Html, a, button, div, h3, input, label, text)
import Html.Attributes exposing (class, href, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)
import IntField exposing (IntField(..), intFieldToString, intValidationClass)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx, tx_save)
import Types exposing (AEMode(..))
import ViewHelpers exposing (viewHttpPanel)
import Flash exposing (viewFlash)

addeditForm : Language -> Currency -> Html Msg
addeditForm language editBuffer =
    div [ class "box" ]
        [ div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Symbol", c = "标记", p = "biāojì" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , value editBuffer.symbol
                    , onInput (\newValue -> CurrencyMsgA (UpdateSymbol newValue))
                    ]
                    []
                ]
            ]
        , div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Title", c = "标题", p = "biāotí" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , value editBuffer.title
                    , onInput (\newValue -> CurrencyMsgA (UpdateTitle newValue))
                    ]
                    []
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
                    , onInput (\newValue -> CurrencyMsgA (UpdateRarity newValue))
                    , value (intFieldToString editBuffer.rarity)
                    ]
                    []
                ]
            ]
        ]


leftContent : String -> Language -> Html Msg
leftContent logMsg language =
    div []
        [ viewHttpPanel logMsg "" language ]


rightContent : String -> String -> Msg -> Model.Model -> Html Msg
rightContent r_id r_title r_onclick model =
    div [ ]
        [ h3 [ class "title is-3" ] [ text r_title ]
        , viewFlash model.flashMessages
        , a [ href "/currencies" ]
            [ text (tx model.language { e = "Currencies Index", c = "返回货币目录", p = "fanhui huòbì mulu" })]

        , addeditForm model.language model.currencies.editBuffer
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
                ++ "&rarity="
                ++ intFieldToString model.currencies.editBuffer.rarity
                ++ "&symbol="
                ++ model.currencies.editBuffer.symbol
                ++ "&title="
                ++ model.currencies.editBuffer.title

        putParams =
            postParams
                ++ "&id="
                ++ String.fromInt model.currencies.editBuffer.id

        r =
            case aemode of
                Add ->
                    { id = "currencies-add"
                    , title = tx model.language { e = "Create new currency", c = "创建新货币", p = "chuàngjiàn xīn huòbì" }

                    , onClick =
                        CurrencyMsgA
                            (PostCurrency
                                (model.bservers.baseURL ++ "/currencies")
                                "application/x-www-form-urlencoded"
                                postParams
                            )
                    , logMsg =
                        "POST application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/currencies "
                            ++ postParams
                    }

                Edit ->
                    { id = "currencies-edit"
                    , title = tx model.language { e = "Edit Currency", c = "编辑货币", p = "biānjí huòbì" }
                    , onClick =
                        CurrencyMsgA
                            (PutCurrency
                                (model.bservers.baseURL ++ "/currencies")
                                "application/x-www-form-urlencoded"
                                putParams
                            )
                    , logMsg =
                        "PUT application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/currencies "
                            ++ putParams
                    }
    in
    template model (leftContent r.logMsg model.language) (rightContent r.id r.title r.onClick model)
