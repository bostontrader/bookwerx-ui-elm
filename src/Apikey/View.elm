module Apikey.View exposing (view)

import Apikey.MsgB exposing (MsgB(..))
import Flash exposing (viewFlash)
import Html exposing (Html, button, div, h3, input, p, text)
import Html.Attributes exposing (class, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (tx)
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ p [ style "margin-top" "0.5em" ]
            [ text
                (tx model.language
                    { e = "The next step is to specify your API key"
                    , c = "下一步是指定API密钥。"
                    , p = "The next step is to specify your API key"
                    }
                )
            ]
        , p []
            [ text
                (tx model.language
                    { e = "Here you can enter whatever API key you already have, or request a new one."
                    , c = "您可以输入您已经拥有的任何API密钥，或者请求一个新的API密钥。"
                    , p = "Here you can enter whatever API key you already have, or request a new one."
                    }
                )
            ]
        , p []
            [ text
                (tx model.language
                    { e = "Please realize that if you lose your API key you lose all access to your data and that a new API key will only let you start over."
                    , c = "请注意，如果您丢失了API密钥，您就失去了对数据的所有访问权，而一个新的API密钥只会让您重新开始。"
                    , p = "Please realize that if you lose your API key you lose all access to your data and that a new API key will only let you start over."
                    }
                )
            ]
        , viewHttpPanel
            ("POST " ++ model.bservers.baseURL ++ "/apikeys")
            (getRemoteDataStatusMessage model.apikeys.wdApikey model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text
                (tx model.language
                    { e = "My API key"
                    , c = "我的API密匙"
                    , p = "My API key"
                    }
                )
            ]
        , viewFlash model.flashMessages
        , div [ class "control" ]
            [ input
                [ class "input"
                , type_ "text"
                , value model.apikeys.apikey
                , onInput (\newValue -> ApikeyMsgA (UpdateApikey newValue))
                ]
                []
            ]
        , div [ style "margin-top" "1.0em" ]
            [ button [ class "button is-link", onClick (ApikeyMsgA (Apikey.MsgB.PostApikey (model.bservers.baseURL ++ "/apikeys"))) ]
                [ text
                    (tx model.language
                        { e = "Request a new API key"
                        , c = "请求新的API密钥"
                        , p = "Request a new API key"
                        }
                    )
                ]
            ]
        ]
