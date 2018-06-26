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
    , currency = RemoteData.Loading
    , newCurrency = emptyCurrency
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

        {-UpdateTitle postId newTitle ->
            let
                updatedPosts =
                    updateTitle postId newTitle model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorName postId newName ->
            let
                updatedPosts =
                    updateAuthorName postId newName model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorUrl postId newUrl ->
            let
                updatedPosts =
                    updateAuthorUrl postId newUrl model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        SubmitUpdatedPost postId ->
            case findPostById postId model.posts of
                Just post ->
                    ( model, updatePostCommand post )

                Nothing ->
                    ( model, Cmd.none )

        PostUpdated _ ->
            ( model, Cmd.none ) -}

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
        FetchCurrencies ->
            ( { model | currencies = RemoteData.Loading }, fetchCurrenciesCommand )

        CurrenciesReceived response ->
            ( { model | currencies = response }, Cmd.none )

        --FetchCurrencyX currencyId ->
        --    ( { model | currencyX = RemoteData.Loading }, fetchCurrencyCommandX currencyId)

        --CurrencyReceivedX response ->
        --    ( { model | currencyX = response }, Cmd.none )

        CurrencyReceived response ->
            ( { model | currency = response }, Cmd.none )

        {-UpdateTitle postId newTitle ->
            let
                updatedPosts =
                    updateTitle postId newTitle model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorName postId newName ->
            let
                updatedPosts =
                    updateAuthorName postId newName model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorUrl postId newUrl ->
            let
                updatedPosts =
                    updateAuthorUrl postId newUrl model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        SubmitUpdatedPost postId ->
            case findPostById postId model.posts of
                Just post ->
                    ( model, updatePostCommand post )

                Nothing ->
                    ( model, Cmd.none )

        PostUpdated _ ->
            ( model, Cmd.none ) -}

        DeleteCurrency currencyId ->
            case findCurrencyById currencyId model.currencies of
                Just currency ->
                    ( model, deleteCurrencyCommand currency )

                Nothing ->
                    ( model, Cmd.none )

        CurrencyDeleted _ ->
            ( model, fetchCurrenciesCommand )

        NewCurrencyTitle newTitle ->
            let
                updatedNewCurrency =
                    setCurrencyTitle newTitle model.newCurrency
            in
                ( { model | newCurrency = updatedNewCurrency }, Cmd.none )

        NewCurrencySymbol newSymbol ->
            let
                updatedNewCurrency =
                    setSymbol newSymbol model.newCurrency
            in
                ( { model | newCurrency = updatedNewCurrency }, Cmd.none )

        CreateNewCurrency ->
            ( model, createCurrencyCommand model.newCurrency )

        CurrencyCreated (Ok currency) ->
            ( { model
                | currencies = addNewCurrency currency model.currencies
                , newCurrency = emptyCurrency
              }
            , Cmd.none
            )

        CurrencyCreated (Err _) ->
            ( model, Cmd.none )



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

setAccountTitle : String -> Account -> Account
setAccountTitle newTitle account =
    { account | title = newTitle }

setCurrencyTitle : String -> Currency -> Currency
setCurrencyTitle newTitle currency =
    { currency | title = newTitle }

{-setAuthorName : String -> Post -> Post
setAuthorName newName post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | name = newName } }


setAuthorUrl : String -> Post -> Post
setAuthorUrl newUrl post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | url = newUrl } }

updateTitle : PostId -> String -> Model -> WebData (List Post)
updateTitle postId newTitle model =
    let
        updatePost post =
            if post.id == postId then
                { post | title =  Debug.log "newTitle: " newTitle }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts

map : (a -> b) -> RemoteData e a -> RemoteData e b
map f data =
    case data of
        Success value ->
            Success (f value)

        Loading ->
            Loading

        NotAsked ->
            NotAsked

        Failure error ->
            Failure error

type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


updateAuthorName : PostId -> String -> Model -> WebData (List Post)
updateAuthorName postId newName model =
    let
        updatePost post =
            if post.id == postId then
                let
                    oldAuthor =
                        post.author
                in
                    { post | author = { oldAuthor | name = newName } }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts


updateAuthorUrl : PostId -> String -> Model -> WebData (List Post)
updateAuthorUrl postId newUrl model =
    let
        updatePost post =
            if post.id == postId then
                let
                    oldAuthor =
                        post.author
                in
                    { post | author = { oldAuthor | url = newUrl } }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts

-}