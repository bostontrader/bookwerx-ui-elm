module Routing exposing ( extractRoute, extractUrl, extractUrlProxied )

import Navigation exposing ( Location )
import UrlParser exposing (..)

import Types exposing ( Route(..), RouteProxied(..) )


extractRoute : Location -> Route
extractRoute location =
    case (parsePath matchRoute location ) of
        Just route ->
            route

        Nothing ->
            NotFound

matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Home top
        , map AccountsAdd (s "ui" </> s "accounts" </> s "add")
        , map AccountsEdit (s "ui" </> s "accounts" </> string)
        , map AccountsIndex (s "ui" </> s "accounts")
        , map CategoriesAdd (s "ui" </> s "categories" </> s "add")
        , map CategoriesEdit (s "ui" </> s "categories" </> string)
        , map CategoriesIndex (s "ui" </> s "categories")
        , map CurrenciesAdd (s "ui" </> s "currencies" </> s "add")
        , map CurrenciesEdit (s "ui" </> s "currencies" </> string)
        , map CurrenciesIndex (s "ui" </> s "currencies")
        , map TransactionsAdd (s "ui" </> s "transactions" </> s "add")
        , map TransactionsEdit (s "ui" </> s "transactions" </> string)
        , map TransactionsIndex (s "ui" </> s "transactions")
        ]

extractUrl: Route  -> String
extractUrl route =
    case route of
        AccountsIndex -> "/ui/accounts"
        CategoriesIndex -> "/ui/categories"
        CurrenciesIndex -> "/ui/currencies"
        TransactionsIndex -> "/ui/transactions"
        _ -> "/notfound"

extractUrlProxied: RouteProxied  -> String
extractUrlProxied route =
    case route of

        AccountsDelete -> "/accounts/"
        AccountsGetMany -> "/accounts"
        AccountsGetOne -> "/accounts/"
        AccountsPatch -> "/accounts/"
        AccountsPost -> "/accounts"

        CategoriesDelete -> "/categories/"
        CategoriesGetMany -> "/categories"
        CategoriesGetOne -> "/categories/"
        CategoriesPatch -> "/categories/"
        CategoriesPost -> "/categories"

        CurrenciesDelete -> "/currencies/"
        CurrenciesGetMany -> "/currencies"
        CurrenciesGetOne -> "/currencies/"
        CurrenciesPatch -> "/currencies/"
        CurrenciesPost -> "/currencies"

        TransactionsDelete -> "/transactions/"
        TransactionsGetMany -> "/transactions"
        TransactionsGetOne -> "/transactions/"
        TransactionsPatch -> "/transactions/"
        TransactionsPost -> "/transactions"