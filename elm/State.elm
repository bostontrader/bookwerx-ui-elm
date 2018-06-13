module State exposing (init, update)

import RemoteData exposing (WebData)

import Types exposing (Currency, CurrencyId, Model, Msg(..), Route)
--import Rest exposing (createPostCommand, deletePostCommand, fetchPostsCommand)
import Rest exposing (fetchCurrenciesCommand)

import Navigation exposing (Location)
import Routing exposing (extractRoute)
--import Debug
--import Misc exposing (findPostById)
--import Rest exposing (updatePostCommand, updatePostRequest)

tempCurrencyId =
    "-1"

emptyCurrency : Currency
emptyCurrency =
    Currency tempCurrencyId "" ""

initialModel : Route -> Model
initialModel route =
    { currencies = RemoteData.Loading
    , currentRoute = route
    , newCurrency = emptyCurrency
    }

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.extractRoute location
    in
        ( initialModel currentRoute, fetchCurrenciesCommand )

-- How can I test this?
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
    --case Debug.log "msg" msg of
        --FetchCurrencies ->
            --( { model | currencies = RemoteData.Loading }, fetchCurrenciesCommand )

        {-PostsReceived response ->
            ( { model | posts = response }, Cmd.none )

        LocationChanged location ->
            ( { model
                | currentRoute = Routing.extractRoute location
              }
            , Cmd.none
            )

        UpdateTitle postId newTitle ->
            let
                updatedPosts =
                    updateTitle postId newTitle model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorName postId newName ->
            let
                updatedPosts =
                    updateAuthorName postId newName model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        UpdateAuthorUrl postId newUrl ->
            let
                updatedPosts =
                    updateAuthorUrl postId newUrl model
            in
                ( { model | posts = updatedPosts }, Cmd.none )

        SubmitUpdatedPost postId ->
            case findPostById postId model.posts of
                Just post ->
                    ( model, updatePostCommand post )

                Nothing ->
                    ( model, Cmd.none )

        PostUpdated _ ->
            ( model, Cmd.none )

        DeletePost postId ->
            case findPostById postId model.posts of
                Just post ->
                    ( model, deletePostCommand post )

                Nothing ->
                    ( model, Cmd.none )

        PostDeleted _ ->
            ( model, fetchPostsCommand )

        NewPostTitle newTitle ->
            let
                updatedNewPost =
                    setTitle newTitle model.newPost
            in
                ( { model | newPost = updatedNewPost }, Cmd.none )

        NewAuthorName newName ->
            let
                updatedNewPost =
                    setAuthorName newName model.newPost
            in
                ( { model | newPost = updatedNewPost }, Cmd.none )

        NewAuthorUrl newUrl ->
            let
                updatedNewPost =
                    setAuthorUrl newUrl model.newPost
            in
                ( { model | newPost = updatedNewPost }, Cmd.none )

        CreateNewPost ->
            ( model, createPostCommand model.newPost )

        PostCreated (Ok post) ->
            ( { model
                | posts = addNewPost post model.posts
                , newPost = emptyPost
              }
            , Cmd.none
            )

        PostCreated (Err _) ->
            ( model, Cmd.none ) -}

{-addNewPost : Post -> WebData (List Post) -> WebData (List Post)
addNewPost newPost posts =
    let
        appendPost : List Post -> List Post
        appendPost listOfPosts =
            List.append listOfPosts [ newPost ]
    in
        RemoteData.map appendPost posts

setTitle : String -> Post -> Post
setTitle newTitle post =
    { post | title = newTitle }


setAuthorName : String -> Post -> Post
setAuthorName newName post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | name = newName } }


setAuthorUrl : String -> Post -> Post
setAuthorUrl newUrl post =
    let
        oldAuthor =
            post.author
    in
        { post | author = { oldAuthor | url = newUrl } }

updateTitle : PostId -> String -> Model -> WebData (List Post)
updateTitle postId newTitle model =
    let
        updatePost post =
            if post.id == postId then
                { post | title =  Debug.log "newTitle: " newTitle }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts

map : (a -> b) -> RemoteData e a -> RemoteData e b
map f data =
    case data of
        Success value ->
            Success (f value)

        Loading ->
            Loading

        NotAsked ->
            NotAsked

        Failure error ->
            Failure error

type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


updateAuthorName : PostId -> String -> Model -> WebData (List Post)
updateAuthorName postId newName model =
    let
        updatePost post =
            if post.id == postId then
                let
                    oldAuthor =
                        post.author
                in
                    { post | author = { oldAuthor | name = newName } }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts


updateAuthorUrl : PostId -> String -> Model -> WebData (List Post)
updateAuthorUrl postId newUrl model =
    let
        updatePost post =
            if post.id == postId then
                let
                    oldAuthor =
                        post.author
                in
                    { post | author = { oldAuthor | url = newUrl } }
            else
                post

        updatePosts posts =
            List.map updatePost posts
    in
        RemoteData.map updatePosts model.posts

-}