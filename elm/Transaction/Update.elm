module Transaction.Update exposing ( transactionUpdate )

import RemoteData exposing ( WebData )

import Misc exposing
    ( findTransactionById
    , insertFlashElement
    )

import Model exposing ( Model )
import Msg exposing ( Msg )
import Route
import TypesB exposing ( FlashMsg, FlashSeverity (..)  )

import Transaction.API.Delete exposing ( deleteTransactionCommand )
import Transaction.API.GetMany exposing ( getManyTransactionsCommand )
import Transaction.API.GetOne exposing ( getOneTransactionCommand )
import Transaction.API.Patch exposing ( patchTransactionCommand )
import Transaction.API.Post exposing ( postTransactionCommand )
import Transaction.Model exposing ( Model )

import Transaction.Plumbing exposing
    ( TransactionGetOneHttpResponse(..)
    , TransactionPostHttpResponse(..)
    )

import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing ( TransactionMsgB (..) )


transactionUpdate : Msg -> Model.Model -> TransactionMsgB -> ( Model.Model, Cmd Msg )
transactionUpdate msg model transactionMsgB =

    case transactionMsgB of

        -- delete
        DeleteTransaction transactionId ->
            case findTransactionById transactionId model.transactions.transactions of
                Just wdTransaction ->
                    ( model, deleteTransactionCommand wdTransaction )

                Nothing ->
                    ( model, Cmd.none )

        TransactionDeleted response ->
            ( model, getManyTransactionsCommand )

        -- getMany
        TransactionsReceived newTransactionsB ->
            ( newTransactionsB
                |> asTransactionsBIn model.transactions
                |> asTransactionsAIn model
            , Cmd.none
            )

        -- getOne
        TransactionReceived response ->

            case response of

                RemoteData.NotAsked ->
                    ( response
                        |> asWdTransactionIn model.transactions
                        |> asTransactionsAIn model
                    , Cmd.none
                    )

                RemoteData.Loading ->
                    ( response
                        |> asWdTransactionIn model.transactions
                        |> asTransactionsAIn model
                    , Cmd.none
                    )

                RemoteData.Failure e ->
                    ( response
                        |> asWdTransactionIn model.transactions
                        |> asTransactionsAIn model
                    , Cmd.none
                    )

                RemoteData.Success value ->
                    case value of
                        TransactionGetOneErrorsResponse e ->
                            ( response
                                |> asWdTransactionIn model.transactions
                                |> asTransactionsAIn model
                            , Cmd.none
                            )

                        TransactionGetOneDataResponse transaction ->
                            ( model.transactions
                                |> setWdTransaction response
                                |> setEditTransaction transaction
                                |> asTransactionsAIn model
                            , Cmd.none
                            )

        -- patch
        PatchTransaction ->
            ( model, patchTransactionCommand model.transactions.editTransaction )

        TransactionPatched response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "transaction patch error"  FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                RemoteData.Success successResult ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "transaction patch success"  FlashSuccess 0 (model.currentTime + 5000.0)) ) }, Cmd.none )


        -- post
        PostTransaction ->
            (model, postTransactionCommand model.transactions.editTransaction)

        TransactionPosted response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "transaction post error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                RemoteData.Success successResult ->

                    case successResult of
                        TransactionPostErrorsResponse e ->
                            ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "transaction post error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                        TransactionPostDataResponse response ->
                            ( { model
                                | flashMessages =
                                    ( insertFlashElement model.flashMessages (FlashMsg "transaction post success" FlashSuccess 0 (model.currentTime + 5000.0)) )
                                , currentRoute = Route.TransactionsEdit response.insertedId
                              }
                              , getOneTransactionCommand response.insertedId
                            )


        -- edit
        UpdateTransactionDatetime newDatetime ->
            ( newDatetime
                |> asDatetimeIn model.transactions.editTransaction
                |> asEditTransactionIn model.transactions
                |> asTransactionsAIn model
            , Cmd.none
            )


        UpdateTransactionNote newNote ->
            ( newNote
                |> asNoteIn model.transactions.editTransaction
                |> asEditTransactionIn model.transactions
                |> asTransactionsAIn model
            , Cmd.none
            )


-- These functions enable us to update fields in nested records of the models using compact and readable code.
-- The Application model has a field named Transactions.
setTransactionsA: Transaction.Model.Model -> Model.Model -> Model.Model
setTransactionsA newTransactions model =
    { model | transactions = newTransactions }

-- The Transactions model has a field named Transactions.
setTransactionsB: WebData ( List Transaction ) -> Transaction.Model.Model -> Transaction.Model.Model
setTransactionsB newTransactions model =
    { model | transactions = newTransactions }

-- The Transactions model has a field named wdTransaction.
setWdTransaction: WebData TransactionGetOneHttpResponse -> Transaction.Model.Model -> Transaction.Model.Model
setWdTransaction newWdTransaction model =
    { model | wdTransaction = newWdTransaction }

-- The Transactions model has a field named editTransaction.
setEditTransaction: Transaction -> Transaction.Model.Model -> Transaction.Model.Model
setEditTransaction newEditTransaction model =
    { model | editTransaction = newEditTransaction }

asTransactionsAIn: Model.Model -> Transaction.Model.Model -> Model.Model
asTransactionsAIn =
    flip setTransactionsA

asTransactionsBIn: Transaction.Model.Model -> WebData ( List Transaction ) -> Transaction.Model.Model
asTransactionsBIn =
    flip setTransactionsB

asWdTransactionIn: Transaction.Model.Model -> WebData TransactionGetOneHttpResponse -> Transaction.Model.Model
asWdTransactionIn =
    flip setWdTransaction

asEditTransactionIn: Transaction.Model.Model -> Transaction -> Transaction.Model.Model
asEditTransactionIn newEditTransaction model =
    flip setEditTransaction newEditTransaction model

setDatetime: String -> Transaction -> Transaction
setDatetime newDatetime model =
    { model | datetime = newDatetime }

asDatetimeIn: Transaction -> String -> Transaction
asDatetimeIn =
    flip setDatetime

setNote: String -> Transaction -> Transaction
setNote newNote model =
    { model | note = newNote }

asNoteIn: Transaction -> String -> Transaction
asNoteIn =
    flip setNote
