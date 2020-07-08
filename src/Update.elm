module Update exposing (update)

import Account.MsgB exposing (MsgB(..))
import Account.Update exposing (accountsUpdate)
import Acctcat.MsgB exposing (MsgB(..))
import Acctcat.Update exposing (acctcatsUpdate)
import Apikey.Update exposing (apikeyUpdate)
import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Bserver.MsgB exposing (MsgB(..))
import Bserver.Update exposing (bserverUpdate)
import Category.MsgB exposing (MsgB(..))
import Category.Update exposing (categoriesUpdate)
import Currency.MsgB exposing (MsgB(..))
import Currency.Update exposing (currenciesUpdate)
import Distribution.MsgB exposing (MsgB(..))
import Distribution.Update exposing (distributionsUpdate)
import Init exposing (emptyAcctcat, initialModel, modelAfterAPIKey)
import Iso8601
import Lint.Update exposing (lintUpdate)
import Model
import Msg exposing (Msg(..))
import Report.Model
import Report.Msg
import Report.Update
import Route exposing (Route(..))
import Routing exposing (extractRoute)
import Time
import Transaction.MsgB exposing (MsgB(..))
import Transaction.Update exposing (transactionsUpdate)
import Translate exposing (Language(..))
import Tutorial exposing (updateTutorialLevel)
import Types exposing (DRCRFormat(..))
import Url


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msgA model =
    case msgA of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UpdateCurrentTime time ->
            ( { model | currentTime = time }, Cmd.none )

        ClearHttpLog ->
            ( { model | http_log = [] }, Cmd.none )

        TimeoutFlashElements posix ->
            ( { model
                | flashMessages =
                    List.filter (\elem -> Time.posixToMillis elem.expirationTime > Time.posixToMillis posix) model.flashMessages
              }
            , Cmd.none
            )

        UrlChanged url ->
            let
                newModel =
                    { model | currentRoute = Routing.extractRoute url }
            in
            case newModel.currentRoute of
                AccountDistributionIndex account_id ->
                    let
                        n =
                            accountsUpdate
                                (GetAccountDistributionJoineds
                                    (newModel.bservers.baseURL
                                        ++ "/distributions/for_account?apikey="
                                        ++ newModel.apikeys.apikey
                                        ++ "&account_id="
                                        ++ account_id
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.accounts
                    in
                    ( { newModel | accounts = n.accounts, http_log = List.append n.log newModel.http_log }, n.cmd )

                AccountsEdit id ->
                    let
                        n =
                            accountsUpdate
                                (GetOneAccount
                                    (newModel.bservers.baseURL
                                        ++ "/account/"
                                        ++ id
                                        ++ "?apikey="
                                        ++ newModel.apikeys.apikey
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.accounts
                    in
                    ( { newModel | accounts = n.accounts, http_log = List.append n.log newModel.http_log }, n.cmd )

                AccountsIndex ->
                    let
                        n =
                            accountsUpdate (GetManyAccounts (newModel.bservers.baseURL ++ "/accounts?apikey=" ++ newModel.apikeys.apikey)) newModel.key newModel.language newModel.currentTime newModel.accounts
                    in
                    ( { newModel | accounts = n.accounts, http_log = List.append n.log newModel.http_log }, n.cmd )

                AcctcatsAdd ->
                    let
                        oldAcctcats =
                            model.acctcats

                        newAcctcats =
                            { oldAcctcats | editBuffer = emptyAcctcat }
                    in
                    ( { newModel | acctcats = newAcctcats }, Cmd.none )

                --BS ->
                --let
                --ts = Iso8601.fromTime model.currentTime
                --bsURLBase
                --= model.bservers.baseURL
                --++ "/balance?"
                --++ "apikey="
                --++ model.apikeys.apikey
                --in
                --( updateAsofTime ts
                --<| updateBSURLbase bsURLBase newModel
                --, Cmd.none
                --)
                CategoriesAccounts category_id ->
                    let
                        n =
                            acctcatsUpdate
                                (GetManyAcctcats category_id
                                    (newModel.bservers.baseURL
                                        ++ "/acctcats/for_category?apikey="
                                        ++ newModel.apikeys.apikey
                                        ++ "&category_id="
                                        ++ String.fromInt category_id
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.acctcats
                    in
                    ( { newModel
                        | acctcats = n.acctcats
                        , http_log = List.append n.log newModel.http_log
                      }
                    , n.cmd
                    )

                CategoriesEdit id ->
                    let
                        n =
                            categoriesUpdate
                                (GetOneCategory
                                    (newModel.bservers.baseURL
                                        ++ "/category/"
                                        ++ id
                                        ++ "?apikey="
                                        ++ newModel.apikeys.apikey
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.categories
                    in
                    ( { newModel | categories = n.categories, http_log = List.append n.log newModel.http_log }, n.cmd )

                CategoriesIndex ->
                    let
                        n =
                            categoriesUpdate (GetManyCategories (newModel.bservers.baseURL ++ "/categories?apikey=" ++ newModel.apikeys.apikey)) newModel.key newModel.language newModel.currentTime newModel.categories
                    in
                    ( { newModel | categories = n.categories, http_log = List.append n.log newModel.http_log }, n.cmd )

                CurrenciesEdit id ->
                    let
                        n =
                            currenciesUpdate
                                (GetOneCurrency
                                    (newModel.bservers.baseURL
                                        ++ "/currency/"
                                        ++ id
                                        ++ "?apikey="
                                        ++ newModel.apikeys.apikey
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.currencies
                    in
                    ( { newModel | currencies = n.currencies, http_log = List.append n.log newModel.http_log }, n.cmd )

                CurrenciesIndex ->
                    let
                        n =
                            currenciesUpdate (GetManyCurrencies (newModel.bservers.baseURL ++ "/currencies?apikey=" ++ newModel.apikeys.apikey)) newModel.key newModel.language newModel.currentTime newModel.currencies
                    in
                    ( { newModel | currencies = n.currencies, http_log = List.append n.log newModel.http_log }, n.cmd )

                DistributionsEdit id ->
                    let
                        n =
                            distributionsUpdate
                                (GetOneDistribution
                                    (newModel.bservers.baseURL
                                        ++ "/distribution/"
                                        ++ id
                                        ++ "?apikey="
                                        ++ newModel.apikeys.apikey
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.distributions
                    in
                    ( { newModel | distributions = n.distributions, http_log = List.append n.log newModel.http_log }, n.cmd )

                DistributionsIndex ->
                    let
                        n =
                            distributionsUpdate
                                (GetManyDistributionJoineds
                                    (newModel.bservers.baseURL
                                        ++ "/distributions/for_tx?apikey="
                                        ++ newModel.apikeys.apikey
                                        ++ "&transaction_id="
                                        ++ String.fromInt newModel.transactions.editBuffer.id
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.distributions
                    in
                    ( { newModel | distributions = n.distributions, http_log = List.append n.log newModel.http_log }, n.cmd )

                ReportRoute ->
                    let
                        --ts = Iso8601.fromTime model.currentTime
                        reportURLBase =
                            model.bservers.baseURL
                                ++ "/category_dist_sums?"
                                ++ "apikey="
                                ++ model.apikeys.apikey
                    in
                    ( updateReportURLBase reportURLBase newModel
                    , Cmd.none
                    )

                TransactionsEdit id ->
                    let
                        n =
                            transactionsUpdate
                                (GetOneTransaction
                                    (newModel.bservers.baseURL
                                        ++ "/transaction/"
                                        ++ id
                                        ++ "?apikey="
                                        ++ newModel.apikeys.apikey
                                    )
                                )
                                newModel.key
                                newModel.language
                                newModel.currentTime
                                newModel.transactions
                    in
                    ( { newModel | transactions = n.transactions, http_log = List.append n.log newModel.http_log }, n.cmd )

                TransactionsIndex ->
                    let
                        n =
                            transactionsUpdate (GetManyTransactions (newModel.bservers.baseURL ++ "/transactions?apikey=" ++ newModel.apikeys.apikey)) newModel.key newModel.language newModel.currentTime newModel.transactions
                    in
                    ( { newModel | transactions = n.transactions, http_log = List.append n.log newModel.http_log }, n.cmd )

                _ ->
                    ( newModel, Cmd.none )

        SetDRCRFormat newFormat ->
            if newFormat == "drcr_conventional" then
                ( { model | drcr_format = DRCR }, Cmd.none )

            else if newFormat == "drcr_pnm" then
                ( { model | drcr_format = PlusAndMinus }, Cmd.none )

            else
                ( model, Cmd.none )

        SetLanguage newLanguage ->
            if newLanguage == "english" then
                ( { model | language = English }, Cmd.none )

            else if newLanguage == "chinese" then
                ( { model | language = Chinese }, Cmd.none )

            else if newLanguage == "pinyin" then
                ( { model | language = Pinyin }, Cmd.none )

            else
                ( model, Cmd.none )

        AccountMsgA msgB ->
            let
                n =
                    accountsUpdate msgB model.key model.language model.currentTime model.accounts
            in
            ( updateTutorialLevel
                { model
                    | accounts = n.accounts
                    , http_log = List.append n.log model.http_log
                    , flashMessages = List.append model.flashMessages n.flashMessages
                }
            , n.cmd
            )

        AcctcatMsgA msgB ->
            let
                n =
                    acctcatsUpdate msgB model.key model.language model.currentTime model.acctcats
            in
            ( updateTutorialLevel
                { model
                    | acctcats = n.acctcats
                    , http_log = List.append n.log model.http_log
                    , flashMessages = List.append model.flashMessages n.flashMessages
                }
            , n.cmd
            )

        -- ANY Apikey message will result in _some_ of the model getting reset.
        ApikeyMsgA msgB ->
            let
                newApikeys =
                    apikeyUpdate msgB model.language model.apikeys

                newModel =
                    { model
                        | accounts = modelAfterAPIKey.accounts
                        , currencies = modelAfterAPIKey.currencies
                        , http_log = modelAfterAPIKey.http_log
                    }
            in
            ( updateTutorialLevel
                { newModel
                    | apikeys = newApikeys.apikeys
                    , http_log = List.append newApikeys.log model.http_log
                }
            , newApikeys.cmd
            )

        -- Not the same as the other branches!
        --BSMsgA msgB ->
        --let
        --n =
        --BS.Update.update msgB model.language model.bs
        --in
        --( { model
        --| bs = n.bs
        --, http_log = List.append n.log model.http_log
        --, flashMessages = List.append model.flashMessages n.flashMessages
        --}
        --, n.cmd
        --)
        -- ANY Bserver message, except PingReceived, will result in the model getting reset
        BserverMsgA msgB ->
            let
                newBservers =
                    bserverUpdate msgB model.language model.bservers

                newModel =
                    case msgB of
                        PingReceived _ ->
                            model

                        _ ->
                            initialModel model.currentRoute model.key model.url

                newModel1 =
                    { newModel | bservers = newBservers.bservers, http_log = List.append newBservers.log newModel.http_log }
            in
            ( updateTutorialLevel newModel1, newBservers.cmd )

        CategoryMsgA msgB ->
            let
                n =
                    categoriesUpdate msgB model.key model.language model.currentTime model.categories
            in
            ( updateTutorialLevel
                { model
                    | categories = n.categories
                    , http_log = List.append n.log model.http_log
                    , flashMessages = List.append model.flashMessages n.flashMessages
                }
            , n.cmd
            )

        CurrencyMsgA msgB ->
            let
                n =
                    currenciesUpdate msgB model.key model.language model.currentTime model.currencies
            in
            ( updateTutorialLevel
                { model
                    | currencies = n.currencies
                    , http_log = List.append n.log model.http_log
                    , flashMessages = List.append model.flashMessages n.flashMessages
                }
            , n.cmd
            )

        DistributionMsgA msgB ->
            let
                n =
                    distributionsUpdate msgB model.key model.language model.currentTime model.distributions
            in
            ( updateTutorialLevel
                { model
                    | distributions = n.distributions
                    , http_log = List.append n.log model.http_log
                    , flashMessages = List.append model.flashMessages n.flashMessages
                }
            , n.cmd
            )

        -- Not the same as the other branches!
        LintMsgA msgB ->
            let
                n =
                    lintUpdate msgB model.language model.lint
            in
            ( { model
                | lint = n.lint
                , http_log = List.append n.log model.http_log
                , flashMessages = List.append model.flashMessages n.flashMessages
              }
            , n.cmd
            )

        Report msgB ->
            let
                n =
                    Report.Update.update msgB model.language model.report
            in
            ( { model
                | report = n.report
                , http_log = List.append n.log model.http_log
                , flashMessages = List.append model.flashMessages n.flashMessages
              }
            , n.cmd
            )

        TransactionMsgA msgB ->
            let
                n =
                    transactionsUpdate msgB model.key model.language model.currentTime model.transactions
            in
            ( updateTutorialLevel
                { model
                    | transactions = n.transactions
                    , http_log = List.append n.log model.http_log
                    , flashMessages = List.append model.flashMessages n.flashMessages
                }
            , n.cmd
            )



-- How to update nested records
-- https://gist.github.com/s-m-i-t-a/2a83c0bc5b7d7081b019d18520ebc62c


setReport : (Report.Model.Model -> Report.Model.Model) -> Model.Model -> Model.Model
setReport fn model =
    { model | report = fn model.report }


setReportURLBase : String -> Report.Model.Model -> Report.Model.Model
setReportURLBase str report =
    { report | reportURLBase = str }


updateReportURLBase : String -> Model.Model -> Model.Model
updateReportURLBase str =
    setReport <| setReportURLBase str
