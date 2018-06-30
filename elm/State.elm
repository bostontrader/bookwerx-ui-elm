module State exposing (init, update)

import RemoteData exposing (WebData)

import Types exposing
    ( Account
    , Currency
    , CurrencyEditHttpResponse(..)
    , CurrencyId
    , Model
    , Msg(..)
    , Route
        ( CurrenciesEdit
        , CurrenciesIndex
        )
    )

import Rest exposing
    ( createAccountCommand
    , deleteAccountCommand
    , fetchAccountsCommand
    , fetchAccountCommand
    , createCurrencyCommand
    , deleteCurrencyCommand
    , fetchCurrenciesCommand
    , fetchCurrencyCommand
    , updateCurrencyCommand
    )

import Navigation exposing (Location)
import Routing exposing (extractRoute)
import Misc exposing
    ( --findAccountById
    findCurrencyById
    )

tempAccountId =
    "-1"

emptyAccount : Account
emptyAccount =
    Account tempAccountId ""

tempCurrencyId =
    "-1"

emptyCurrency : Currency
emptyCurrency =
    Currency tempCurrencyId "" ""

initialModel : Route -> Model
initialModel route =
    { currentRoute = route

    , accounts = RemoteData.Loading
    , account = RemoteData.NotAsked
    , newAccount = emptyAccount

    , currencies = RemoteData.Loading
    , wdCurrency = RemoteData.Loading
    , editCurrency = emptyCurrency
    --, newCurrency = emptyCurrency
    }

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.extractRoute (Debug.log "State init location" location)
        _ = Debug.log "State init currentRoute" currentRoute

    in
        case currentRoute of
            CurrenciesIndex ->
                ( initialModel currentRoute, fetchCurrenciesCommand )

            CurrenciesEdit id ->
                ( initialModel currentRoute, fetchCurrencyCommand id )

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
        FetchAccounts ->
            ( { model | accounts = RemoteData.Loading }, fetchAccountsCommand )

        AccountsReceived response ->
            ( { model | accounts = response }, Cmd.none )

        FetchAccount accountId ->
            ( { model | account = RemoteData.Loading }, fetchAccountCommand accountId)

        AccountReceived response ->
            ( { model | account = response }, Cmd.none )


        DeleteAccount accountId ->
            --case findAccountById accountId model.accounts of
                --Just account ->
                    --( model, deleteAccountCommand account )

                --Nothing ->
                    ( model, Cmd.none )

        AccountDeleted _ ->
            ( model, fetchAccountsCommand )

        NewAccountTitle newTitle ->
            let
                updatedNewAccount =
                    setAccountTitle newTitle model.newAccount
            in
                ( { model | newAccount = updatedNewAccount }, Cmd.none )

        --NewAccountSymbol newSymbol ->
        --    let
        --        updatedNewAccount =
        --            setSymbol newSymbol model.newAccount
        --    in
        --        ( { model | newAccount = updatedNewAccount }, Cmd.none )

        CreateNewAccount ->
            ( model, createAccountCommand model.newAccount )

        AccountCreated (Ok account) ->
            ( { model
                | accounts = addNewAccount account model.accounts
                , newAccount = emptyAccount
              }
            , Cmd.none
            )

        AccountCreated (Err _) ->
            ( model, Cmd.none )

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
                    setSymbol newSymbol model.editCurrency
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



addNewAccount : Account -> WebData (List Account) -> WebData (List Account)
addNewAccount newAccount accounts =
    let
        appendAccount : List Account -> List Account
        appendAccount listOfAccounts =
            List.append listOfAccounts [ newAccount ]
    in
        RemoteData.map appendAccount accounts


addNewCurrency : Currency -> WebData (List Currency) -> WebData (List Currency)
addNewCurrency newCurrency currencies =
    let
        appendCurrency : List Currency -> List Currency
        appendCurrency listOfCurrencies =
            List.append listOfCurrencies [ newCurrency ]
    in
        RemoteData.map appendCurrency currencies


setSymbol : String -> Currency -> Currency
setSymbol newSymbol currency =
    { currency | symbol = newSymbol }

setEditSymbol : String -> Currency -> Currency
setEditSymbol newSymbol currency =
    { currency | symbol = newSymbol }

setAccountTitle : String -> Account -> Account
setAccountTitle newTitle account =
    { account | title = newTitle }

setCurrencyTitle : String -> Currency -> Currency
setCurrencyTitle newTitle currency =
    { currency | title = newTitle }
