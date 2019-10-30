module Msg exposing (Msg(..))

import Account.MsgB as Account
import Acctcat.MsgB as Acctcat
import Apikey.MsgB as Apikey
import Bserver.MsgB as Bserver
import Category.MsgB as Category
import Currency.MsgB as Currency
import Distribution.MsgB as Distribution
import Lint.MsgB as Lint
import Report.MsgB as Report
import Time exposing (Posix)
import Transaction.MsgB as Transaction

import Browser
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
    | ReportMsgA Report.MsgB
    | SetDRCRFormat String
    | SetLanguage String
    | TimeoutFlashElements Posix
    -- | ToggleTutorialStatus
    | TransactionMsgA Transaction.MsgB
    | UpdateCurrentTime Posix
    | UrlChanged Url.Url
