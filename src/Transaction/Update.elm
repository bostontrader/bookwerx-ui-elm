module Transaction.Update exposing (transactionsUpdate)

import Browser.Navigation as Nav
import Constants exposing (flashMessageDuration)
import Flash exposing (FlashMsg, FlashSeverity(..), expires)
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Route exposing (Route(..))
import Routing exposing (extractUrl)
import Time
import Transaction.API.Delete exposing (deleteTransactionCommand)
import Transaction.API.GetMany exposing (getManyTransactionsCommand)
import Transaction.API.GetOne exposing (getOneTransactionCommand)
import Transaction.API.JSON exposing (transactionDecoder, transactionsDecoder)
import Transaction.API.Post exposing (postTransactionCommand)
import Transaction.API.Put exposing (putTransactionCommand)
import Transaction.Model
import Transaction.MsgB exposing (MsgB(..))
import Transaction.Transaction exposing (Transaction)
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


transactionsUpdate : MsgB -> Nav.Key -> Language -> Time.Posix -> Transaction.Model.Model -> { transactions : Transaction.Model.Model, cmd : Cmd Msg, flashMessages : List FlashMsg }
transactionsUpdate transactionMsgB key language currentTime model =
    case transactionMsgB of
        -- delete
        DeleteTransaction url ->
            { transactions = model
            , cmd = deleteTransactionCommand url
            , flashMessages = []
            }

        TransactionDeleted response ->
            { transactions = model
            , cmd = Nav.pushUrl key (extractUrl TransactionsIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- getMany
        GetManyTransactions url ->
            { transactions = { model | wdTransactions = RemoteData.Loading }
            , cmd = getManyTransactionsCommand url
            , flashMessages = []
            }

        TransactionsReceived newTransactionsB ->
            { transactions =
                { model
                    | wdTransactions = newTransactionsB
                    , transactions =
                        case decodeString transactionsDecoder (getRemoteDataStatusMessage newTransactionsB English) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- getOne
        GetOneTransaction url ->
            { transactions = { model | wdTransaction = RemoteData.Loading }
            , cmd = getOneTransactionCommand url
            , flashMessages = []
            }

        TransactionReceived response ->
            { transactions =
                case decodeString transactionDecoder (getRemoteDataStatusMessage response English) of
                    Ok value ->
                        { model | editBuffer = value }

                    Err _ ->
                        -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                        model
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- put
        PutTransaction url contentType body ->
            { transactions = model
            , cmd = putTransactionCommand url contentType body
            , flashMessages = []
            }

        TransactionPutted response ->
            { transactions = model
            , cmd = Nav.pushUrl key (extractUrl TransactionsIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- post
        PostTransaction url contentType body ->
            { transactions = model
            , cmd = postTransactionCommand url contentType body
            , flashMessages = []
            }

        TransactionPosted response ->
            { transactions = model
            , cmd = Nav.pushUrl key (extractUrl TransactionsIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- edit
        UpdateNotes newValue ->
            { transactions = { model | editBuffer = updateNotes model.editBuffer newValue }
            , cmd = Cmd.none
            , flashMessages = []
            }

        UpdateTime newValue ->
            { transactions = { model | editBuffer = updateTime model.editBuffer newValue }
            , cmd = Cmd.none
            , flashMessages = []
            }


updateNotes : Transaction -> String -> Transaction
updateNotes c newNotes =
    { c | notes = newNotes }


updateTime : Transaction -> String -> Transaction
updateTime c newTime =
    { c | time = newTime }
