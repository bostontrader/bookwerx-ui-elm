module Currency.Update exposing ( currencyUpdate )

import RemoteData exposing ( WebData )

import Misc exposing
    ( findCurrencyById
    , insertFlashElement
    )

import Model exposing ( Model )
import Msg exposing ( Msg )
import Route
import TypesB exposing ( FlashMsg, FlashSeverity (..)  )

import Currency.API.Delete exposing ( deleteCurrencyCommand )
import Currency.API.GetMany exposing ( getManyCurrenciesCommand )
import Currency.API.GetOne exposing ( getOneCurrencyCommand )
import Currency.API.Patch exposing ( patchCurrencyCommand )
import Currency.API.Post exposing ( postCurrencyCommand )
import Currency.Model exposing ( Model )

import Currency.Plumbing exposing 
    ( CurrencyGetOneHttpResponse(..)
    , CurrencyPostHttpResponse(..)
    )

import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing ( CurrencyMsgB (..) )


currencyUpdate : Msg -> Model.Model -> CurrencyMsgB -> ( Model.Model, Cmd Msg )
currencyUpdate msg model currencyMsgB =

    case currencyMsgB of

        -- delete
        DeleteCurrency currencyId ->
            case findCurrencyById currencyId model.currencies.currencies of
                Just wdCurrency ->
                    ( model, deleteCurrencyCommand wdCurrency )

                Nothing ->
                    ( model, Cmd.none )

        CurrencyDeleted response ->
            ( model, getManyCurrenciesCommand )

        -- getMany
        CurrenciesReceived newCurrenciesB ->
            ( newCurrenciesB
                |> asCurrenciesBIn model.currencies
                |> asCurrenciesAIn model
            , Cmd.none
            )

        -- getOne
        CurrencyReceived response ->

            case response of

                RemoteData.NotAsked ->
                    ( response
                        |> asWdCurrencyIn model.currencies
                        |> asCurrenciesAIn model
                    , Cmd.none
                    )

                RemoteData.Loading ->
                    ( response
                        |> asWdCurrencyIn model.currencies
                        |> asCurrenciesAIn model
                    , Cmd.none
                    )

                RemoteData.Failure e ->
                    ( response
                        |> asWdCurrencyIn model.currencies
                        |> asCurrenciesAIn model
                    , Cmd.none
                    )

                RemoteData.Success value ->
                    case value of
                        CurrencyGetOneErrorsResponse e ->
                            ( response
                                |> asWdCurrencyIn model.currencies
                                |> asCurrenciesAIn model
                            , Cmd.none
                            )

                        CurrencyGetOneDataResponse currency ->
                            ( model.currencies
                                |> setWdCurrency response
                                |> setEditCurrency currency
                                |> asCurrenciesAIn model
                            , Cmd.none
                            )

        -- patch
        PatchCurrency ->
            ( model, patchCurrencyCommand model.currencies.editCurrency )

        CurrencyPatched response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "currency patch error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                RemoteData.Success successResult ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "currency patch success" FlashSuccess 0 (model.currentTime + 5000.0)) ) }, Cmd.none )


        -- post
        PostCurrency ->
            (model, postCurrencyCommand model.currencies.editCurrency)

        CurrencyPosted response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "currency post error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                RemoteData.Success successResult ->

                    case successResult of
                        CurrencyPostErrorsResponse e ->
                            ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "currency post error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                        CurrencyPostDataResponse response ->
                            ( { model
                                | flashMessages =
                                    ( insertFlashElement model.flashMessages (FlashMsg "currency post success" FlashSuccess 0 (model.currentTime + 5000.0)) )
                                , currentRoute = Route.CurrenciesEdit response.insertedId
                              }
                              , getOneCurrencyCommand response.insertedId
                            )


        -- edit
        UpdateCurrencySymbol newSymbol ->
            ( newSymbol
                |> asSymbolIn model.currencies.editCurrency
                |> asEditCurrencyIn model.currencies
                |> asCurrenciesAIn model
            , Cmd.none
            )


        UpdateCurrencyTitle newTitle ->
            ( newTitle
                |> asTitleIn model.currencies.editCurrency
                |> asEditCurrencyIn model.currencies
                |> asCurrenciesAIn model
            , Cmd.none
            )


-- These functions enable us to update fields in nested records of the models using compact and readable code.
-- The Application model has a field named Currencies.
setCurrenciesA: Currency.Model.Model -> Model.Model -> Model.Model
setCurrenciesA newCurrencies model =
    { model | currencies = newCurrencies }

-- The Currencies model has a field named Currencies.
setCurrenciesB: WebData ( List Currency ) -> Currency.Model.Model -> Currency.Model.Model
setCurrenciesB newCurrencies model =
    { model | currencies = newCurrencies }

-- The Currencies model has a field named wdCurrency.
setWdCurrency: WebData CurrencyGetOneHttpResponse -> Currency.Model.Model -> Currency.Model.Model
setWdCurrency newWdCurrency model =
    { model | wdCurrency = newWdCurrency }

-- The Currencies model has a field named editCurrency.
setEditCurrency: Currency -> Currency.Model.Model -> Currency.Model.Model
setEditCurrency newEditCurrency model =
    { model | editCurrency = newEditCurrency }

asCurrenciesAIn: Model.Model -> Currency.Model.Model -> Model.Model
asCurrenciesAIn =
    flip setCurrenciesA

asCurrenciesBIn: Currency.Model.Model -> WebData ( List Currency ) -> Currency.Model.Model
asCurrenciesBIn =
    flip setCurrenciesB

asWdCurrencyIn: Currency.Model.Model -> WebData CurrencyGetOneHttpResponse -> Currency.Model.Model
asWdCurrencyIn =
    flip setWdCurrency

asEditCurrencyIn: Currency.Model.Model -> Currency -> Currency.Model.Model
asEditCurrencyIn newEditCurrency model =
    flip setEditCurrency newEditCurrency model

setSymbol: String -> Currency -> Currency
setSymbol newSymbol model =
    { model | symbol = newSymbol }

asSymbolIn: Currency -> String -> Currency
asSymbolIn =
    flip setSymbol

setTitle: String -> Currency -> Currency
setTitle newTitle model =
    { model | title = newTitle }

asTitleIn: Currency -> String -> Currency
asTitleIn =
    flip setTitle
