module Routing exposing (extractRoute, extractUrl)

import Route exposing (Route(..))
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)


extractRoute : Url.Url -> Route
extractRoute location =
    case parse matchRoute location of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Home top
        , map AccountDistributionIndex (s "accounts" </> string </> s "transactions")
        , map AccountsAdd (s "accounts" </> s "add")
        , map AccountsEdit (s "accounts" </> string)
        , map AccountsIndex (s "accounts")
        , map AcctcatsAdd (s "acctcats" </> s "add")
        , map ApikeysIndex (s "apikeys")
        , map BserversIndex (s "bservers")
        , map CategoriesAccounts (s "categories" </> int </> s "accounts")
        , map CategoriesAdd (s "categories" </> s "add")
        , map CategoriesEdit (s "categories" </> string)
        , map CategoriesIndex (s "categories")
        , map CurrenciesAdd (s "currencies" </> s "add")
        , map CurrenciesEdit (s "currencies" </> string)
        , map CurrenciesIndex (s "currencies")
        , map DistributionsAdd (s "distributions" </> s "add")
        , map DistributionsEdit (s "distributions" </> string)
        , map DistributionsIndex (s "distributions")
        --, map HttpLog (s "http_log")
        , map Lint (s "lint")
        , map ReportRoute (s "report")
        , map Settings (s "settings")
        , map TransactionsAdd (s "transactions" </> s "add")
        , map TransactionsEdit (s "transactions" </> string)
        , map TransactionsIndex (s "transactions")
        ]


extractUrl : Route -> String
extractUrl route =
    case route of
        AccountsIndex ->
            "/accounts"

        ApikeysIndex ->
            "/apikeys"

        BserversIndex ->
            "/bservers"

        CategoriesIndex ->
            "/categories"

        CurrenciesIndex ->
            "/currencies"

        DistributionsIndex ->
            "/distributions"

        Lint ->
            "/lint"

        ReportRoute ->
            "/report"

        Settings ->
            "/settings"

        TransactionsIndex ->
            "/transactions"

        _ ->
            "/notfound"
