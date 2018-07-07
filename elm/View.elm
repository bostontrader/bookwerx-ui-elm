module View exposing (view)

import Html exposing (Html, h3, text)
import Types exposing (Model, Msg(..), Route(..))

import Accounts.Views.Add
import Accounts.Views.Edit
import Accounts.Views.List

import Currencies.Views.Add
import Currencies.Views.Edit
import Currencies.Views.List

import Transactions.Views.Add
import Transactions.Views.Edit
import Transactions.Views.List

view : Model -> Html Msg
view model =
    case model.currentRoute of
        Home ->
            h3 [] [ text "Home sweet home" ]

        NotFound ->
            h3 [] [ text "Oops! The page you requested was not found!" ]
            

        -- Accounts
        AccountsIndex ->
            Accounts.Views.List.view model

        -- This message provides a parameter, but we don't use it in the view.
        AccountsEdit id ->
            Accounts.Views.Edit.view model

        AccountsAdd ->
            Accounts.Views.Add.view model


        -- Currencies
        CurrenciesIndex ->
            Currencies.Views.List.view model

        -- This message provides a parameter, but we don't use it in the view.
        CurrenciesEdit id ->
            Currencies.Views.Edit.view model

        CurrenciesAdd ->
            Currencies.Views.Add.view model

        -- Transactions
        TransactionsIndex ->
            Transactions.Views.List.view model

        -- This message provides a parameter, but we don't use it in the view.
        TransactionsEdit id ->
            Transactions.Views.Edit.view model

        TransactionsAdd ->
            Transactions.Views.Add.view model