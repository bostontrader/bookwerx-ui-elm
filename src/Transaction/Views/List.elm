module Transaction.Views.List exposing (view)

--import Util exposing (getCurrencyTitle, )

import Currency.Model exposing (Model)
import Flash exposing (viewFlash)
import Html exposing (Html, a, button, div, h3, p, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick)
import Model
import Msg exposing (Msg(..))
import RemoteData
import Template exposing (template)
import Transaction.Model
import Transaction.MsgB exposing (MsgB(..))
import Transaction.Transaction exposing (Transaction)
import Translate exposing (Language, tx, tx_delete, tx_edit)
import Util exposing (getRemoteDataStatusMessage)
import ViewHelpers exposing (viewHttpPanel)


leftContent : Model.Model -> Html Msg
leftContent model =
    div []
        [ p []
            [ text
                (tx model.language
                    { e = "Add new transactions here. You must create the transaction first and then later edit it to add/edit/delete the transaction's distributions (the DR and CR information.)"
                    , c = "Add new transactions here. You must create the transaction first and then later edit it to add/edit/delete the transaction's distributions (the DR and CR information.)"
                    , p = "Add new transactions here. You must create the transaction first and then later edit it to add/edit/delete the transaction's distributions (the DR and CR information.)"
                    }
                )
            ]
        , viewHttpPanel
            ("GET " ++ model.bservers.baseURL ++ "/transactions?apikey=" ++ model.apikeys.apikey)
            (getRemoteDataStatusMessage model.transactions.wdTransactions model.language)
            model.language
        ]


rightContent : Model.Model -> Html Msg
rightContent model =
    div []
        [ h3 [ class "title is-3" ]
            [ text (tx model.language { e = "Transactions", c = "交易", p = "jiāoyì" }) ]
        , viewFlash model.flashMessages
        , a [ href "/transactions/add", class "button is-link" ]
            [ text (tx model.language { e = "Create new transaction", c = "创建新交易", p = "chuàngjiàn xīn jiāoyì" }) ]
        , viewTransactionsPanel model model.transactions

        --, viewRESTPanel model
        ]


view : Model.Model -> Html Msg
view model =
    template model
        (leftContent model)
        (rightContent model)


viewTableHeader : Language -> Html Msg
viewTableHeader language =
    tr []
        [ th [] [ text (tx language { e = "ID", c = "号码", p = "hao ma" }) ]
        , th [] [ text (tx language { e = "Time", c = "时间", p = "shijian" }) ]
        , th [] [ text (tx language { e = "Notes", c = "注解", p = "zhujie" }) ]
        , th [] [] -- extra headers for edit, distributions, and delete
        , th [] []
        , th [] []
        ]


viewTransaction : Model.Model -> Transaction -> Html Msg
viewTransaction model transaction =
    let
        transactionPath =
            "/transactions/" ++ String.fromInt transaction.id
    in
    tr []
        [ td [] [ text (String.fromInt transaction.id) ]
        , td [] [ text transaction.time ]
        , td [] [ text transaction.notes ]
        , td []
            [ a [ href transactionPath, class "button is-link" ] [ model.language |> tx_edit |> text ] ]

        --, td []
        --[ a [href (extractUrl DistributionsIndex), class "button is-link" ]
        --[ text (tx model.language { e = "Distributions", c = "Distributions", p = "Distributions" }) ]
        --]
        , td []
            [ button
                [ class "button is-link is-danger"
                , onClick
                    (TransactionMsgA
                        (DeleteTransaction
                            ((model.bservers.baseURL ++ "/transaction/")
                                ++ String.fromInt transaction.id
                                ++ "?apikey="
                                ++ model.apikeys.apikey
                            )
                        )
                    )
                ]
                [ model.language |> tx_delete |> text ]
            ]
        ]



--viewTransactionsPanel : Model.Model -> Transaction.Model.Model -> Html Msg
--viewTransactionsPanel model transaction_model =
--div [ class "box" ]
--[ if List.isEmpty transaction_model.transactions then
--div [ id "transactions-index" ]
--[ h3 [ id "transactions-empty" ] [ text "No transactions present" ] ]
--else
--div [ id "transactions-index", style [ ( "margin-top", "1.0em" ) ] ]
--(viewTransactionsTable model transaction_model.transactions)
--]


viewTransactionsPanel : Model.Model -> Transaction.Model.Model -> Html Msg
viewTransactionsPanel model transaction_model =
    div [ class "box", style "margin-top" "1.0em" ]
        [ case model.transactions.wdTransactions of
            RemoteData.Success _ ->
                if List.isEmpty transaction_model.transactions then
                    h3 [] [ text "No transactions present" ]

                else
                    viewTransactionsTable model transaction_model.transactions

            _ ->
                h3 [] [ text (getRemoteDataStatusMessage model.transactions.wdTransactions model.language) ]
        ]


viewTransactionsTable : Model.Model -> List Transaction -> Html Msg
viewTransactionsTable model transactions =
    table [ class "table is-striped" ]
        [ thead [] [ viewTableHeader model.language ]
        , tbody [] (List.map (viewTransaction model) (List.reverse (List.sortBy .id transactions)))
        ]
