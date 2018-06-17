module View exposing (view)

import Html exposing (Html, h3, text)
--import Types exposing (Model, Msg, Post, PostId, Route(..))
import Types exposing (Model, Msg(..), Route(..))
--import RemoteData exposing (WebData)
import Views.Currencies.List
--import Views.Edit
import Views.Currencies.Add
--import Misc exposing (findPostById)

view : Model -> Html Msg
view model =
    case model.currentRoute of
        CurrenciesIndex ->
            Views.Currencies.List.view model

        CurrenciesEdit id ->
            h3 [] [ text "Currencies edit" ]

            --case findPostById id model.posts of
                --Just post ->
                    --Views.Edit.view post

                --Nothing ->
                    --notFoundView

        Home ->
            h3 [] [ text "Home sweet home" ]

        NotFound ->
            h3 [] [ text "Oops! The page you requested was not found!" ]

        CurrenciesAdd ->
            Views.Currencies.Add.view
