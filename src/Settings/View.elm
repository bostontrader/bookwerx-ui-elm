module Settings.View exposing (view)

import Html exposing (Html, div, h3, input, label, option, p, select, text)
import Html.Attributes exposing (checked, class, style, name, type_, value)
import Html.Events exposing (onInput)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (tx)
import Types exposing (DRCRFormat(..))


view : Model.Model -> Html Msg
view model =
    template model leftContent (rightContent model)


leftContent : Html Msg
leftContent =
    div []
        [ p [ style  "margin-top" "0.5em"  ] [ text "" ]
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div [ class "box", style "margin-left" "1.0em" , style "margin-top" "1.0em" ]
        [ h3 [ class "title is-3" ] [ tx model.language { e = "Settings", c = "设置", p = "shèzhì" } |> text ]
        , div [ class "select" ]
            [ select [ onInput SetLanguage ]
                 [ option [ value "english" ] [ text "English" ]
                 , option [ value "chinese" ] [ text "中文" ]
                 , option [ value "pinyin" ] [ text "pīnyīn" ]
                 ]
            ]

        , div [ class "control",  style  "margin-top" "1em"  ]
            [ label[ class "label"] [ text (tx model.language
                { e = "Debit/Credit display style"
                , c = "借方/贷方显示样式"
                , p = "jièfāng/dàifāng xiǎnshì yàngshì"
                })
                ]

            , p []
                [ label [ class "radio" ]
                    [ input
                        [ checked (model.drcr_format == DRCR)
                        , name "sof"
                        , onInput (\newValue -> SetDRCRFormat newValue)
                        , type_ "radio"
                        , value "drcr_conventional"
                        ]
                        []
                    , text (tx model.language {e = "Display DR and CR", c = "显示DR和CR", p = "xiǎnshì DR hé CR"})
                    ]
                ]
                , p[]
                [ label [ class "radio" ]
                    [ input
                        [ checked (model.drcr_format == PlusAndMinus)
                        , name "sof"
                        , onInput (\newValue -> SetDRCRFormat newValue)
                        , type_ "radio"
                        , value "drcr_pnm"
                        ]
                        []
                    , text (tx model.language {e = "Interpret positive numbers as DR and negative numbers as CR", c = "正数表示为DR，负数表示为CR", p = "zhèng shù biǎoshì wèi DR, fùshù biǎoshì wèi CR"})
                    ]
                ]
            ]
        ]


--viewLogEntries : List String -> List (Html Msg)
--viewLogEntries theLog =
    --case List.length theLog of
        --0 ->
            --[ p [] [] ]

        -- empty
        --1 ->
            --[ p [] [ text "case 1" ] ]

        -- can we every have a request w/o a response?
        --2 ->
            --[ div [ class "box has-background-grey-lighter", style [ ( "margin-top", "0.5em" ) ] ]
                --[ p [] [ text <| getMaybeString <| List.head <| theLog ]
                --, p [] [ text <| getMaybeString <| List.head <| List.reverse <| theLog ]
                --]
            --]

        --_ ->
            -- theLog _must have_ at least 2 items.
            --let
                --n2 =
                    --case List.tail theLog of
                        --Just n ->
                            --n

                        --Nothing ->
                            --[]

                --n4 =
                    --case List.tail n2 of
                        --Just n ->
                            --n

                        --Nothing ->
                            --[]
            --in
            --div [ class "box has-background-grey-lighter", style [ ( "margin-top", "0.5em" ) ] ]
                --[ p [] [ text <| getMaybeString <| List.head <| theLog ]
                --, p [] [ text <| getMaybeString <| List.head <| n2 ]
                --]
                --:: viewLogEntries n4


--getMaybeString : Maybe String -> String
--getMaybeString mbs =
    --case mbs of
        --Just s ->
            --s

        --Nothing ->
            --"no string value"
