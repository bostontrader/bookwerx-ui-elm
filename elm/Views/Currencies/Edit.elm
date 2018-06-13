module Views.Currencies.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, text)
import Html.Attributes exposing (type_, href, value)
import Html.Events exposing (onClick, onInput)
import Types exposing (Currency, Msg(..))


view : Currency -> Html Msg
view currency =
    div []
        [ a [ href "/currencies" ] [ text "Back" ]
        , h3 [] [ text "Edit Currency" ]
        , editForm currency
        ]


editForm : Currency -> Html Msg
editForm currency =
    Html.form []
        [ div []
            [ text "Title"
            , br [] []
            , input
                [ type_ "text"
                , value currency.title
                , onInput (UpdateTitle currency.id)
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author Name"
            , br [] []
            , input
                [ type_ "text"
                , value currency.author.name
                , onInput (UpdateAuthorName currency.id)
                ]
                []
            ]
        , br [] []
        , div []
            [ text "Author URL"
            , br [] []
            , input
                [ type_ "text"
                , value currency.author.url
                , onInput (UpdateAuthorUrl currency.id)
                ]
                []
            ]
        , br [] []
        , div []
            [ button [ onClick (SubmitUpdatedCurrency currency.id) ]
                [ text "Submit" ]
            ]
        ]