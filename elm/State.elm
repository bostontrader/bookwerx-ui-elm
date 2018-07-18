module State exposing (init, update)

import RemoteData exposing (WebData)

import Types exposing
    ( Model
    , Msg(..)
    , Route
        ( AccountsEdit
        , AccountsIndex
        , CategoriesEdit
        , CategoriesIndex
        , CurrenciesEdit
        , CurrenciesIndex
        , TransactionsEdit
        , TransactionsIndex
        )
    , Account
    , AccountEditHttpResponse(..)
    , Category
    , CategoryEditHttpResponse(..)
    , Currency
    , CurrencyEditHttpResponse(..)
    , Transaction
    , TransactionEditHttpResponse(..)
    )

import Accounts.Rest exposing
    ( createAccountCommand
    , deleteAccountCommand
    , fetchAccountCommand
    , fetchAccountsCommand
    , updateAccountCommand
    )

import Categories.Rest exposing
    ( createCategoryCommand
    , deleteCategoryCommand
    , fetchCategoryCommand
    , fetchCategoriesCommand
    , updateCategoryCommand
    )

import Currencies.Rest exposing
    ( createCurrencyCommand
    , deleteCurrencyCommand
    , fetchCurrencyCommand
    , fetchCurrenciesCommand
    , updateCurrencyCommand
    )

import Transactions.Rest exposing
    ( createTransactionCommand
    , deleteTransactionCommand
    , fetchTransactionCommand
    , fetchTransactionsCommand
    , updateTransactionCommand
    )

import Navigation exposing (Location)
import Routing exposing (extractRoute)
import Misc exposing
    ( findAccountById
    , findCategoryById
    , findCurrencyById
    , findTransactionById
    )

tempAccountId =
    "-1"

emptyAccount : Account
emptyAccount =
    Account tempAccountId ""

tempCategoryId =
    "-1"

emptyCategory : Category
emptyCategory =
    Category tempCategoryId ""

tempCurrencyId =
    "-1"

emptyCurrency : Currency
emptyCurrency =
    Currency tempCurrencyId "" ""

tempTransactionId =
    "-1"

emptyTransaction : Transaction
emptyTransaction =
    Transaction tempTransactionId ""

