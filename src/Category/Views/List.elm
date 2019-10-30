module Category.Views.List exposing (view)

import Category.Category exposing (Category)
import Category.MsgB exposing (MsgB(..))
import Category.Model
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Template exposing (template)
import Translate exposing (Language, tx, tx_accounts, tx_delete, tx_edit)
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ p [ style "margin-top" "0.5em" ]
            [ text
                (tx model.language
                    { e = "An account can be tagged with zero or more categories that are relevant for your use."
                    , c = "帐户可以标记为多个与您的使用相关的类别。"
                    , p = "An account can be tagged with zero or more categories that are relevant for your use."
                    }
                )
            ]
        , p []
            [ text
                (tx model.language
                    { e = "For example: An account may be an asset or an expense"
                    , c = "例如:资产和费用是可能的类别"
                    , p = "For example: An account may be an asset or an expense"
                    }
                )
            ]
        , p []
            [ text
                (tx model.language
                    { e = "Here you can define these categories."
                    , c = "这里可以定义这些类别。"
                    , p = "Here you can define these categories."
                    }
                )
            ]
        , viewHttpPanel
            ("GET " ++ model.bservers.baseURL ++ "/categories?apikey=" ++ model.apikeys.apikey)
            (getRemoteDataStatusMessage model.categories.wdCategories model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text (tx model.language { e = "Categories", c = "类别", p = "lèibié" }) ]
        , viewFlash model.flashMessages
        , a [href "/categories/add", class "button is-link" ]
            [ text (tx model.language { e = "Create new category", c = "创建新类别", p = "chuàngjiàn xīn lèibié" }) ]
        , viewCategoriesPanel model model.categories
        ]


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


viewCategoriesPanel : Model.Model -> Category.Model.Model -> Html Msg
viewCategoriesPanel model category_model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ case model.categories.wdCategories of
            RemoteData.Success s ->
                if List.isEmpty category_model.categories then
                    h3 [] [ text "No categories present" ]
                else
                    viewCategoriesTable model category_model.categories
            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.categories.wdCategories model.language) ]

        ]

viewCategoriesTable : Model.Model -> List Category -> Html Msg
viewCategoriesTable model categories =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language ]
        , --case model.categories.rarityFilter of
          --IntField Nothing r ->
          tbody [] (List.map (viewCategory model) categories)

        --IntField (Just r) _ ->
        --tbody [] (List.map (viewCategory model) (List.filter (\c -> c.rarity < r) categories))
        ]


viewCategory : Model.Model -> Category -> Html Msg
viewCategory model category =
    let
        categoryPath =
            "/categories/" ++ String.fromInt category.id
    in
    tr []
        [ td [] [ text (String.fromInt category.id) ]
        , td [] [ text category.symbol ]
        , td [] [ text category.title ]
        , td []
            [ a [href categoryPath, class "button is-link" ] [ model.language |> tx_edit |> text ] ]
        , td []
            [ a [href (categoryPath ++ "/accounts"), class "button is-link" ] [ model.language |> tx_accounts |> text ] ]

        , td []
            [ button
                [ class "button is-link is-danger"
                , onClick
                    (CategoryMsgA
                        (DeleteCategory
                            ((model.bservers.baseURL ++ "/category/")
                                ++ String.fromInt category.id
                                ++ "?apikey="
                                ++ model.apikeys.apikey
                            )
                        )
                    )
                ]
                [ model.language |> tx_delete |> text ]
            ]
        ]


viewTableHeader : Language -> Html Msg
viewTableHeader language =
    tr []
        [ th [] [ text (tx language { e = "ID", c = "号码", p = "hao ma" }) ]
        , th [] [ text (tx language { e = "Symbol", c = "标记", p = "biāojì" }) ]
        , th [] [ text (tx language { e = "Title", c = "标题", p = "biāotí" }) ]
        , th [] [] -- extra headers for edit, accounts, and delete
        , th [] []
        , th [] []
        ]
