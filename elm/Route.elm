module Route exposing ( Route(..) )


-- These are the UI routes that this server directly supports
type Route
    = Home
    | NotFound

    -- Accounts
    | AccountsAdd
    | AccountsEdit String
    | AccountsIndex

    -- Categories
    | CategoriesAdd
    | CategoriesEdit String
    | CategoriesIndex

    -- Currencies
    | CurrenciesAdd
    | CurrenciesEdit String
    | CurrenciesIndex

    -- Transactions
    | TransactionsAdd
    | TransactionsEdit String
    | TransactionsIndex
