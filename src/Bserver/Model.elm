module Bserver.Model exposing (Model)

import Bserver.Plumbing exposing (BserverPingResponse)
import RemoteData exposing (WebData)



-- baseURL is the url for the bookwerx-core server.  It starts off set to a reasonable default, but the user can change it.
-- wdBserver is the response to pinging the baseURL.  If this is RemoteData.Success then we know the baseURL is ok for use with the other API calls.


type alias Model =
    { baseURL : String
    , wdBserver : WebData BserverPingResponse
    }