initialModel : Route -> Model
initialModel route =
    { currentRoute = route

    , accounts = RemoteData.Loading
    , wdAccount = RemoteData.Loading
    , editAccount = emptyAccount

    , categories = RemoteData.Loading
    , wdCategory = RemoteData.Loading
    , editCategory = emptyCategory

    , currencies = RemoteData.Loading
    , wdCurrency = RemoteData.Loading
    , editCurrency = emptyCurrency

    , transactions = RemoteData.Loading
    , wdTransaction = RemoteData.Loading
    , editTransaction = emptyTransaction
    }

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.extractRoute location

    in
        case currentRoute of
            AccountsIndex ->
                ( initialModel currentRoute, fetchAccountsCommand )

            AccountsEdit id ->
                ( initialModel currentRoute, fetchAccountCommand id )

            CategoriesIndex ->
                ( initialModel currentRoute, fetchCategoriesCommand )

            CategoriesEdit id ->
                ( initialModel currentRoute, fetchCategoryCommand id )

            CurrenciesIndex ->
                ( initialModel currentRoute, fetchCurrenciesCommand )

            CurrenciesEdit id ->
                ( initialModel currentRoute, fetchCurrencyCommand id )

            TransactionsIndex ->
                ( initialModel currentRoute, fetchTransactionsCommand )

            TransactionsEdit id ->
                ( initialModel currentRoute, fetchTransactionCommand id )

            _ ->
                ( initialModel currentRoute, Cmd.none)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "State update msg" msg of
        LocationChanged location ->
            ( { model | currentRoute = Routing.extractRoute location }
            , Cmd.none
            )


        -- Accounts
        -- index
        FetchAccounts ->
            ( { model | accounts = RemoteData.Loading }, fetchAccountsCommand )

        AccountsReceived response ->
            ( { model | accounts = response }, Cmd.none )

        -- add
        CreateNewAccount ->
            ( model, createAccountCommand model.editAccount )

        NewAccountTitle newTitle ->
            let
                updatedNewAccount =
                    setAccountTitle newTitle model.editAccount
            in
                ( { model | editAccount = updatedNewAccount }, Cmd.none )

        AccountCreated (Ok wdAccount) ->
            ( { model
                | accounts = addNewAccount wdAccount model.accounts
                , editAccount = emptyAccount
              }
            , Cmd.none
            )

        AccountCreated (Err _) ->
            ( model, Cmd.none )

        -- edit
        AccountReceived response ->
            case Debug.log "State update wdAccount:" response of
                RemoteData.NotAsked ->
                    ( {model | wdAccount = response}, Cmd.none )
                RemoteData.Loading ->
                    ( {model | wdAccount = response}, Cmd.none )
                RemoteData.Failure e ->
                    ( {model | wdAccount = response}, Cmd.none )
                RemoteData.Success cehr ->
                    case Debug.log "State update cehr:" cehr of
                        ErrorAccountEditResponse e ->
                            ({model | wdAccount = response}, Cmd.none)
                        ValidAccountEditResponse account ->
                            ( {model | wdAccount = response, editAccount = account}, Cmd.none )

        UpdateAccountTitle newTitle ->
            let
                nc = model.editAccount
            in
                ({model | editAccount = {nc | title = newTitle}}, Cmd.none)

        SubmitUpdatedAccount ->
            (model, updateAccountCommand model.editAccount)

        AccountUpdated _ ->
            ( model, Cmd.none )

        -- delete
        DeleteAccount accountId ->
            case findAccountById accountId model.accounts of
                Just account ->
                    ( model, deleteAccountCommand account )

                Nothing ->
                    ( model, Cmd.none )

        AccountDeleted _ ->
            ( model, fetchAccountsCommand )


        -- Categories
        -- index
        FetchCategories ->
            ( { model | categories = RemoteData.Loading }, fetchCategoriesCommand )

        CategoriesReceived response ->
            ( { model | categories = response }, Cmd.none )

        -- add
        CreateNewCategory ->
            ( model, createCategoryCommand model.editCategory )

        NewCategoryTitle newTitle ->
            let
                updatedNewCategory =
                    setCategoryTitle newTitle model.editCategory
            in
                ( { model | editCategory = updatedNewCategory }, Cmd.none )

        CategoryCreated (Ok wdCategory) ->
            ( { model
                | categories = addNewCategory wdCategory model.categories
                , editCategory = emptyCategory
              }
            , Cmd.none
            )

        CategoryCreated (Err _) ->
            ( model, Cmd.none )

        -- edit
        CategoryReceived response ->
            case Debug.log "State update wdCategory:" response of
                RemoteData.NotAsked ->
                    ( {model | wdCategory = response}, Cmd.none )
                RemoteData.Loading ->
                    ( {model | wdCategory = response}, Cmd.none )
                RemoteData.Failure e ->
                    ( {model | wdCategory = response}, Cmd.none )
                RemoteData.Success cehr ->
                    case Debug.log "State update cehr:" cehr of
                        ErrorCategoryEditResponse e ->
                            ({model | wdCategory = response}, Cmd.none)
                        ValidCategoryEditResponse category ->
                            ( {model | wdCategory = response, editCategory = category}, Cmd.none )

        UpdateCategoryTitle newTitle ->
            let
                nc = model.editCategory
            in
                ({model | editCategory = {nc | title = newTitle}}, Cmd.none)

        SubmitUpdatedCategory ->
            (model, updateCategoryCommand model.editCategory)

        CategoryUpdated _ ->
            ( model, Cmd.none )

        -- delete
        DeleteCategory categoryId ->
            case findCategoryById categoryId model.categories of
                Just category ->
                    ( model, deleteCategoryCommand category )

                Nothing ->
                    ( model, Cmd.none )

        CategoryDeleted _ ->
            ( model, fetchCategoriesCommand )


        -- Currencies
        -- index
        FetchCurrencies ->
            ( { model | currencies = RemoteData.Loading }, fetchCurrenciesCommand )

        CurrenciesReceived response ->
            ( { model | currencies = response }, Cmd.none )

        -- add
        CreateNewCurrency ->
            (model, createCurrencyCommand model.editCurrency)

        NewCurrencyTitle newTitle ->
            let
                updatedNewCurrency =
                    setCurrencyTitle newTitle model.editCurrency

            in
                ( { model | editCurrency = updatedNewCurrency}, Cmd.none )

        NewCurrencySymbol newSymbol ->
            let
                updatedNewCurrency =
                    setCurrencySymbol newSymbol model.editCurrency
            in
                ( { model | editCurrency = updatedNewCurrency }, Cmd.none )

        CurrencyCreated (Ok wdCurrency) ->
            ( { model
                | currencies = addNewCurrency wdCurrency model.currencies
              }
            , Cmd.none
            )

        CurrencyCreated (Err _) ->
            ( model, Cmd.none )

        -- edit
        CurrencyReceived response ->
            case Debug.log "State update wdCurrency:" response of
                RemoteData.NotAsked ->
                    ( {model | wdCurrency = response}, Cmd.none )
                RemoteData.Loading ->
                    ( {model | wdCurrency = response}, Cmd.none )
                RemoteData.Failure e ->
                    ( {model | wdCurrency = response}, Cmd.none )
                RemoteData.Success cehr ->
                    case Debug.log "State update cehr:" cehr of
                        ErrorCurrencyEditResponse e ->
                            ({model | wdCurrency = response}, Cmd.none)
                        ValidCurrencyEditResponse currency ->
                            ( {model | wdCurrency = response, editCurrency = currency}, Cmd.none )

        UpdateCurrencySymbol newSymbol ->
            let
                nc = model.editCurrency
            in
                ( {model | editCurrency = {nc | symbol = newSymbol}}, Cmd.none)

        UpdateCurrencyTitle newTitle ->
            let
                nc = model.editCurrency
            in
                ({model | editCurrency = {nc | title = newTitle}}, Cmd.none)


        SubmitUpdatedCurrency ->
            (model, updateCurrencyCommand model.editCurrency)

        CurrencyUpdated _ ->
            ( model, Cmd.none )

        -- delete
        DeleteCurrency currencyId ->
            case findCurrencyById currencyId model.currencies of
                Just wdCurrency ->
                    ( model, deleteCurrencyCommand wdCurrency )

                Nothing ->
                    ( model, Cmd.none )

        CurrencyDeleted _ ->
            ( model, fetchCurrenciesCommand )


        -- Transactions
        -- index
        FetchTransactions ->
            ( { model | transactions = RemoteData.Loading }, fetchTransactionsCommand )

        TransactionsReceived response ->
            ( { model | transactions = response }, Cmd.none )

        -- add
        CreateNewTransaction ->
            (model, createTransactionCommand model.editTransaction)

        NewTransactionNote newNote ->
            let
                updatedNewTransaction =
                    setTransactionNote newNote model.editTransaction

            in
                ( { model | editTransaction = updatedNewTransaction}, Cmd.none )

        TransactionCreated (Ok wdTransaction) ->
            ( { model
                | transactions = addNewTransaction wdTransaction model.transactions
              }
            , Cmd.none
            )

        TransactionCreated (Err _) ->
            ( model, Cmd.none )

        -- edit
        TransactionReceived response ->
            case Debug.log "State update wdTransaction:" response of
                RemoteData.NotAsked ->
                    ( {model | wdTransaction = response}, Cmd.none )
                RemoteData.Loading ->
                    ( {model | wdTransaction = response}, Cmd.none )
                RemoteData.Failure e ->
                    ( {model | wdTransaction = response}, Cmd.none )
                RemoteData.Success cehr ->
                    case Debug.log "State update cehr:" cehr of
                        ErrorTransactionEditResponse e ->
                            ({model | wdTransaction = response}, Cmd.none)
                        ValidTransactionEditResponse transaction ->
                            ( {model | wdTransaction = response, editTransaction = transaction}, Cmd.none )

        UpdateTransactionNote newNote ->
            let
                nc = model.editTransaction
            in
                ({model | editTransaction = {nc | note = newNote}}, Cmd.none)


        SubmitUpdatedTransaction ->
            (model, updateTransactionCommand model.editTransaction)

        TransactionUpdated _ ->
            ( model, Cmd.none )

        -- delete
        DeleteTransaction transactionId ->
            case findTransactionById transactionId model.transactions of
                Just wdTransaction ->
                    ( model, deleteTransactionCommand wdTransaction )

                Nothing ->
                    ( model, Cmd.none )

        TransactionDeleted _ ->
            ( model, fetchTransactionsCommand )


