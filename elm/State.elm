module State exposing (init, update)

import RemoteData exposing (WebData)

import Types exposing
    ( Flags
    , Model
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
    , AccountPostHttpResponse(..)
    , Category
    , CategoryPostHttpResponse(..)
    , Currency
    , CurrencyPostHttpResponse(..)
    , Transaction
    , TransactionPostHttpResponse(..)
    )

--import Accounts.Rest exposing
--    ( createAccountCommand
--    , deleteAccountCommand
--    , getOneAccountCommand
--    , getManyAccountsCommand
--    , updateAccountCommand
--    )
import Accounts.REST.Delete exposing ( deleteAccountCommand )
import Accounts.REST.GetMany exposing ( getManyAccountsCommand )
import Accounts.REST.GetOne exposing ( getOneAccountCommand )
import Accounts.REST.Patch exposing ( patchAccountCommand )
import Accounts.REST.Post exposing ( postAccountCommand )

--import Categories.Rest exposing
--    ( createCategoryCommand
--    , deleteCategoryCommand
--    , getOneCategoryCommand
--    , getManyCategoriesCommand
--    , updateCategoryCommand
--    )
import Categories.REST.Delete exposing ( deleteCategoryCommand )
import Categories.REST.GetMany exposing ( getManyCategoriesCommand )
import Categories.REST.GetOne exposing ( getOneCategoryCommand )
import Categories.REST.Patch exposing ( patchCategoryCommand )
import Categories.REST.Post exposing ( postCategoryCommand )

--import Currencies.Rest exposing
--    ( createCurrencyCommand
--    , deleteCurrencyCommand
--    , getOneCurrencyCommand
--    , getManyCurrenciesCommand
--    , updateCurrencyCommand
--    )
import Currencies.REST.Delete exposing ( deleteCurrencyCommand )
import Currencies.REST.GetMany exposing ( getManyCurrenciesCommand )
import Currencies.REST.GetOne exposing ( getOneCurrencyCommand )
import Currencies.REST.Patch exposing ( patchCurrencyCommand )
import Currencies.REST.Post exposing ( postCurrencyCommand )

--import Transactions.REST.Rest exposing
--    ( createTransactionCommand
--    , deleteTransactionCommand
--    , fetchTransactionCommand
    -- , getManyTransactionsCommand
--    , patchTransactionCommand
--    )

import Transactions.REST.Delete exposing ( deleteTransactionCommand )
import Transactions.REST.GetMany exposing ( getManyTransactionsCommand )
import Transactions.REST.GetOne exposing ( getOneTransactionCommand )
import Transactions.REST.Patch exposing ( patchTransactionCommand )
import Transactions.REST.Post exposing ( postTransactionCommand )

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
    Transaction tempTransactionId "" ""

