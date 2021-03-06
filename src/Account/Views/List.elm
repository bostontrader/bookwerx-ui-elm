module Account.Views.List exposing (view)

import Account.Account exposing (AccountJoined)
import Account.Model
import Account.MsgB exposing (MsgB(..))
import Category.Category exposing (CategoryShort)
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, li, p, table, tbody, td, text, th, thead, tr, ul)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Template exposing (template)
import Translate exposing (Language, tx, tx_delete, tx_edit)
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ div [ class "box", style "margin-top" "0.5em" ]
            [ p [ style "margin-top" "0.5em" ]
                --[ text "Now it's time to define the accounts that are relevant for your use. You must define at least a single account but you're free to define as many accounts as you wish." ]
                [ text
                    (tx model.language
                        { e = "Now it's time to define the accounts that are relevant for your use."
                        , c = "定义与您的使用相关的账户。"
                        , p = "Now it's time to define the accounts that are relevant for your use."
                        }
                    )
                ]
            , p []
                [ text
                    (tx model.language
                        { e = "You must define at least a single account but you may define as many accounts as you wish."
                        , c = "您必须定义至少一种账户，也可以定义多种的账户。"
                        , p = "You must define at least a single account but you may define as many accounts as you wish."
                        }
                    )
                ]
            ]
        , viewHttpPanel
            ("GET " ++ model.bservers.baseURL ++ "/accounts?apikey=" ++ model.apikeys.apikey)
            (getRemoteDataStatusMessage model.accounts.wdAccounts model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text (tx model.language { e = "Accounts", c = "账户", p = "zhànghù" }) ]
        , viewFlash model.flashMessages
        , a [ href "/accounts/add", class "button is-link" ]
            [ text (tx model.language { e = "Create new account", c = "创建新账户", p = "chuàngjiàn xīn zhànghù" }) ]
        , viewAccountsPanel model model.accounts
        ]


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


viewAccount : Model.Model -> AccountJoined -> Html Msg
viewAccount model account =
    let
        accountPath =
            "/accounts/" ++ String.fromInt account.id
    in
    tr []
        [ td [] [ text (String.fromInt account.id) ]
        , td [] [ text account.title ]
        , td [] [ text account.currency.symbol ]
        , td [] [ viewCategories <| account.categories ]
        , td []
            [ a [ href (accountPath ++ "/transactions"), class "button is-link" ]
                [ text (tx model.language { e = "Transactions", c = "交易", p = "jiāoyì" }) ]
            ]
        , td []
            [ a [ href accountPath, class "button is-link" ] [ model.language |> tx_edit |> text ] ]
        , td []
            [ button
                [ class "button is-link is-danger"
                , onClick
                    (AccountMsgA
                        (DeleteAccount
                            ((model.bservers.baseURL ++ "/account/")
                                ++ String.fromInt account.id
                                ++ "?apikey="
                                ++ model.apikeys.apikey
                            )
                        )
                    )
                ]
                [ model.language |> tx_delete |> text ]
            ]
        ]


viewAccountsPanel : Model.Model -> Account.Model.Model -> Html Msg
viewAccountsPanel model account_model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ case model.accounts.wdAccounts of
            RemoteData.Success _ ->
                if List.isEmpty account_model.accounts then
                    h3 [] [ text "No accounts present" ]

                else
                    div []
                        [ viewAccountsTable model account_model.accounts ]

            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.accounts.wdAccounts model.language) ]
        ]


viewAccountsTable : Model.Model -> List AccountJoined -> Html Msg
viewAccountsTable model accounts =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language ]
        , tbody [] (List.map (viewAccount model) (List.sortBy .title accounts))
        ]


viewCategories : List CategoryShort -> Html Msg
viewCategories categories =
    ul [] (List.map (\c -> li [] [ text (" " ++ c.category_symbol) ]) categories)


viewTableHeader : Language -> Html Msg
viewTableHeader language =
    tr []
        [ th [] [ text (tx language { e = "ID", c = "号码", p = "hao ma" }) ]
        , th [] [ text (tx language { e = "Title", c = "标题", p = "biāotí" }) ]
        , th [] [ text (tx language { e = "Currency", c = "货币", p = "huòbì" }) ]
        , th [] [ text (tx language { e = "Categories", c = "类别", p = "lèibié" }) ]
        , th [] [] -- extra headers for view, edit, and delete
        , th [] []
        , th [] []
        ]
