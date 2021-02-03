module Currency.Views.List exposing (view)

import Currency.Currency exposing (Currency)
import Currency.Model
import Currency.MsgB exposing (MsgB(..))
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, input, label, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)
import IntField exposing (IntField(..), intFieldToInt, intFieldToString, intValidationClass)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Template exposing (template)
import Translate exposing (Language, tx, tx_delete, tx_edit)
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ div [ class "box", style "margin-top" "0.5em" ]
            [ p [ style "margin-top" "0.5em" ]
                [ text
                    (tx model.language
                        { e = "Now it's time to define the currencies that are relevant for your use."
                        , c = "定义与您的使用相关的货币。"
                        , p = "Now it's time to define the currencies that are relevant for your use."
                        }
                    )
                ]
            , p []
                [ text
                    (tx model.language
                        { e = "You must define at least a single currency but you may define as many currencies as you wish."
                        , c = "您必须定义至少一种货币，也可以定义多种的货币。"
                        , p = "You must define at least a single currency but you may define as many currencies as you wish."
                        }
                    )
                ]
            ]
        , viewHttpPanel
            ("GET " ++ model.bservers.baseURL ++ "/currencies?apikey=" ++ model.apikeys.apikey)
            (getRemoteDataStatusMessage model.currencies.wdCurrencies model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text (tx model.language { e = "Currencies", c = "货币", p = "huòbì" }) ]
        , viewFlash model.flashMessages
        , a [ href "/currencies/add", class "button is-link" ]
            [ text (tx model.language { e = "Create new currency", c = "创建新货币", p = "chuàngjiàn xīn huòbì" }) ]
        , viewCurrenciesPanel model model.currencies
        ]


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


viewCurrenciesPanel : Model.Model -> Currency.Model.Model -> Html Msg
viewCurrenciesPanel model currency_model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ case model.currencies.wdCurrencies of
            RemoteData.Success _ ->
                if List.isEmpty currency_model.currencies then
                    h3 [] [ text "No currencies present" ]

                else
                    div []
                        [ viewCurrenciesTable model currency_model.currencies ]

            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.currencies.wdCurrencies model.language) ]
        ]


viewCurrenciesTable : Model.Model -> List Currency -> Html Msg
viewCurrenciesTable model currencies =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language ]
        , tbody [] (List.map (viewCurrency model) (List.sortBy .symbol currencies))
        ]


viewCurrency : Model.Model -> Currency -> Html Msg
viewCurrency model currency =
    let
        currencyPath =
            "/currencies/" ++ String.fromInt currency.id
    in
    tr []
        [ td [] [ text (String.fromInt currency.id) ]
        , td [] [ text currency.symbol ]
        , td [] [ text currency.title ]
        , td []
            [ a [ href currencyPath, class "button is-link" ] [ model.language |> tx_edit |> text ] ]
        , td []
            [ button
                [ class "button is-link is-danger"
                , onClick
                    (CurrencyMsgA
                        (DeleteCurrency
                            ((model.bservers.baseURL ++ "/currency/")
                                ++ String.fromInt currency.id
                                ++ "?apikey="
                                ++ model.apikeys.apikey
                            )
                        )
                    )
                ]
                [ model.language |> tx_delete |> text ]
            ]
        ]


viewTableHeader : Language -> Html Msg
viewTableHeader language =
    tr []
        [ th [] [ text (tx language { e = "ID", c = "号码", p = "hao ma" }) ]
        , th [] [ text (tx language { e = "Symbol", c = "标记", p = "biāojì" }) ]
        , th [] [ text (tx language { e = "Title", c = "标题", p = "biāotí" }) ]
        , th [] [] -- extra headers for edit and delete
        , th [] []
        ]
