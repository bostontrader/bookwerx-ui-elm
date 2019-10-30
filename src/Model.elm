module Model exposing (Model, ModelAfterAPIKey, ModelBeforeAPIKey)

import Account.Model
import Acctcat.Model
import Apikey.Model
import Browser.Navigation as Nav
import Bserver.Model
import Category.Model
import Currency.Model
import Distribution.Model
import Flash exposing (FlashMsg)
import Lint.Model
import Report.Model
import Route exposing (Route)
import Time exposing (Posix)
import Transaction.Model
import Translate exposing (Language)
import Types exposing (DRCRFormat(..))
import Url


type alias Model =
  { accounts : Account.Model.Model
  , acctcats : Acctcat.Model.Model
  , apikeys : Apikey.Model.Model
  , bservers : Bserver.Model.Model
  , categories : Category.Model.Model
  , currencies : Currency.Model.Model
  , distributions : Distribution.Model.Model
  , currentRoute : Route
  , currentTime : Posix
  , drcr_format : DRCRFormat
  , key : Nav.Key -- needed for navigation
  , lint : Lint.Model.Model
  , flashMessages : List FlashMsg
  , http_log : List String
  , language : Language
  , report : Report.Model.Model
  , transactions : Transaction.Model.Model
  , tutorialActive : Bool
  , tutorialLevel : Int
  , url : Url.Url -- needed for navigation
  }


-- If the API Key changes, reset these fields
type alias ModelAfterAPIKey =
  { accounts : Account.Model.Model
  , acctcats : Acctcat.Model.Model
  , categories : Category.Model.Model
  , currencies : Currency.Model.Model
  , distributions : Distribution.Model.Model
  , http_log : List String
  , lint : Lint.Model.Model
  , report : Report.Model.Model
  , transactions : Transaction.Model.Model
  }


-- If the API Key changes, don't touch any of these fields
type alias ModelBeforeAPIKey =
  { apikeys : Apikey.Model.Model
  , bservers : Bserver.Model.Model
  , currentRoute : Route
  , currentTime : Posix
  , drcr_format : DRCRFormat
  , key : Nav.Key -- needed for navigation
  , flashMessages : List FlashMsg
  , language : Language
  , tutorialActive : Bool
  , tutorialLevel : Int
  , url : Url.Url -- needed for navigation
  }
