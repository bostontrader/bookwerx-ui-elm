module State exposing ( init, update )

import Navigation exposing (Location)
import RemoteData exposing ( WebData )
import Routing exposing (extractRoute)

import Model exposing ( Model )
import TypesB exposing
    ( Flags
    , FlashMsg
    )

import Msg exposing ( Msg (..) )
import Route exposing ( Route (..) )

import Account.API.GetMany exposing ( getManyAccountsCommand )
import Account.API.GetOne exposing ( getOneAccountCommand )
import Account.Model exposing ( Model )
import Account.Plumbing exposing ( AccountGetOneHttpResponse )
import Account.Update exposing ( accountUpdate )
import Account.Account exposing ( Account )

import Category.API.GetMany exposing ( getManyCategoriesCommand )
import Category.API.GetOne exposing ( getOneCategoryCommand )
import Category.Model exposing ( Model )
import Category.Plumbing exposing ( CategoryGetOneHttpResponse )
import Category.Update exposing ( categoryUpdate )
import Category.Category exposing ( Category )

import Currency.API.GetMany exposing ( getManyCurrenciesCommand )
import Currency.API.GetOne exposing ( getOneCurrencyCommand )
import Currency.Model exposing ( Model )
import Currency.Plumbing exposing ( CurrencyGetOneHttpResponse )
import Currency.Update exposing ( currencyUpdate )
import Currency.Currency exposing ( Currency )

import Transaction.API.GetMany exposing ( getManyTransactionsCommand )
import Transaction.API.GetOne exposing ( getOneTransactionCommand )
import Transaction.Plumbing exposing (TransactionGetOneHttpResponse )
import Transaction.Transaction exposing ( Transaction )
import Transaction.Model exposing ( Model )
import Transaction.Update exposing ( transactionUpdate )


tempAccountId = "-1"
emptyAccount : Account
emptyAccount = Account tempAccountId ""

tempCategoryId = "-1"
emptyCategory : Category
emptyCategory = Category tempCategoryId ""

tempCurrencyId = "-1"
emptyCurrency : Currency
emptyCurrency = Currency tempCurrencyId "" ""

tempTransactionId = "-1"
emptyTransaction : Transaction
emptyTransaction = Transaction tempTransactionId "" ""

emptyFlashMessages : List FlashMsg
emptyFlashMessages = []

initialModel : Flags -> Route -> Model.Model
initialModel flags route =

    { currentRoute = route
    , flashMessages = emptyFlashMessages
    , nextFlashId = 0
    , currentTime = 0.0

    , runtimeConfig = flags

    , accounts =
        { accounts = RemoteData.NotAsked
        , wdAccount = RemoteData.NotAsked
        , editAccount = emptyAccount
        }

    , categories =
        { categories = RemoteData.NotAsked
        , wdCategory = RemoteData.NotAsked
        , editCategory = emptyCategory
        }

    , currencies =
        { currencies = RemoteData.NotAsked
        , wdCurrency = RemoteData.NotAsked
        , editCurrency = emptyCurrency
        }

    , transactions =
        { transactions = RemoteData.NotAsked
        , wdTransaction = RemoteData.NotAsked
        , editTransaction = emptyTransaction
        }
    }


init : Flags -> Location -> ( Model.Model, Cmd Msg )
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


-- Dup! Factor these out!
-- The Accounts model has a field named wdAccount.
setWdAccount: WebData AccountGetOneHttpResponse -> Account.Model.Model -> Account.Model.Model
setWdAccount newWdAccount model =
    { model | wdAccount = newWdAccount }

-- Dup! Factor this out
asAccountsAIn: Model.Model -> Account.Model.Model -> Model.Model
asAccountsAIn =
    flip setAccountsA

-- The Application model has a field named Accounts.
setAccountsA: Account.Model.Model -> Model.Model -> Model.Model
setAccountsA newAccounts model =
    { model | accounts = newAccounts }


setWdCategory: WebData CategoryGetOneHttpResponse -> Category.Model.Model -> Category.Model.Model
setWdCategory newWdCategory model =
    { model | wdCategory = newWdCategory }

