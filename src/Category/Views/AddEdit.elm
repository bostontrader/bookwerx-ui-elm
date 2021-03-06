module Category.Views.AddEdit exposing (view)

-- Add and Edit are very similar. Unify them thus...

import Account.Model
import Category.Category exposing (Category)
import Category.MsgB exposing (MsgB(..))
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, input, label, option, text)
import Html.Attributes exposing (class, href, selected, type_, value)
import Html.Events exposing (onClick, onInput)
import Model
import Msg exposing (Msg(..))
import Template exposing (template)
import Translate exposing (Language, tx, tx_save)
import Types exposing (AEMode(..))
import ViewHelpers exposing (viewHttpPanel)


addeditForm : Language -> Category -> List (Html Msg) -> Html Msg
addeditForm language editBuffer _ =
    div [ class "box" ]
        [ div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Symbol", c = "标记", p = "biāojì" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , value editBuffer.symbol
                    , onInput (\newValue -> CategoryMsgA (UpdateSymbol newValue))
                    ]
                    []
                ]
            ]
        , div [ class "field" ]
            [ label [ class "label" ] [ text (tx language { e = "Title", c = "标题", p = "biāotí" }) ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , value editBuffer.title
                    , onInput (\newValue -> CategoryMsgA (UpdateTitle newValue))
                    ]
                    []
                ]
            ]

        --, div [ class "field" ]
        --[ label [ class "label" ] [ text "Accounts" ]
        --, div [ class "control" ]
        --[ div [ class "select" ]
        --[ select [ multiple True ]
        --[ onInput (\newValue -> AccountMsgA (UpdateCurrencyID newValue)) ]
        --accountSelectOptions
        --]
        --]
        --]
        ]


buildAccountSelect : Account.Model.Model -> List Int -> List (Html msg)
buildAccountSelect model selected_ids =
    List.append [ option [ value "-1" ] [ text "None Selected" ] ]
        --(List.map (\a -> option [ value (toString a.id), selected (a.id == selected_id) ] [ text a.title ]) (List.sortBy .title model.accounts))
        (List.map (\a -> option [ value (String.fromInt a.id), selected (List.member a.id selected_ids) ] [ text a.title ]) (List.sortBy .title model.accounts))


leftContent : String -> Language -> Html Msg
leftContent logMsg language =
    div []
        [ viewHttpPanel logMsg "" language ]


rightContent : String -> String -> Msg -> Model.Model -> Html Msg
rightContent _ r_title r_onclick model =
    div []
        [ h3 [ class "title is-3" ] [ text r_title ]
        , viewFlash model.flashMessages
        , a [ href "/categories" ]
            [ text (tx model.language { e = "Accounts Index", c = "返回类别目录", p = "fanhui lèibié mulu" }) ]
        , addeditForm model.language model.categories.editBuffer (buildAccountSelect model.accounts [ 274, 257 ])
        , div []
            [ button
                [ class "button is-link"
                , onClick r_onclick
                ]
                [ model.language |> tx_save |> text ]
            ]

        --, viewRESTPanel r.logMsg
        ]


view : Model.Model -> AEMode -> Html Msg
view model aemode =
    let
        postParams =
            "apikey="
                ++ model.apikeys.apikey
                ++ "&symbol="
                ++ model.categories.editBuffer.symbol
                ++ "&title="
                ++ model.categories.editBuffer.title

        putParams =
            postParams
                ++ "&id="
                ++ String.fromInt model.categories.editBuffer.id

        r =
            case aemode of
                Add ->
                    { id = "categories-add"
                    , title = tx model.language { e = "Create new category", c = "创建新类别", p = "chuàngjiàn xīn lèibié" }
                    , onClick =
                        CategoryMsgA
                            (PostCategory
                                (model.bservers.baseURL ++ "/categories")
                                "application/x-www-form-urlencoded"
                                postParams
                            )
                    , logMsg =
                        "POST application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/categories "
                            ++ postParams
                    }

                Edit ->
                    { id = "categories-edit"
                    , title = tx model.language { e = "Edit Category", c = "编辑类别", p = "biānjí lèibié" }
                    , onClick =
                        CategoryMsgA
                            (PutCategory
                                (model.bservers.baseURL ++ "/categories")
                                "application/x-www-form-urlencoded"
                                putParams
                            )
                    , logMsg =
                        "PUT application/x-www-form-urlencoded "
                            ++ model.bservers.baseURL
                            ++ "/categories "
                            ++ putParams
                    }
    in
    template model (leftContent r.logMsg model.language) (rightContent r.id r.title r.onClick model)



--viewRESTPanel : String -> Html Msg
--viewRESTPanel s =
--div [ class "box" ]
--[ div [ class "control" ]
--[ input
--[ class "input"
--, type_ "text"
--, value s
--]
--[]
--]
--]
