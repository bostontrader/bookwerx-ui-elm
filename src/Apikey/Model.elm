module Apikey.Model exposing (Model)

import Apikey.Plumbing exposing (ApikeyPostHttpResponseString)
import RemoteData exposing (WebData)



-- apikey is the apikey to use with the bookwerx-core server.  It starts off set to "".  The user can edit this. wdApikey is the response our POSTed request to get an apikey.  If this is RemoteData.Success then we save the apikey for use with the other API calls.


type alias Model =
    { apikey : String
    , wdApikey : WebData ApikeyPostHttpResponseString
    }
