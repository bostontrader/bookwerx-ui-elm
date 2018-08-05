The various RESTful calls need a variety of contortions to work.

# REST Level A
In the simplest cases, we can use Http.send to send an Http.request with a suitable method and event to emit thereafter.

# REST Level B
Some of the calls use RemoteData, which supports four different states for the request.  Said states are NotAsked, Loading, Failure, and Success.

# REST Level C
When using RemoteData, "Success" means that the call successfully retrieved a result from the server.  But in some cases the result could be an error message that we care about.  So in addition to dealing with the four states of RemoteData, we also have more than one possible variation of a successful result that we care about.

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




