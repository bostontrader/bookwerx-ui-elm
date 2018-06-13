module View exposing (view)

import Html exposing (Html, h3, text)
--import Types exposing (Model, Msg, Post, PostId, Route(..))
import Types exposing (Model, Msg(..))
--import RemoteData exposing (WebData)
--import Views.List
--import Views.Edit
--import Views.New
--import Misc exposing (findPostById)


view : Model -> Html Msg
view model =
    h3 [] [ text "Hello World" ]
    --case model.currentRoute of
        --PostsRoute ->
            --Views.List.view model

        --PostRoute id ->
            --case findPostById id model.posts of
                --Just post ->
                    --Views.Edit.view post

                --Nothing ->
                    --notFoundView

        --NotFoundRoute ->
            --notFoundView

        --NewPostRoute ->
            --Views.New.view



--notFoundView : Html msg
--notFoundView =
    --h3 [] [ text "Oops! The page you requested was not found!" ]