module View exposing (view)

import Html exposing (Html, a, div, h3, nav, text)
import Html.Attributes exposing (class, href, id)
import Template exposing (template)

import Model exposing ( Model )
--import Types exposing (Msg(..), Route(..))
import Msg exposing ( Msg(..) )
import Route exposing (..)

import Account.Views.Add
import Account.Views.Edit
import Account.Views.List

import Category.Views.Add
import Category.Views.Edit
import Category.Views.List

import Currency.Views.Add
import Currency.Views.Edit
import Currency.Views.List

import Transaction.Views.Add
import Transaction.Views.Edit
import Transaction.Views.List

view : Model -> Html Msg
view model =
    let _ = Debug.log "View view " model.currentRoute
    in
    case model.currentRoute of
        Home ->
            template (div[][ text "Home Sweet Home" ])

        NotFound ->
            h3 [] [ text "Oops! The page you requested was not found!" ]

        -- Accounts
        AccountsAdd ->
            Account.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        AccountsEdit id ->
            Account.Views.Edit.view model

        AccountsIndex ->
            Account.Views.List.view model

        -- This route will be intercepted by the server and elm will never see it.
        --AccountsGetMany ->
        --    pageNotFound


        -- Categories
        CategoriesAdd ->
             Category.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        CategoriesEdit id ->
            --case model.pending of
                --True ->
                    --h3 [] [ text "Patch Pending" ]
                --False ->
                    Category.Views.Edit.view model

        -- This route will be intercepted by the server and elm will never see it.
        --CategoriesGetMany ->
        --    pageNotFound

        CategoriesIndex ->
            Category.Views.List.view model


        -- Currencies
        CurrenciesAdd ->
            Currency.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        CurrenciesEdit id ->
            Currency.Views.Edit.view model

        -- This route will be intercepted by the server and elm will never see it.
        --CurrenciesGetMany ->
        --    pageNotFound

        CurrenciesIndex ->
            Currency.Views.List.view model


        -- Transactions
        TransactionsAdd ->
            Transaction.Views.Add.view model

        -- This message provides a parameter, but we don't use it in the view.
        TransactionsEdit id ->
            Transaction.Views.Edit.view model
            --case Debug.log "View TransactionsEdit " model.pending of
            --    True ->
            --        h3 [] [ text "Patch Pending" ]
            --    False ->
            --        Transaction.Views.Edit.view model

        -- This route will be intercepted by the server and elm will never see it.
        --TransactionsGetMany ->
        --    pageNotFound

        TransactionsIndex ->
            Transaction.Views.List.view model


--pageNotFound: Html Msg
--pageNotFound = div[][ text "Page not found" ]
