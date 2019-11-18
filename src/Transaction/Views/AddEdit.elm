module Transaction.Views.AddEdit exposing (view)

-- Add and Edit are very similar. Unify them thus...

import Distribution.Views.List as DVL
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, input, label, text)
import Html.Attributes exposing (class, href, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model
import Msg exposing (Msg(..))
import Route exposing (Route(..))
import Routing exposing (extractUrl)
import Template exposing (template)
import Transaction.MsgB exposing (MsgB(..))
import Transaction.Transaction exposing (Transaction)
import Translate exposing (Language, tx, tx_save)
import Types exposing (AEMode(..))
import ViewHelpers exposing (viewHttpPanel)


addeditForm : Language -> Transaction -> Html Msg
addeditForm language editBuffer =
    div [ class "box" ]
        [ div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Time", c = "时间", p = "shijian" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , value editBuffer.time
                    , onInput (\newValue -> TransactionMsgA (UpdateTime newValue))
                    ]
                    []
                ]
            ]
        , div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Notes", c = "注解", p = "zhujie" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "textarea"
                    , value editBuffer.notes
                    , onInput (\newValue -> TransactionMsgA (UpdateNotes newValue))
                    ]
                    []
                ]
            ]
        ]


leftContent : String -> Language -> Html Msg
leftContent logMsg language =
    div []
        [ viewHttpPanel logMsg "" language ]


rightContent : String -> String -> Msg -> Bool -> Model.Model -> Html Msg
rightContent r_id r_title r_onclick r_distribution_button model =
    div []
        [ h3 [ class "title is-3" ] [ text r_title ]
        , viewFlash model.flashMessages
        , a [ href "/transactions", class "button is-link" ]
            [ text (tx model.language { e = "Transactions Index", c = "返回交易目录", p = "fanhui jiāoyì mulu" }) ]
        , if r_distribution_button then
            a [ href (extractUrl DistributionsIndex), class "button is-link", style "margin-left" "0.5em" ] [ text "Distributions" ]

          else
            div [] []
        , addeditForm model.language model.transactions.editBuffer
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
                ++ "&notes="
                ++ model.transactions.editBuffer.notes
                ++ "&time="
                ++ model.transactions.editBuffer.time

        putParams =
            "apikey="
                ++ model.apikeys.apikey
                ++ "&id="
                ++ String.fromInt model.transactions.editBuffer.id
                ++ "&notes="
                ++ model.transactions.editBuffer.notes
                ++ "&time="
                ++ model.transactions.editBuffer.time

        r =
            case aemode of
                Add ->
                    { id = "transactions-add"
                    , title = tx model.language { e = "Create new transaction", c = "创建新交易", p = "chuàngjiàn xīn jiāoyì" }
                    , onClick =
                        TransactionMsgA
                            (PostTransaction
                                (model.bservers.baseURL ++ "/transactions")
                                "application/x-www-form-urlencoded"
                                postParams
                            )
                    , logMsg =
                        "POST application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/transactions "
                            ++ postParams
                    , distributionButton = False
                    }

                Edit ->
                    { id = "transactions-edit"
                    , title = tx model.language { e = "Edit Transaction", c = "编辑交易", p = "biānjí jiāoyì" }
                    , onClick =
                        TransactionMsgA
                            (PutTransaction
                                (model.bservers.baseURL ++ "/transactions")
                                "application/x-www-form-urlencoded"
                                putParams
                            )
                    , logMsg =
                        "PUT application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/transactions "
                            ++ putParams
                    , distributionButton = True
                    }
    in
    template model (leftContent r.logMsg model.language) (rightContent r.id r.title r.onClick r.distributionButton model)
