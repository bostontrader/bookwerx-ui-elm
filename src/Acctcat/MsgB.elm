module Acctcat.MsgB exposing (MsgB(..))

--import Acctcat.Acctcat exposing (Acctcat)
import Acctcat.Plumbing exposing( AcctcatPostHttpResponseString)
import RemoteData exposing (WebData)


type
    MsgB
    -- delete
    = DeleteAcctcat String -- url
    | AcctcatDeleted (WebData String)
      -- getMany
    | GetManyAcctcats Int String
    | AcctcatsReceived (WebData String)

      -- post
    | PostAcctcat String String String -- url content-type body
    | AcctcatPosted (WebData AcctcatPostHttpResponseString)
      -- edit
    | UpdateAccountID String
