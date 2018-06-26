module View exposing (view)

import Html exposing (Html, h3, text)
import Types exposing (Model, Msg(..), Route(..))

import Views.Accounts.Add
import Views.Accounts.Edit
import Views.Accounts.List

import Views.Currencies.Add
import Views.Currencies.Edit
import Views.Currencies.List

view : Model -> Html Msg
view model =
    case model.currentRoute of
        Home ->
            h3 [] [ text "Home sweet home" ]

        NotFound ->
            h3 [] [ text "Oops! The page you requested was not found!" ]
            

        -- Accounts
        AccountsIndex ->
            Views.Accounts.List.view model

        AccountsEdit id ->
            h3 [] [ text "Accounts edit" ]
            --case findAccountById id model.accounts of
            --    Just account ->
            --        Views.Accounts.Edit.view model

            --   Nothing ->
            --        h3 [] [ text "Oops! The page you requested was not found!" ]

        AccountsAdd ->
            Views.Accounts.Add.view


        -- Currencies
        CurrenciesIndex ->
            Views.Currencies.List.view model

        CurrenciesEdit id ->
            Views.Currencies.Edit.view model

        CurrenciesAdd ->
            Views.Currencies.Add.view
