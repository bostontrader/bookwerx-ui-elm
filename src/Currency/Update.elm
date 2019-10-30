module Currency.Update exposing (currenciesUpdate)

import Browser.Navigation as Nav
import Constants exposing (flashMessageDuration)
import Currency.API.Delete exposing (deleteCurrencyCommand)
import Currency.API.GetMany exposing (getManyCurrenciesCommand)
import Currency.API.GetOne exposing (getOneCurrencyCommand)
import Currency.API.JSON exposing (currenciesDecoder, currencyDecoder)
import Currency.API.Post exposing (postCurrencyCommand)
import Currency.API.Put exposing (putCurrencyCommand)
import Currency.Currency exposing (Currency)
import Currency.MsgB exposing (MsgB(..))
import Currency.Model
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Route exposing (..)
import Routing exposing (extractUrl)
import Time
import Translate exposing (Language(..))
import IntField exposing (IntField(..))
import Flash exposing (FlashMsg, FlashSeverity(..), expires)
import Util exposing (getRemoteDataStatusMessage)


currenciesUpdate : MsgB -> Nav.Key -> Language -> Time.Posix -> Currency.Model.Model -> { currencies : Currency.Model.Model, cmd : Cmd Msg, log : List String, flashMessages : List FlashMsg }
currenciesUpdate currencyMsgB key language currentTime model  =
    case currencyMsgB of
        -- delete
        DeleteCurrency url ->
            { currencies = model
            , cmd = deleteCurrencyCommand url
            , log = [ "DELETE " ++ url ]
            , flashMessages = []
            }

        CurrencyDeleted response ->
            { currencies = model
            , cmd = Nav.pushUrl key (extractUrl CurrenciesIndex)
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- edit
        UpdateRarity newValue ->
            { currencies = { model | editBuffer = updateRarity model.editBuffer newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateRarityFilter newValue ->
            { currencies =
                case newValue |> String.toInt of
                    Nothing ->
                        { model | rarityFilter = IntField Nothing newValue }

                    Just v ->
                        { model | rarityFilter = IntField (Just v) newValue }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateSymbol newSymbol ->
            { currencies = { model | editBuffer = updateSymbol model.editBuffer newSymbol }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        UpdateTitle newTitle ->
            { currencies = { model | editBuffer = updateTitle model.editBuffer newTitle }
            , cmd = Cmd.none
            , log = []
            , flashMessages = []
            }

        -- getMany
        GetManyCurrencies url ->
            { currencies = { model | wdCurrencies = RemoteData.Loading }
            , cmd = getManyCurrenciesCommand url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        CurrenciesReceived newCurrenciesB ->
            { currencies =
                { model
                    | wdCurrencies = newCurrenciesB
                    , currencies =
                        case decodeString currenciesDecoder (getRemoteDataStatusMessage newCurrenciesB language) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage newCurrenciesB language ]
            , flashMessages = []
            }

        -- getOne
        GetOneCurrency url ->
            { currencies = { model | wdCurrency = RemoteData.Loading }
            , cmd = getOneCurrencyCommand url
            , log = [ "GET " ++ url ]
            , flashMessages = []
            }

        CurrencyReceived response ->
            { currencies =
                case decodeString currencyDecoder (getRemoteDataStatusMessage response language) of
                    Ok value ->
                        --{ model | editBuffer = value, editBufferRarity = IntField (Just value.rarity) (toString value.rarity) }
                        { model | editBuffer = value }

                    Err _ ->
                        -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                        model
            , cmd = Cmd.none
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = []
            }

        -- post
        PostCurrency url contentType body ->
            { currencies = model
            , cmd = postCurrencyCommand url contentType body
            , log = [ "POST " ++ url ++ " " ++ contentType ++ " " ++ body ]
            , flashMessages = []
            }

        CurrencyPosted response ->
            { currencies = model
            , cmd = Nav.pushUrl key (extractUrl CurrenciesIndex)
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- put
        PutCurrency url contentType body ->
            { currencies = model
            , cmd = putCurrencyCommand url contentType body
            , log = [ "PUT " ++ url ++ " " ++ contentType ++ " " ++ body ]
            , flashMessages = []
            }

        CurrencyPutted response ->
            { currencies = model
            , cmd = Nav.pushUrl key (extractUrl CurrenciesIndex)
            , log = [ getRemoteDataStatusMessage response language ]
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }


updateRarity : Currency -> String -> Currency
updateRarity c newValue =
    { c
        | rarity =
            case String.toInt newValue of
                Just v ->
                    IntField (Just v) newValue

                Nothing ->
                    IntField Nothing newValue
    }


updateRarityFilter : String -> Int
updateRarityFilter newValue =
    case String.toInt newValue of
        --Ok v ->
            --v

        --Err _ ->
            ---1
        Just v ->
            v

        Nothing ->
            -1

updateSymbol : Currency -> String -> Currency
updateSymbol c newSymbol =
    { c | symbol = newSymbol }


updateTitle : Currency -> String -> Currency
updateTitle c newTitle =
    { c | title = newTitle }
