The various API calls need a variety of contortions to work.

# Level A
In the simplest cases, we can use Http.send to send an Http.request with a suitable method and event to emit thereafter.

# Level B
Some of the calls use RemoteData, which supports four different states for the request.  Said states are NotAsked, Loading, Failure, and Success.  In the case of Success, although the server _might_ have returned error information, we _only expect_ a single usable format of information from the server and there are no expected error conditions to watch for.

This expectation guides the complexity of required decoders.   Nevertheless, if there _is_ any unexpected result format it can be detected, logged, flashed, or otherwise dealt with.

# Level C
In some cases we have more than one possible returned format.  In this case, we decode the RemoteData, "Success" response using a oneOf construct.

More specifically...

# Delete

Level A.  Fire 'n' forget.

# GetMany

Level B.  We want the display to show us "pending" until it has something to display.  Afterwards we can display "no items present" or a list of items.

# GetOne

Level C.  The request is pending until it succeeds.  After it succeeds we want to either display the results or an error message that we care about, such as "requested id not found."

# Post

Level C.  The request is pending until it succeeds. After it succeeds we want to either recover the id of the newly created object or any error messages.

# Patch

Level C.  The request is pending until it succeeds. After it succeeds we want to either recover the "message of success" or any error messages.