addNewAccount : Account -> WebData (List Account) -> WebData (List Account)
addNewAccount newAccount accounts =
    let
        appendAccount : List Account -> List Account
        appendAccount listOfAccounts =
            List.append listOfAccounts [ newAccount ]
    in
        RemoteData.map appendAccount accounts

addNewCategory : Category -> WebData (List Category) -> WebData (List Category)
addNewCategory newCategory categories =
    let
        appendCategory : List Category -> List Category
        appendCategory listOfCategories =
            List.append listOfCategories [ newCategory ]
    in
        RemoteData.map appendCategory categories

addNewCurrency : Currency -> WebData (List Currency) -> WebData (List Currency)
addNewCurrency newCurrency currencies =
    let
        appendCurrency : List Currency -> List Currency
        appendCurrency listOfCurrencies =
            List.append listOfCurrencies [ newCurrency ]
    in
        RemoteData.map appendCurrency currencies

addNewTransaction : Transaction -> WebData (List Transaction) -> WebData (List Transaction)
addNewTransaction newTransaction transactions =
    let
        appendTransaction : List Transaction -> List Transaction
        appendTransaction listOfTransactions =
            List.append listOfTransactions [ newTransaction ]
    in
        RemoteData.map appendTransaction transactions

setAccountTitle : String -> Account -> Account
setAccountTitle newTitle account =
    { account | title = newTitle }

setCategoryTitle : String -> Category -> Category
setCategoryTitle newTitle category =
    { category | title = newTitle }

setCurrencySymbol : String -> Currency -> Currency
setCurrencySymbol newSymbol currency =
    { currency | symbol = newSymbol }

setCurrencyTitle : String -> Currency -> Currency
setCurrencyTitle newTitle currency =
    { currency | title = newTitle }

setTransactionNote : String -> Transaction -> Transaction
setTransactionNote newNote transaction =
    { transaction | note = newNote }
