module Init exposing (emptyAcctcat, init, initialModel, modelAfterAPIKey)

import Account.Account exposing (Account)
import Acctcat.Acctcat exposing (Acctcat)
import Browser.Navigation as Nav
import Category.Category exposing (Category)
import Constants as C
import Currency.Currency exposing (Currency)
import Distribution.Distribution exposing (DistributionEB)
import Form.View
import IntField exposing (IntField(..))
import Model exposing (Model, ModelAfterAPIKey)
import Msg exposing (Msg(..))
import RemoteData
import Route exposing (Route(..))
import Routing exposing (extractRoute)
import Time
import Transaction.Transaction exposing (Transaction)
import Types exposing (DRCR(..))
import Url


emptyAccount : Account
emptyAccount =
    Account -1 "" -1 (IntField (Just 0) "0") ""


emptyAcctcat : Acctcat
emptyAcctcat =
    Acctcat -1 "" -1 -1


emptyCategory : Category
emptyCategory =
    Category -1 "" "" ""


emptyCurrency : Currency
emptyCurrency =
    Currency -1 "" (IntField (Just 0) "0") "" ""


emptyDistribution : DistributionEB
emptyDistribution =
    DistributionEB -1 "" -1 (IntField (Just 0) "0") (IntField (Just 0) "0") -1 DR


emptyTransaction : Transaction
emptyTransaction =
    Transaction -1 "" "" ""


initialModel : Route -> Nav.Key -> Url.Url -> Model.Model
initialModel route key url =
    { currentRoute = route
    , currentTime = Time.millisToPosix 0
    , drcr_format = C.initialDRCRFormat
    , flashMessages = []
    , http_log = modelAfterAPIKey.http_log
    , key = key
    , tutorialLevel = 0
    , tutorialActive = True
    , language = C.initialLanguage
    , url = url
    , accounts = modelAfterAPIKey.accounts
    , acctcats = modelAfterAPIKey.acctcats
    , apikeys =
        { apikey = ""
        , wdApikey = RemoteData.NotAsked
        }
    , bs = modelAfterAPIKey.bs
    , bservers =
        { baseURL = C.initialBserver -- This is the base URL for the other API calls.
        , wdBserver = RemoteData.NotAsked
        }
    , categories = modelAfterAPIKey.categories
    , currencies = modelAfterAPIKey.currencies
    , distributions = modelAfterAPIKey.distributions
    , lint = modelAfterAPIKey.lint
    , report = modelAfterAPIKey.report
    , transactions = modelAfterAPIKey.transactions
    }



-- Initialize some fields of the model to reflect a new API Key


modelAfterAPIKey : ModelAfterAPIKey
modelAfterAPIKey =
    { accounts =
        { accounts = []
        , wdAccounts = RemoteData.NotAsked
        , wdAccount = RemoteData.NotAsked
        , editBuffer = emptyAccount
        , decimalPlaces = 2
        , rarityFilter = IntField (Just 10) "10"
        , distributionJoineds = []
        , wdDistributionJoineds = RemoteData.NotAsked
        }
    , acctcats =
        { acctcats = []
        , wdAcctcats = RemoteData.NotAsked
        , editBuffer = emptyAcctcat
        , category_id = -1
        }
    , bs =
        { category_idA = Nothing
        , distributionReportsA = []
        , wdDistributionReportsA = RemoteData.NotAsked

        , category_idEq = Nothing
        , distributionReportsEq = []
        , wdDistributionReportsEq = RemoteData.NotAsked

        , category_idEx = Nothing
        , distributionReportsEx = []
        , wdDistributionReportsEx = RemoteData.NotAsked

        , category_idL = Nothing
        , distributionReportsL = []
        , wdDistributionReportsL = RemoteData.NotAsked

        , category_idR = Nothing
        , distributionReportsR = []
        , wdDistributionReportsR = RemoteData.NotAsked

        , decimalPlaces = 2
        , omitZeros = False

        , form =
            { assetsCategory = ""
            , equityCategory = ""
            , expensesCategory = ""
            , liabilitiesCategory = ""
            , revenueCategory = ""
            , asofTime = ""
            }
            |> Form.View.idle
        , bsURLBase = ""
        }

    , categories =
        { categories = []
        , wdCategories = RemoteData.NotAsked
        , wdCategory = RemoteData.NotAsked
        , editBuffer = emptyCategory
        , rarityFilter = IntField (Just 10) "10"
        }
    , http_log = []
    , currencies =
        { currencies = []
        , wdCurrencies = RemoteData.NotAsked
        , wdCurrency = RemoteData.NotAsked
        , editBuffer = emptyCurrency
        , rarityFilter = IntField (Just 10) "10"
        }
    , distributions =
        { wdDistribution = RemoteData.NotAsked
        , editBuffer = emptyDistribution
        , distributionJoineds = []
        , wdDistributionJoineds = RemoteData.NotAsked
        , decimalPlaces = 2
        }
    , lint =
        { lints = []
        , wdLints = RemoteData.NotAsked
        , linter = ""
        }
    , report =
        { distributionReports = []
        , wdDistributionReports = RemoteData.NotAsked
        , decimalPlaces = 2
        , category_id = -1
        , omitZeros = False
        , startTime = ""
        , sof = Nothing
        , stopTime = ""
        , uiLevel = 0
        }
    , transactions =
        { transactions = []
        , wdTransactions = RemoteData.NotAsked
        , wdTransaction = RemoteData.NotAsked
        , editBuffer = emptyTransaction
        }
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        currentRoute =
            Routing.extractRoute url
    in
    case currentRoute of
        _ ->
            ( initialModel currentRoute key url, Cmd.none )
