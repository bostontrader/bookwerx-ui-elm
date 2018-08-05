module View exposing (view)

import Html exposing (Html, a, div, h3, nav, text)
import Html.Attributes exposing (class, href, id)
import Template exposing (template)
import Types exposing (Model, Msg(..), Route(..))

import Accounts.Views.Add
import Accounts.Views.Edit
import Accounts.Views.List

import Categories.Views.Add
import Categories.Views.Edit
import Categories.Views.List

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
            template (div[][ text "Home Sweet Home" ])

        NotFound ->
            h3 [] [ text "Oops! The page you requested was not found!" ]

        -- Accounts
        AccountsAdd ->
            Accounts.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        AccountsEdit id ->
            Accounts.Views.Edit.view model

        AccountsIndex ->
            Accounts.Views.List.view model

        -- This route will be intercepted by the server and elm will never see it.
        --AccountsGetMany ->
        --    pageNotFound


        -- Categories
        CategoriesAdd ->
             Categories.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        CategoriesEdit id ->
            Categories.Views.Edit.view model

        -- This route will be intercepted by the server and elm will never see it.
        --CategoriesGetMany ->
        --    pageNotFound

        CategoriesIndex ->
            Categories.Views.List.view model


        -- Currencies
        CurrenciesAdd ->
            Currencies.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        CurrenciesEdit id ->
            Currencies.Views.Edit.view model

        -- This route will be intercepted by the server and elm will never see it.
        --CurrenciesGetMany ->
        --    pageNotFound

        CurrenciesIndex ->
            Currencies.Views.List.view model


        -- Transactions
        TransactionsAdd ->
            Transactions.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        TransactionsEdit id ->
            Transactions.Views.Edit.view model

        -- This route will be intercepted by the server and elm will never see it.
        --TransactionsGetMany ->
        --    pageNotFound

        TransactionsIndex ->
            Transactions.Views.List.view model


--pageNotFound: Html Msg
--pageNotFound = div[][ text "Page not found" ]
