module Account.Update exposing (accountsUpdate)

import Account.API.Delete exposing (deleteAccountCommand)
import Account.API.GetAccountDistributionJoineds exposing (getAccountDistributionJoinedsCommand)
import Account.API.GetMany exposing (getManyAccountsCommand)
import Account.API.GetOne exposing (getOneAccountCommand)
import Account.API.JSON exposing (accountDecoder, accountJoinedsDecoder)
import Account.API.Post exposing (postAccountCommand)
import Account.API.Put exposing (putAccountCommand)
import Account.Account exposing (AccountEB)
import Account.Model
import Account.MsgB exposing (MsgB(..))
import Browser.Navigation as Nav
import Constants exposing (flashMessageDuration)
import Distribution.API.JSON exposing (distributionJoinedsDecoder)
import Flash exposing (FlashMsg, FlashSeverity(..), expires)
import IntField exposing (IntField(..))
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Route as R
import Routing exposing (extractUrl)
import Time
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


accountsUpdate : MsgB -> Nav.Key -> Language -> Time.Posix -> Account.Model.Model -> { accounts : Account.Model.Model, cmd : Cmd Msg, flashMessages : List FlashMsg }
accountsUpdate accountMsgB key language currentTime model =
    case accountMsgB of
        -- delete
        DeleteAccount url ->
            { accounts = model
            , cmd = deleteAccountCommand url
            , flashMessages = []
            }

        AccountDeleted response ->
            { accounts = model
            , cmd = Nav.pushUrl key (extractUrl R.AccountsIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- edit
        UpdateCurrencyID newCurrencyID ->
            { accounts = { model | editBuffer = updateCurrencyID model.editBuffer newCurrencyID }
            , cmd = Cmd.none
            , flashMessages = []
            }

        UpdateDecimalPlaces newValue ->
            { accounts = { model | decimalPlaces = newValue }
            , cmd = Cmd.none
            , flashMessages = []
            }

        UpdateTitle newTitle ->
            { accounts = { model | editBuffer = updateTitle model.editBuffer newTitle }
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- getMany
        GetManyAccounts url ->
            { accounts = { model | wdAccounts = RemoteData.Loading }
            , cmd = getManyAccountsCommand url
            , flashMessages = []
            }

        AccountsReceived newAccountsB ->
            { accounts =
                { model
                    | wdAccounts = newAccountsB
                    , accounts =
                        case decodeString accountJoinedsDecoder (getRemoteDataStatusMessage newAccountsB language) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- getAccountDistributionJoineds
        GetAccountDistributionJoineds url ->
            { accounts = { model | wdDistributionJoineds = RemoteData.Loading }
            , cmd = getAccountDistributionJoinedsCommand url
            , flashMessages = []
            }

        AccountDistributionJoinedsReceived distributionJoineds ->
            { accounts =
                { model
                    | wdDistributionJoineds = distributionJoineds
                    , distributionJoineds =
                        case decodeString distributionJoinedsDecoder (getRemoteDataStatusMessage distributionJoineds language) of
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
        GetOneAccount url ->
            { accounts = { model | wdAccount = RemoteData.Loading }
            , cmd = getOneAccountCommand url
            , flashMessages = []
            }

        AccountReceived response ->
            { accounts =
                case decodeString accountDecoder (getRemoteDataStatusMessage response language) of
                    Ok value ->
                        -- convert incoming Account to AccountEB
                        { model | editBuffer =
                            (AccountEB value.id value.apikey -1 False value.currency_id value.title )
                        }

                    Err _ ->
                        -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                        model
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- post
        PostAccount url contentType body ->
            { accounts = model
            , cmd = postAccountCommand url contentType body
            , flashMessages = []
            }

        AccountPosted response ->
            { accounts = model
            , cmd = Nav.pushUrl key (extractUrl R.AccountsIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- put
        PutAccount url contentType body ->
            { accounts = model
            , cmd = putAccountCommand url contentType body
            , flashMessages = []
            }

        AccountPutted response ->
            { accounts = model
            , cmd = Nav.pushUrl key (extractUrl R.AccountsIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        UpdateFilterCategoryID newValue ->
            { accounts = { model | editBuffer = updateCategoryFilterID model.editBuffer newValue }
            , cmd = Cmd.none
            , flashMessages = []
            }

        ToggleFilterCategoryInvert ->
            { accounts = { model | editBuffer = toggleFilterCategoryInvert model.editBuffer }
            , cmd = Cmd.none
            , flashMessages = []
            }


toggleFilterCategoryInvert : AccountEB -> AccountEB
toggleFilterCategoryInvert eb =
    { eb | category_filter_invert = not eb.category_filter_invert}

updateCategoryFilterID : AccountEB -> String -> AccountEB
updateCategoryFilterID d newValue =
    { d
        | category_filter_id =
            case String.toInt newValue of
                Just v ->
                    v

                Nothing ->
                    -1
    }


updateCurrencyID : AccountEB -> String -> AccountEB
updateCurrencyID c newValue =
    { c
        | currency_id =
            case String.toInt newValue of
                Just v ->
                    v

                Nothing ->
                    -1
    }


updateTitle : AccountEB -> String -> AccountEB
updateTitle c newTitle =
    { c | title = newTitle }
