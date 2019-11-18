module Lint.View exposing (view)

import Flash exposing (FlashMsg, viewFlash)
import Html exposing (Html, button, div, h3, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Lint.Lint exposing (Lint)
import Lint.MsgB exposing (..)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Template exposing (template)
import Translate exposing (Language, tx)
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


getURL : String -> Model.Model -> String
getURL linter model =
    model.bservers.baseURL
        ++ "/linter/"
        ++ linter
        ++ "?apikey="
        ++ model.apikeys.apikey


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ p [ style "margin-top" "0.5em" ]
            [ text
                (tx model.language
                    { e = "This is the linter."
                    , c = "This is the linter."
                    , p = "This is the linter."
                    }
                )
            ]
        , viewHttpPanel
            (getURL model.lint.linter model)
            (getRemoteDataStatusMessage model.lint.wdLints model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text
                (tx model.language
                    { e = "The Linters"
                    , c = "The Linters"
                    , p = "The Linters"
                    }
                )
            ]
        , viewFlash model.flashMessages
        , button
            [ class "button is-link"
            , onClick <| LintMsgA <| GetLintCategories <| getURL "categories" <| model
            ]
            [ text (tx model.language { e = "Unused categories", c = "Unused categories", p = "Unused categories" }) ]
        , button
            [ class "button is-link"
            , onClick <| LintMsgA <| GetLintCurrencies <| getURL "currencies" <| model
            , style "margin-left" "0.2em"
            ]
            [ text (tx model.language { e = "Unused currencies", c = "Unused currencies", p = "Unused currencies" }) ]
        , viewReport model
        ]


viewLint : Model.Model -> Lint -> Html Msg
viewLint model lint =
    tr []
        [ td [] [ text (String.fromInt lint.id) ]
        , td [] [ text lint.symbol ]
        , td [] [ text lint.title ]
        ]


viewReport : Model.Model -> Html Msg
viewReport model =
    --div [ class "box", style [ ( "margin-top", "1.0em" ) ] ]
    --[
    case model.lint.wdLints of
        RemoteData.Success _ ->
            if List.isEmpty model.lint.lints then
                h3 [] [ text "No data found for this report." ]

            else
                table [ class "table is-striped" ]
                    [ thead []
                        [ th [] [ text "account_id" ]
                        , th [] [ text "symbol" ]
                        , th [] [ text "title" ]
                        ]
                    , tbody [] (List.map (viewLint model) model.lint.lints)
                    ]

        _ ->
            h3 [] [ text (getRemoteDataStatusMessage model.lint.wdLints model.language) ]



--]


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)
