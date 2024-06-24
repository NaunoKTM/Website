module Pages.Home_ exposing (..)

import Browser exposing (..)
import Browser.Dom
import Browser.Events
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Html.Attributes exposing (href, wrap)
import Html.Events exposing (on)
import Layouts
import Layouts.Header exposing (header)
import Page exposing (Page)
import Route exposing (Route)
import Shared exposing (Model)
import Task
import View exposing (View)



-- MODEL


type alias Model =
    { screenHeight : Int
    , screenWidth : Int
    , device : Device
    }


type Device
    = Phone
    | Tablet
    | Desktop
    | BigDesktop



-- MESSAGES


type Msg
    = GotWindowSize { height : Int, width : Int }



-- UPDATE


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotWindowSize viewPort ->
            ( { model
                | device = classifyDevice viewPort
                , screenHeight = viewPort.height
                , screenWidth = viewPort.width
              }
            , Effect.none
            )


classifyDevice : { height : Int, width : Int } -> Device
classifyDevice { height, width } =
    if width < 600 then
        Phone

    else if width < 900 then
        Tablet

    else if width < 1200 then
        Desktop

    else
        BigDesktop



-- VIEW


view : Model -> View Msg
view model =
    { title = "Home"
    , body =
        [ Html.text "lol"
        ]
    }



-- page : View msg


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
        |> Page.withLayout toLayout


{-| Use the sidebar layout on this page
-}
toLayout : Model -> Layouts.Layout Msg
toLayout model =
    Layouts.Header {}


init : () -> ( Model, Effect msg )
init _ =
    ( { screenHeight = 0
      , screenWidth = 0
      , device = Phone
      }
    , Effect.none
    )


homePage : Model -> Element Msg
homePage model =
    column
        [ spacing 30
        , width fill
        , Background.color (rgb255 255 255 255)
        , Border.width 1
        , Border.color (rgb255 200 200 200)
        , centerX
        ]
        [ el
            [ Font.size 32
            , Font.bold
            , Font.color (rgb255 50 50 50)
            , centerX
            ]
            (text "Gallerie Plxm")
        , Element.image
            [ width (maximum 935 fill)
            , height (px 300)
            , Border.width 1
            , Border.color (rgb255 200 200 200)
            , centerX
            ]
            { src = "/public/gal.jpg"
            , description = "Main Gallery Image"
            }
        , gridContainer
        ]


gridContainer : Element Msg
gridContainer =
    el
        [ width fill
        , padding 10
        ]
        (Element.wrappedRow
            [ spacing 10
            , width fill
            , centerX
            ]
            (List.map thumbnailImage
                [ "/public/shark.jpeg"
                , "/public/pinguins.jpeg"
                , "/public/seahorse.jpeg"
                , "/public/nemo.jpeg"
                , "/public/lezard.jpg"
                , "/public/frog.jpeg"
                , "/public/jellyfish.jpeg"
                , "/public/weirdfish.jpeg"
                , "/public/coral.jpeg"
                , "/public/weirdseahorse.jpeg"
                ]
            )
        )



-- (text label)


thumbnailImage : String -> Element Msg
thumbnailImage src =
    Element.image
        [ width (px 150)
        , height (px 200)
        , Border.color (rgb255 200 200 200)
        , Background.color (rgb255 255 255 255)
        ]
        { src = src
        , description = "Gallery Thumbnail"
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize (\w h -> GotWindowSize { height = h, width = w })
