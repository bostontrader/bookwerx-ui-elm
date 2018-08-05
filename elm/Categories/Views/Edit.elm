module Categories.Views.Edit exposing (view)

import Html exposing (Html, a, br, button, div, h3, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, id, type_, value)
import Html.Events exposing (onClick, onInput)
import RemoteData

import Template exposing (template)
import Types exposing
    ( BWCore_Error
    , Model
    , Msg(SubmitUpdatedCategory, UpdateCategoryTitle)
    , Category
    , CategoryPostHttpResponse(..)
    )

view : Model -> Html Msg
view model =
    template (div [ id "categories-edit"]
        [ h3 [ class "title is-3" ] [ text "Edit Category" ]
        , a [ id "categories-index", href "/ui/categories" ] [ text "Categories index" ]
        , viewCategoryOrError model
        ])


viewCategoryOrError : Model -> Html Msg
viewCategoryOrError model =
    case model.wdCategory of
        RemoteData.NotAsked ->
            h3 [] [ text "Not Asked..." ]

        RemoteData.Loading ->
            h3 [ class "loader" ] [ text "Loading..." ]

        RemoteData.Success aehr ->
            case aehr of
                ValidCategoryPostResponse wdCategory ->
                    editForm model.editCategory

                ErrorCategoryPostResponse errors ->
                    viewErrors errors

        RemoteData.Failure httpError ->
            h3 [] [ text "Category error..." ]

viewErrors : List BWCore_Error -> Html Msg
viewErrors errors =
    div [ id "errors"]
        [ h3 [] [ text "Errors" ]
        , table []
            [ thead [][viewTableHeader]
            , tbody [] (List.map viewError errors)
            ]
        ]

viewError : BWCore_Error -> Html Msg
viewError error =
    tr []
        [ td []
            [ text error.key ]
        , td []
            [ text error.value ]
        ]

viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "key" ]
        , th []
            [ text "value" ]
        ]

editForm : Category -> Html Msg
editForm category =
    Html.form []
        [ div []
            [ text "Title"
            , br [][]
            , input
                [ id "title", type_ "text"
                , value category.title
                , onInput (UpdateCategoryTitle)
                ]
                []
            ]
        , br [][]
        , div []
            [ button
                [ id "save"
                , onClick SubmitUpdatedCategory
                ]
                [ text "Submit" ]
            ]
        ]