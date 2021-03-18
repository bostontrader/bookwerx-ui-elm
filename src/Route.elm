module Route exposing (Route(..))


type Route
    = Home
    | AccountDistributionIndex String
    | AccountsAdd
    | AccountsEdit String
    | AccountsIndex
    | AcctcatsAdd
    | ApikeysIndex
    | BserversIndex
    | CategoriesAccounts Int
    | CategoriesAdd
    | CategoriesEdit String
    | CategoriesIndex
    | CurrenciesAdd
    | CurrenciesEdit String
    | CurrenciesIndex
    | DistributionsAdd
    | DistributionsEdit String
    | DistributionsIndex
    | Lint
    | NotFound
    | ReportRoute
    | Settings
    | TransactionsAdd
    | TransactionsEdit String
    | TransactionsIndex
