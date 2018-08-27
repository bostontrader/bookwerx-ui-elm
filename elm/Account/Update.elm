module Account.Update exposing ( accountUpdate )

import RemoteData exposing ( WebData )

import Misc exposing
    ( findAccountById
    , insertFlashElement
    )

import Model exposing ( Model )
import Msg exposing ( Msg )
import Route
import TypesB exposing ( FlashMsg, FlashSeverity (..) )

import Account.API.Delete exposing ( deleteAccountCommand )
import Account.API.GetMany exposing ( getManyAccountsCommand )
import Account.API.GetOne exposing ( getOneAccountCommand )
import Account.API.Patch exposing ( patchAccountCommand )
import Account.API.Post exposing ( postAccountCommand )
import Account.Model exposing ( Model )

import Account.Plumbing exposing 
    ( AccountGetOneHttpResponse(..)
    , AccountPostHttpResponse(..)
    )

import Account.Account exposing ( Account )
import Account.AccountMsgB exposing ( AccountMsgB (..) )


accountUpdate : Msg -> Model.Model -> AccountMsgB -> ( Model.Model, Cmd Msg )
accountUpdate msg model accountMsgB =

    case accountMsgB of

        -- delete
        DeleteAccount accountId ->
            case findAccountById accountId model.accounts.accounts of
                Just wdAccount ->
                    ( model, deleteAccountCommand wdAccount )

                Nothing ->
                    ( model, Cmd.none )

        AccountDeleted response ->
            ( model, getManyAccountsCommand )

        -- getMany
        AccountsReceived newAccountsB ->
            ( newAccountsB
                |> asAccountsBIn model.accounts
                |> asAccountsAIn model
            , Cmd.none
            )

        -- getOne
        AccountReceived response ->

            case response of

                RemoteData.NotAsked ->
                    ( response
                        |> asWdAccountIn model.accounts
                        |> asAccountsAIn model
                    , Cmd.none
                    )

                RemoteData.Loading ->
                    ( response
                        |> asWdAccountIn model.accounts
                        |> asAccountsAIn model
                    , Cmd.none
                    )

                RemoteData.Failure e ->
                    ( response
                        |> asWdAccountIn model.accounts
                        |> asAccountsAIn model
                    , Cmd.none
                    )

                RemoteData.Success value ->
                    case value of
                        AccountGetOneErrorsResponse e ->
                            ( response
                                |> asWdAccountIn model.accounts
                                |> asAccountsAIn model
                            , Cmd.none
                            )

                        AccountGetOneDataResponse account ->
                            ( model.accounts
                                |> setWdAccount response
                                |> setEditAccount account
                                |> asAccountsAIn model
                            , Cmd.none
                            )

        -- patch
        PatchAccount ->
            ( model, patchAccountCommand model.accounts.editAccount )

        AccountPatched response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "account patch error" FlashError 0 (model.currentTime + 5000.0)  ) ) }, Cmd.none )

                RemoteData.Success successResult ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "account patch success" FlashSuccess 0 (model.currentTime + 5000.0) ) ) }, Cmd.none )


        -- post
        PostAccount ->
            (model, postAccountCommand model.accounts.editAccount)

        AccountPosted response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "account post error" FlashError 0 (model.currentTime + 5000.0) ) ) }, Cmd.none )

                RemoteData.Success successResult ->

                    case successResult of
                        AccountPostErrorsResponse e ->
                            ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "account post error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                        AccountPostDataResponse response ->
                            ( { model
                                | flashMessages =
                                    ( insertFlashElement model.flashMessages (FlashMsg "account post success" FlashSuccess 0 (model.currentTime + 5000.0)) )
                                , currentRoute = Route.AccountsEdit response.insertedId
                              }
                              , getOneAccountCommand response.insertedId
                            )


        -- edit
        UpdateAccountTitle newTitle ->
            ( newTitle
                |> asTitleIn model.accounts.editAccount
                |> asEditAccountIn model.accounts
                |> asAccountsAIn model
            , Cmd.none
            )


-- These functions enable us to update fields in nested records of the models using compact and readable code.
-- The Application model has a field named Accounts.
setAccountsA: Account.Model.Model -> Model.Model -> Model.Model
setAccountsA newAccounts model =
    { model | accounts = newAccounts }

-- The Accounts model has a field named Accounts.
setAccountsB: WebData ( List Account ) -> Account.Model.Model -> Account.Model.Model
setAccountsB newAccounts model =
    { model | accounts = newAccounts }

-- The Accounts model has a field named wdAccount.
setWdAccount: WebData AccountGetOneHttpResponse -> Account.Model.Model -> Account.Model.Model
setWdAccount newWdAccount model =
    { model | wdAccount = newWdAccount }

-- The Accounts model has a field named editAccount.
setEditAccount: Account -> Account.Model.Model -> Account.Model.Model
setEditAccount newEditAccount model =
    { model | editAccount = newEditAccount }

asAccountsAIn: Model.Model -> Account.Model.Model -> Model.Model
asAccountsAIn =
    flip setAccountsA

asAccountsBIn: Account.Model.Model -> WebData ( List Account ) -> Account.Model.Model
asAccountsBIn =
    flip setAccountsB

asWdAccountIn: Account.Model.Model -> WebData AccountGetOneHttpResponse -> Account.Model.Model
asWdAccountIn =
    flip setWdAccount

asEditAccountIn: Account.Model.Model -> Account -> Account.Model.Model
asEditAccountIn newEditAccount model =
    flip setEditAccount newEditAccount model

setTitle: String -> Account -> Account
setTitle newTitle model =
    { model | title = newTitle }

asTitleIn: Account -> String -> Account
asTitleIn =
    flip setTitle