initialModel : Flags -> Route -> Model
initialModel flags route =
    { currentRoute = route
    , runtimeConfig = flags

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

init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.extractRoute location

    in
        case currentRoute of
            AccountsIndex ->
                ( initialModel flags currentRoute, getManyAccountsCommand )

            AccountsEdit id ->
                ( initialModel flags currentRoute, getOneAccountCommand id )

            CategoriesIndex ->
                ( initialModel flags currentRoute, getManyCategoriesCommand )

            CategoriesEdit id ->
                ( initialModel flags currentRoute, getOneCategoryCommand id )

            CurrenciesIndex ->
                ( initialModel flags currentRoute, getManyCurrenciesCommand )

            CurrenciesEdit id ->
                ( initialModel flags currentRoute, getOneCurrencyCommand id )

            TransactionsIndex ->
                ( initialModel flags currentRoute, getManyTransactionsCommand )

            TransactionsEdit id ->
                ( initialModel flags currentRoute, getOneTransactionCommand id )

            _ ->
                ( initialModel flags currentRoute, Cmd.none)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "State update msg" msg of
        LocationChanged location ->
            ( { model | currentRoute = Routing.extractRoute location }
            , Cmd.none
            )


        -- Accounts
        -- index
        --FetchAccounts ->
        --    ( { model | accounts = RemoteData.Loading }, getManyAccountsCommand )

        AccountsReceived response ->
            ( { model | accounts = response }, Cmd.none )

        -- add
        CreateNewAccount ->
            ( model, postAccountCommand model.editAccount )

        NewAccountTitle newTitle ->
            let
                updatedNewAccount =
                    setAccountTitle newTitle model.editAccount
            in
                ( { model | editAccount = updatedNewAccount }, Cmd.none )

        --AccountCreated (Ok wdAccount) ->
        --    ( { model
        --        | accounts = addNewAccount wdAccount model.accounts
        --        , editAccount = emptyAccount
        --      }
        --    , Cmd.none
        --    )

        --AccountCreated (Err _) ->
        --    ( model, Cmd.none )

        AccountCreated _ ->
            ( model, getManyAccountsCommand )

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
                        ErrorAccountPostResponse e ->
                            ({model | wdAccount = response}, Cmd.none)
                        ValidAccountPostResponse account ->
                            ( {model | wdAccount = response, editAccount = account}, Cmd.none )

        UpdateAccountTitle newTitle ->
            let
                nc = model.editAccount
            in
                ({model | editAccount = {nc | title = newTitle}}, Cmd.none)

        SubmitUpdatedAccount ->
            (model, patchAccountCommand model.editAccount)

        AccountPatched _ ->
            ( model, Cmd.none )

        -- delete
        DeleteAccount accountId ->
            case findAccountById accountId model.accounts of
                Just account ->
                    ( model, deleteAccountCommand account )

                Nothing ->
                    ( model, Cmd.none )

        AccountDeleted _ ->
            ( model, getManyAccountsCommand )


        -- Categories
        -- index
        FetchCategories ->
            ( { model | categories = RemoteData.Loading }, getManyCategoriesCommand )

        CategoriesReceived response ->
            ( { model | categories = response }, Cmd.none )

        -- add
        CreateNewCategory ->
            ( model, postCategoryCommand model.editCategory )

        NewCategoryTitle newTitle ->
            let
                updatedNewCategory =
                    setCategoryTitle newTitle model.editCategory
            in
                ( { model | editCategory = updatedNewCategory }, Cmd.none )

        --CategoryCreated (Ok wdCategory) ->
        --    ( { model
        --        | categories = addNewCategory wdCategory model.categories
        --        , editCategory = emptyCategory
        --      }
        --    , Cmd.none
        --    )

        --CategoryCreated (Err _) ->
        --    ( model, Cmd.none )
        CategoryCreated _ ->
            ( model, getManyCategoriesCommand )

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
                        ErrorCategoryPostResponse e ->
                            ({model | wdCategory = response}, Cmd.none)
                        ValidCategoryPostResponse category ->
                            ( {model | wdCategory = response, editCategory = category}, Cmd.none )

        UpdateCategoryTitle newTitle ->
            let
                nc = model.editCategory
            in
                ({model | editCategory = {nc | title = newTitle}}, Cmd.none)

        SubmitUpdatedCategory ->
            (model, patchCategoryCommand model.editCategory)

        CategoryPatched _ ->
            ( model, Cmd.none )

        -- delete
        DeleteCategory categoryId ->
            case findCategoryById categoryId model.categories of
                Just category ->
                    ( model, deleteCategoryCommand category )

                Nothing ->
                    ( model, Cmd.none )

        CategoryDeleted _ ->
            ( model, getManyCategoriesCommand )


        -- Currencies
        -- index
        FetchCurrencies ->
            ( { model | currencies = RemoteData.Loading }, getManyCurrenciesCommand )

        CurrenciesReceived response ->
            ( { model | currencies = response }, Cmd.none )

        -- add
        CreateNewCurrency ->
            (model, postCurrencyCommand model.editCurrency)

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
                        ErrorCurrencyPostResponse e ->
                            ({model | wdCurrency = response}, Cmd.none)
                        ValidCurrencyPostResponse currency ->
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
            (model, patchCurrencyCommand model.editCurrency)

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
            ( model, getManyCurrenciesCommand )


        -- Transactions
        -- index
        --FetchTransactions ->
        --    ( { model | transactions = RemoteData.Loading }, getManyTransactionsCommand )

        TransactionsReceived response ->
            ( { model | transactions = response }, Cmd.none )

        -- add
        CreateNewTransaction ->
            (model, postTransactionCommand model.editTransaction)

        NewTransactionDatetime newDatetime ->
            let
                updatedNewTransaction =
                    setTransactionDatetime newDatetime model.editTransaction

            in
                ( { model | editTransaction = updatedNewTransaction}, Cmd.none )

        NewTransactionNote newNote ->
            let
                updatedNewTransaction =
                    setTransactionNote newNote model.editTransaction

            in
                ( { model | editTransaction = updatedNewTransaction}, Cmd.none )

        --TransactionCreated (Ok wdTransaction) ->
            --( --{ model
              --  | transactions = addNewTransaction wdTransaction model.transactions
              --}
            --model
             --, Cmd.none
            --, Debug.log "State forward to edit:" (getOneTransactionCommand "catfood")
            --)

        --TransactionCreated (Err _) ->
        --    ( model, Cmd.none )

        --TransactionCreated response ->
        --    case Debug.log "State update TransactionCreated:" response of
        --        RemoteData.NotAsked ->
        --            ( model, Cmd.none )
        --        RemoteData.Loading ->
        --            ( model, Cmd.none )
        --        RemoteData.Failure e ->
        --            ( model, Cmd.none )
        --        RemoteData.Success cehr ->
        --            ( model, Cmd.none )
        TransactionCreated _ ->
            ( model, getManyTransactionsCommand )

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
                        ErrorTransactionPostResponse e ->
                            ({model | wdTransaction = response}, Cmd.none)
                        ValidTransactionPostResponse transaction ->
                            ( {model | wdTransaction = response, editTransaction = transaction}, Cmd.none )

        UpdateTransactionDatetime newDatetime ->
            let
                nc = model.editTransaction
            in
                ({model | editTransaction = {nc | datetime = newDatetime}}, Cmd.none)

        UpdateTransactionNote newNote ->
            let
                nc = model.editTransaction
            in
                ({model | editTransaction = {nc | note = newNote}}, Cmd.none)

        SubmitUpdatedTransaction ->
            (model, patchTransactionCommand model.editTransaction)

        TransactionPatched _ ->
            ( model, Cmd.none )

        -- delete
        DeleteTransaction transactionId ->
            case findTransactionById transactionId model.transactions of
                Just wdTransaction ->
                    ( model, deleteTransactionCommand wdTransaction )

                Nothing ->
                    ( model, Cmd.none )

        TransactionDeleted _ ->
            ( model, getManyTransactionsCommand )


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

setTransactionDatetime : String -> Transaction -> Transaction
setTransactionDatetime newDatetime transaction =
    { transaction | datetime = newDatetime }

setTransactionNote : String -> Transaction -> Transaction
setTransactionNote newNote transaction =
    { transaction | note = newNote }
    