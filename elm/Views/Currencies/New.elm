module Views.Currencies.New exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)


view : Html Msg
view =
    div []
        [ a [ href "/currencies" ] [ text "Back" ]
        , h3 [] [ text "Create New Currency" ]
        , newCurrencyForm
        ]


newCurrencyForm : Html Msg
newCurrencyForm =
    Html.form []
        [ div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , onInput NewCurrencyTitle
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Name"
            , br [] []
            , input
                [ type_ "text"
                , onInput NewAuthorName
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author URL"
            , br [] []
            , input
                [ type_ "text"
                , onInput NewAuthorUrl
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ onClick CreateNewCurrency ]
                [ text "Submit" ]
            ]
        ]