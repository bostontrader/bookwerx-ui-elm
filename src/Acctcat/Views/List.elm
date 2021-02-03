module Acctcat.Views.List exposing (view)

import Account.Model
import Acctcat.Acctcat exposing (Acctcat, AcctcatJoined)
import Acctcat.Model
import Acctcat.MsgB exposing (MsgB(..))
import Category.Model
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Template exposing (template)
import Translate exposing (Language, tx, tx_delete)
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


getAccountCurrencySymbol : Account.Model.Model -> Int -> String
getAccountCurrencySymbol model aid =
    case List.head (List.filter (\c -> c.id == aid) model.accounts) of
        Just a ->
            a.currency.symbol

        Nothing ->
            "unknown"


getAccountTitle : Account.Model.Model -> Int -> String
getAccountTitle model aid =
    case List.head (List.filter (\c -> c.id == aid) model.accounts) of
        Just c ->
            c.title

        Nothing ->
            "unknown"


getCategoryTitle : Category.Model.Model -> Int -> String
getCategoryTitle model category_id =
    case List.head (List.filter (\c -> c.id == category_id) model.categories) of
        Just c ->
            c.title

        Nothing ->
            "unknown"


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ p [ style "margin-top" "0.5em" ] [ text "These are the accounts, if any, that are tagged with this category." ]
        , viewHttpPanel
            ("GET " ++ model.bservers.baseURL ++ "/acctcats/for_category?apikey=" ++ model.apikeys.apikey ++ "?category_id=" ++ String.fromInt model.acctcats.category_id)
            (getRemoteDataStatusMessage model.acctcats.wdAcctcats model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            --[ text (tx model.language {e = "Acctcats", c = "货币", p = "huòbì"}) ]
            [ text ("Accounts tagged as category " ++ getCategoryTitle model.categories model.acctcats.category_id) ]
        , viewFlash model.flashMessages
        , a [ href "/acctcats/add", class "button is-link" ]
            --[ text (tx model.language {e = "Create new acctcat", c = "创建新货币", p = "chuàngjiàn xīn huòbì"}) ]
            [ text "Tag another account with this category" ]
        , viewAcctcatsPanel model model.acctcats
        ]


view : Model.Model -> Html Msg
view model =
    template model (leftContent model) (rightContent model)


viewAcctcat : Model.Model -> AcctcatJoined -> Html Msg
viewAcctcat model acctcat =
    let
        acctcatPath =
            "/acctcats/" ++ String.fromInt acctcat.id

        --account_currency_id = getAccountCurrencyID model.accounts acctcat.account_id
    in
    tr []
        [ td [] [ text (String.fromInt acctcat.id) ]
        , td [] [ text acctcat.account_title ]
        , td [] [ text acctcat.currency_symbol ]

        -- All the buttons have this same id.  SHAME!  But the id is unique to a row.
        , td []
            [ button
                [ class "button is-link is-danger"
                , onClick
                    (AcctcatMsgA
                        (DeleteAcctcat
                            ((model.bservers.baseURL ++ "/acctcat/")
                                ++ String.fromInt acctcat.id
                                ++ "?apikey="
                                ++ model.apikeys.apikey
                            )
                        )
                    )
                ]
                [ model.language |> tx_delete |> text ]
            ]
        ]



--viewAcctcatsPanel : Model.Model -> Acctcat.Model.Model -> Html Msg
--viewAcctcatsPanel model acctcat_model =
--div [ class "box" ]
--[ if List.isEmpty acctcat_model.acctcats then
--div [ id "acctcats-index" ]
--[ h3 [ id "acctcats-empty" ] [ text "No acctcats present" ] ]
--else
--div [ id "acctcats-index", style [ ( "margin-top", "1.0em" ) ] ]
--[ viewAcctcatsTable model acctcat_model.acctcats
--]
--]


viewAcctcatsPanel : Model.Model -> Acctcat.Model.Model -> Html Msg
viewAcctcatsPanel model acctcat_model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ case model.acctcats.wdAcctcats of
            RemoteData.Success _ ->
                if List.isEmpty acctcat_model.acctcats then
                    h3 [] [ text "No acctcats present" ]

                else
                    viewAcctcatsTable model acctcat_model.acctcats

            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.acctcats.wdAcctcats model.language) ]
        ]


join : Model.Model -> Acctcat -> AcctcatJoined
join model a =
    { id = a.id
    , apikey = a.apikey
    , account_title = getAccountTitle model.accounts a.account_id
    , category_id = a.category_id
    , currency_symbol = getAccountCurrencySymbol model.accounts a.account_id
    }


viewAcctcatsTable : Model.Model -> List Acctcat -> Html Msg
viewAcctcatsTable model acctcats =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language ]
        , tbody [] (List.map (viewAcctcat model) (List.sortBy .account_title (List.map (join <| model) <| acctcats)))
        ]


viewTableHeader : Language -> Html Msg
viewTableHeader language =
    tr []
        [ th [] [ text (tx language { e = "ID", c = "号码", p = "hao ma" }) ]
        , th [] [ text "Account" ]
        , th [] [ text "" ] -- currency symbol associated with account
        , th [] [] -- extra header for delete
        ]



--getCurrencySymbol : Currency.Model.Model -> Int -> String
--getCurrencySymbol model cid =
--case List.head (List.filter (\c -> c.id == cid) model.currencies) of
--Just c ->
--c.symbol
--Nothing ->
--"unknown"
