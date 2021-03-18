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
import Report.Model exposing (ReportTypes(..))
import Report.Report exposing (SumsDecorated)
import Route exposing (Route(..))
import Routing exposing (extractRoute)
import Time
import Transaction.Transaction exposing (Transaction)
import Types exposing (DRCR(..))
import Url


emptyAccount : Account
emptyAccount =
    Account -1 "" -1 ""


emptyAcctcat : Acctcat
emptyAcctcat =
    Acctcat -1 "" -1 -1


emptyCategory : Category
emptyCategory =
    Category -1 "" "" ""


emptyCurrency : Currency
emptyCurrency =
    Currency -1 "" "" ""


emptyDistribution : DistributionEB
emptyDistribution =
    DistributionEB -1 "" -1 -1 -1 (IntField (Just 0) "0") "" (IntField (Just 0) "0") -1 DR


emptyTransaction : Transaction
emptyTransaction =
    Transaction -1 "" "" ""


initialModel : Route -> Nav.Key -> Url.Url -> Model.Model
initialModel route key url =
    { currentRoute = route
    , currentTime = Time.millisToPosix 0
    , drcr_format = C.initialDRCRFormat
    , flashMessages = []
    --, http_log = modelAfterAPIKey.http_log
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
        , distributionJoineds = []
        , wdDistributionJoineds = RemoteData.NotAsked
        }
    , acctcats =
        { acctcats = []
        , wdAcctcats = RemoteData.NotAsked
        , editBuffer = emptyAcctcat
        , category_id = -1
        }
    , categories =
        { categories = []
        , wdCategories = RemoteData.NotAsked
        , wdCategory = RemoteData.NotAsked
        , editBuffer = emptyCategory
        }
    --, http_log = []
    , currencies =
        { currencies = []
        , wdCurrencies = RemoteData.NotAsked
        , wdCurrency = RemoteData.NotAsked
        , editBuffer = emptyCurrency
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
        { distributionReports = SumsDecorated []
        , wdDistributionReports = RemoteData.NotAsked
        , distributionReportsA = SumsDecorated []
        , wdDistributionReportsA = RemoteData.NotAsked
        , distributionReportsEq = SumsDecorated []
        , wdDistributionReportsEq = RemoteData.NotAsked
        , distributionReportsEx = SumsDecorated []
        , wdDistributionReportsEx = RemoteData.NotAsked
        , distributionReportsL = SumsDecorated []
        , wdDistributionReportsL = RemoteData.NotAsked
        , distributionReportsR = SumsDecorated []
        , wdDistributionReportsR = RemoteData.NotAsked
        , decimalPlaces = 2
        , omitZeros = False
        , form =
            { category = ""
            , categoryAssets = ""
            , categoryEquity = ""
            , categoryExpenses = ""
            , categoryLiabilities = ""
            , categoryRevenue = ""
            , reportType = ""
            , startTime = ""
            , stopTime = ""
            , title = ""

            --, equityCategory = ""
            --, expensesCategory = ""
            --, liabilitiesCategory = ""
            --, revenueCategory = ""
            }
                |> Form.View.idle
        , reportType = Nothing
        , reportURLBase = ""
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
