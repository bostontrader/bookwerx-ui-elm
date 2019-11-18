module Template exposing (template)

import Html exposing (Html, a, div, nav, text)
import Html.Attributes exposing (class, href, style)
import Model
import Msg exposing (Msg(..))
import Route exposing (Route(..))
import Routing exposing (extractUrl)
import Translate exposing (Language(..), tx)


template : Model.Model -> Html Msg -> Html Msg -> Html Msg
template model leftContent mainContent =
    div []
        [ div [ class "logo", style "margin-left" "1.0em" ] []
        , nav [ class "navbar" ]
            [ div [ class "navbar-brand" ] [ div [ class "navbar-burger" ] [ text "BG" ] ]
            , div [ class "navbar-menu" ]
                [ a [ href "/", class "navbar-item button is-link", style "margin-left" "0.2em" ]
                    [ text (tx model.language { e = "Home", c = "首页", p = "shǒuyè" }) ]
                , a [ href (extractUrl BserversIndex), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ text "Bserver" ]
                , if model.tutorialLevel >= 1 then
                    a [ href (extractUrl ApikeysIndex), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ text (tx model.language { e = "API key", c = "密钥", p = "API key" }) ]

                  else
                    div [] []
                , if model.tutorialLevel >= 2 then
                    a [ href (extractUrl CurrenciesIndex), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ text (tx model.language { e = "Currencies", c = "货币", p = "huòbì" }) ]

                  else
                    div [] []
                , if model.tutorialLevel >= 3 then
                    a [ href (extractUrl AccountsIndex), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ text (tx model.language { e = "Accounts", c = "账户", p = "zhànghù" }) ]

                  else
                    div [] []
                , if model.tutorialLevel >= 4 then
                    a [ href (extractUrl CategoriesIndex), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ text (tx model.language { e = "Categories", c = "类别", p = "lèibié" }) ]

                  else
                    div [] []
                , if model.tutorialLevel >= 5 then
                    a [ href (extractUrl TransactionsIndex), class "navbar-item button is-link", style "margin-left" "0.2em" ]
                        [ tx model.language { e = "Transactions", c = "交易", p = "jiāoyì" } |> text
                        ]

                  else
                    div [] []
                , if model.tutorialLevel >= 6 then
                    a [ href (extractUrl Report), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ text "Report" ]

                  else
                    div [] []
                , if model.tutorialLevel >= 6 then
                    a [ href (extractUrl Lint), class "navbar-item button is-link", style "margin-left" "0.2em" ]
                        [ tx model.language { e = "Linter", c = "Linter", p = "Linter" } |> text
                        ]

                  else
                    div [] []
                , a [ href (extractUrl HttpLog), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ tx model.language { e = "HTTP Log", c = "HTTP的日志", p = "HTTP Log" } |> text ]
                , a [ href (extractUrl Settings), class "navbar-item button is-link", style "margin-left" "0.2em" ] [ tx model.language { e = "Settings", c = "设置", p = "shèzhì" } |> text ]
                ]
            ]
        , div [ class "columns" ]
            [ div [ class "column is-one-quarter" ]
                [ div [ class "box", style "margin-left" "1.0em", style "margin-top" "1.0em" ]
                    [ leftContent ]
                ]
            , div [ class "column" ]
                [ div [ class "box", style "margin-top" "1.0em", style "margin-right" "1.0em" ] [ mainContent ]
                ]
            ]

        --        , div [class "has-background-danger" ] [ text "footer" ]
        ]



--
--
--txTutorial : Model.Model -> String
--txTutorial model =
--    case model.language of
--        English ->
--            "Tutorial"
--
--        Chinese ->
--            "教程"
--
--        Pinyin ->
--            "jiào chéng"
--
--
--
----ifChinese : Model.Model -> Bool
----ifChinese model =
----True
----, p [] [ text ("Level " ++ toString model.tutorialLevel) ]
--
--
--txLevel : Model.Model -> String
--txLevel model =
--    case model.language of
--        English ->
--            "Level " ++ toString model.tutorialLevel
--
--        Chinese ->
--            toString model.tutorialLevel ++ "级别"
--
--        Pinyin ->
--            toString model.tutorialLevel ++ " jíbié"
--
--
