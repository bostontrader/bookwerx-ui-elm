module Msg exposing (Msg(..))

import Account.MsgB as Account
import Acctcat.MsgB as Acctcat
import Apikey.MsgB as Apikey
import Browser
import Bserver.MsgB as Bserver
import Category.MsgB as Category
import Currency.MsgB as Currency
import Distribution.MsgB as Distribution
import Lint.MsgB as Lint
import Report.Msg as Report
import Time exposing (Posix)
import Transaction.MsgB as Transaction
import Url


type Msg
    = AccountMsgA Account.MsgB
    | AcctcatMsgA Acctcat.MsgB
    | ApikeyMsgA Apikey.MsgB
    | BserverMsgA Bserver.MsgB
    | CategoryMsgA Category.MsgB
    | ClearHttpLog
    | CurrencyMsgA Currency.MsgB
    | DistributionMsgA Distribution.MsgB
    | LinkClicked Browser.UrlRequest
    | LintMsgA Lint.MsgB
    | Report Report.Msg
    | SetDRCRFormat String
    | SetLanguage String
    | TimeoutFlashElements Posix
      -- | ToggleTutorialStatus
    | TransactionMsgA Transaction.MsgB
    | UpdateCurrentTime Posix
    | UrlChanged Url.Url