-- Dup! Factor this out
asCategoriesAIn: Model.Model -> Category.Model.Model -> Model.Model
asCategoriesAIn =
    flip setCategoriesA

-- The Application model has a field named Categories.
setCategoriesA: Category.Model.Model -> Model.Model -> Model.Model
setCategoriesA newCategories model =
    { model | categories = newCategories }



setWdCurrency: WebData CurrencyGetOneHttpResponse -> Currency.Model.Model -> Currency.Model.Model
setWdCurrency newWdCurrency model =
    { model | wdCurrency = newWdCurrency }

-- Dup! Factor this out
asCurrenciesAIn: Model.Model -> Currency.Model.Model -> Model.Model
asCurrenciesAIn =
    flip setCurrenciesA

-- The Application model has a field named Currencies.
setCurrenciesA: Currency.Model.Model -> Model.Model -> Model.Model
setCurrenciesA newCurrencies model =
    { model | currencies = newCurrencies }


setWdTransaction: WebData TransactionGetOneHttpResponse -> Transaction.Model.Model -> Transaction.Model.Model
setWdTransaction newWdTransaction model =
    { model | wdTransaction = newWdTransaction }

-- Dup! Factor this out
asTransactionsAIn: Model.Model -> Transaction.Model.Model -> Model.Model
asTransactionsAIn =
    flip setTransactionsA

-- The Application model has a field named Transactions.
setTransactionsA: Transaction.Model.Model -> Model.Model -> Model.Model
setTransactionsA newTransactions model =
    { model | transactions = newTransactions }




update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =

    case Debug.log "State update msg" msg of

        UpdateCurrentTime time ->
            { model | currentTime = time } ! []
            --( model, Cmd.none )


        TimeoutFlashElements time ->
            let
                newList =
                    List.filter
                        (\elem -> elem.expirationTime > time)
                        model.flashMessages
            in
                { model | flashMessages = newList } ! []

        LocationChanged location ->
            let

                newRoute = Routing.extractRoute location
                newModel = {model | currentRoute = newRoute}

            in
                case newRoute of

                    AccountsIndex ->
                        let
                            oldAccounts = model.accounts
                            newAccounts = { oldAccounts | accounts = RemoteData.Loading}
                        in
                            ( {newModel | accounts = newAccounts }, getManyAccountsCommand )

                    AccountsEdit id->
                        ( model.accounts
                            |> setWdAccount RemoteData.Loading
                            |> asAccountsAIn newModel
                        , getOneAccountCommand id
                        )



                    CategoriesIndex ->
                        let
                            oldCategories = model.categories
                            newCategories = { oldCategories | categories = RemoteData.Loading}
                        in
                            ( {newModel | categories = newCategories }, getManyCategoriesCommand )

                    CategoriesEdit id->
                        ( model.categories
                            |> setWdCategory RemoteData.Loading
                            |> asCategoriesAIn newModel
                        , getOneCategoryCommand id
                        )


                    CurrenciesIndex ->
                        let
                            oldCurrencies = model.currencies
                            newCurrencies = { oldCurrencies | currencies = RemoteData.Loading}
                        in
                            ( {newModel | currencies = newCurrencies }, getManyCurrenciesCommand )

                    CurrenciesEdit id->
                        ( model.currencies
                            |> setWdCurrency RemoteData.Loading
                            |> asCurrenciesAIn newModel
                        , getOneCurrencyCommand id
                        )


                    TransactionsIndex ->
                        let
                            oldTransactions = model.transactions
                            newTransactions = { oldTransactions | transactions = RemoteData.Loading}
                        in
                            ( {newModel | transactions = newTransactions }, getManyTransactionsCommand )

                    TransactionsEdit id->
                        ( model.transactions
                            |> setWdTransaction RemoteData.Loading
                            |> asTransactionsAIn newModel
                        , getOneTransactionCommand id
                        )
                    _ ->
                        ( newModel, Cmd.none )



        AccountMsgA response ->
            accountUpdate msg model response

        CategoryMsgA response ->
            categoryUpdate msg model response

        CurrencyMsgA response ->
             currencyUpdate msg model response

        TransactionMsgA response ->
            transactionUpdate msg model response


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
