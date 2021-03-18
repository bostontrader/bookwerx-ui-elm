module Bserver.View exposing (view)

import Bserver.MsgB exposing (MsgB(..))
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
                    { e = "The first step is to figure out which bookwerx-core server to connect to and use."
                    , c = "第一步是确定要连接和使用哪个bookwerx核心服务器。"
                    , p = "The first step is to figure out which bookwerx-core server to connect to and use."
                    }
                )
            ]
        , p []
            [ text
                (tx model.language
                    { e = "You can use our public demonstration server or change that URL to another server that you might know about.  Either way you'll need to test the connection before you can proceed."
                    , c = "您可以使用我们的公共演示服务器，或者将URL更改为您可能知道的其他服务器。无论哪种方式，您都需要在继续之前测试连接。"
                    , p = "You can use our public demonstration server or change that URL to another server that you might know about.  Either way you'll need to test the connection before you can proceed."
                    }
                )
            ]
        , p []
            [ text
                (tx model.language
                    { e = "Please notice the HTTP Panel nearby.  It contains the actual HTTP request that this app will send to the server as well as any response"
                    , c = "请注意附近的HTTP面板。它包含这个应用程序将发送到服务器的实际HTTP请求以及任何响应。"
                    , p = "Please notice the HTTP Panel nearby.  It contains the actual HTTP request that this app will send to the server as well as any response"
                    }
                )
            ]

        , viewHttpPanel
            ("GET " ++ model.bservers.baseURL)
            (getRemoteDataStatusMessage model.bservers.wdBserver model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text
                (tx model.language
                    { e = "My bookwerx-core server"
                    , c = "我的bookwerx-core服务器"
                    , p = "My bookwerx-core server"
                    }
                )
            ]
        , viewFlash model.flashMessages
        , div [ class "control" ]
            [ input
                [ class "input"
                , type_ "text"
                , value model.bservers.baseURL
                , onInput (\newValue -> BserverMsgA (UpdateBserverURL newValue))
                ]
                []
            ]
        , div [ style "margin-top" "1.0em" ]
            [ button
                [ class "button is-link"
                , onClick (BserverMsgA (Bserver.MsgB.PingBserver model.bservers.baseURL))
                ]
                [ text (tx model.language { e = "Test connection", c = "测试连接", p = "Test connection" }) ]
            ]
        ]
