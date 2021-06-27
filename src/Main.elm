module Main exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, disabled)
import Html.Events
import List exposing (maximum, minimum)
import Svg
import Svg.Attributes



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { value : Float
    , maximunCounter : Float
    , minimunCounter : Float
    , maximunAngle : Float
    , minimunAngle : Float
    , step : Float
    }


initialModel : Model
initialModel =
    { value = 0
    , maximunCounter = 20
    , minimunCounter = 0
    , maximunAngle = 330
    , minimunAngle = 30
    , step = 1
    }


toDegrees : Model -> Float
toDegrees model =
    ((model.value - model.minimunCounter) * ((model.maximunAngle - model.minimunAngle) / (model.maximunCounter - model.minimunCounter))) + model.minimunAngle



-- UPDATE


type Msg
    = Increase
    | Decrease
    | SetStep Float
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increase ->
            if model.value + model.step <= model.maximunCounter then
                { model | value = model.value + model.step }

            else
                { model | value = model.maximunCounter }

        Decrease ->
            if model.value - model.step >= model.minimunCounter then
                { model | value = model.value - model.step }

            else
                { model | value = model.minimunCounter }

        SetStep ammount ->
            { model | step = ammount }

        Reset ->
            { model
                | value = model.minimunCounter
                , step = 1
            }



-- VIEW


{-| View
...
-}
view : Model -> Html Msg
view model =
    div
        [ class "flex flex-col items-center p-20 space-y-4 " ]
        [ div
            [ class "flex justify-center" ]
            [ viewDial (toDegrees model) ]
        , div
            [ class "h-42 w-52 p-2  shadow bg-white rounded-lg " ]
            [ div
                [ class "flex items-center sm:p-2" ]
                [ div
                    [ class "px-2 font-black" ]
                    [ text "Value" ]
                , Html.button
                    [ class "px-2 py-1 flex-auto bg-gray-300 font-medium disabled:opacity-20 active:bg-gray-500 hover:bg-gray-400 focus:outline-none  "
                    , Html.Events.onClick Decrease
                    , disabled (model.value == model.minimunCounter)
                    ]
                    [ text "-" ]
                , div
                    [ class "text-center flex-auto border-4  border-gray-300  font-black w-16  " ]
                    [ text <| String.fromFloat model.value ]
                , Html.button
                    [ class "px-2 py-1 flex-auto  bg-gray-300 font-medium disabled:opacity-20 active:bg-gray-500 hover:bg-gray-400 focus:outline-none  "
                    , Html.Events.onClick Increase
                    , disabled (model.value == model.maximunCounter)
                    ]
                    [ text "+" ]
                ]
            , div
                [ class "flex justify-left items-center sm:px-2 " ]
                [ div
                    [ class "px-3 font-black" ]
                    [ text "Step" ]
                , Html.button
                    [ class "px-3 py-1 flex-1 bg-gray-200 font-medium hover:bg-gray-300 focus:outline-none"
                    , Html.Events.onClick (SetStep 1)
                    , Html.Attributes.classList [ ( "bg-gray-500 text-white hover:bg-gray-500", model.step == 1 ) ]
                    ]
                    [ text "1" ]
                , Html.button
                    [ class "px-3 py-1 flex-1 bg-gray-200 font-medium hover:bg-gray-300 focus:outline-none"
                    , Html.Events.onClick (SetStep 0.5)
                    , Html.Attributes.classList [ ( "bg-gray-500 text-white hover:bg-gray-500", model.step == 0.5 ) ]
                    ]
                    [ text "½" ]
                , Html.button
                    [ class "px-3 py-1  flex-1 bg-gray-200 font-medium hover:bg-gray-300 focus:outline-none"
                    , Html.Events.onClick (SetStep 0.25)
                    , Html.Attributes.classList [ ( "bg-gray-500 text-white hover:bg-gray-500", model.step == 0.25 ) ]
                    ]
                    [ text "¼" ]
                ]
            , div
                [ class "flex justify-center items-center sm:p-2" ]
                [ Html.button
                    [ class "px-2 py-1 flex-auto rounded active:bg-gray-400 bg-gray-200 font-medium hover:bg-gray-300 focus:outline-none"
                    , Html.Events.onClick Reset
                    ]
                    [ text "Reset" ]
                ]
            ]
        ]


viewDial : Float -> Html msg
viewDial angle =
    div
        []
        [ Svg.svg
            [ Svg.Attributes.width "153"
            , Svg.Attributes.height "181"
            , Svg.Attributes.fill "none"
            ]
            [ -- Lines
              Svg.path
                [ Svg.Attributes.d "M43.933 48.19l-10-17.32M106.933 48.69l10-17.32"

                -- Se puede cambiar el color
                , Svg.Attributes.stroke "#000"
                ]
                []

            -- Dial circle
            , Svg.g
                [ Svg.Attributes.transform <| "rotate(" ++ String.fromFloat angle ++ " 75 103)" ]
                [ Svg.circle
                    [ Svg.Attributes.cx "75"
                    , Svg.Attributes.cy "103"
                    , Svg.Attributes.r "75"

                    -- Se puede cambiar el color
                    , Svg.Attributes.fill "#9C9C9C"
                    ]
                    []
                , Svg.path
                    [ Svg.Attributes.d "M75 31.922L88.235 55.45h-26.47L75 31.921z"

                    -- Se puede cambiar el color
                    , Svg.Attributes.fill "#C4C4C4"
                    ]
                    []
                ]

            -- Text
            , Svg.path
                [ Svg.Attributes.d "M110.936 28v-6.24h1.308v1.032h.06c.064-.16.14-.312.228-.456.096-.144.208-.268.336-.372.136-.112.292-.196.468-.252.184-.064.396-.096.636-.096.424 0 .8.104 1.128.312.328.208.568.528.72.96h.036c.112-.352.328-.652.648-.9s.732-.372 1.236-.372c.624 0 1.108.212 1.452.636.344.416.516 1.012.516 1.788V28H118.4v-3.804c0-.48-.092-.84-.276-1.08-.184-.248-.476-.372-.876-.372-.168 0-.328.024-.48.072-.152.04-.288.104-.408.192-.112.088-.204.2-.276.336a.985.985 0 00-.108.468V28h-1.308v-3.804c0-.968-.38-1.452-1.14-1.452-.16 0-.32.024-.48.072-.152.04-.288.104-.408.192a.977.977 0 00-.288.336.985.985 0 00-.108.468V28h-1.308zm11.242-7.356c-.272 0-.472-.064-.6-.192a.69.69 0 01-.18-.492v-.204c0-.2.06-.364.18-.492.128-.128.328-.192.6-.192.272 0 .468.064.588.192a.69.69 0 01.18.492v.204c0 .2-.06.364-.18.492s-.316.192-.588.192zm-.66 1.116h1.308V28h-1.308v-6.24zm3.176 6.24v-6.24h1.308v1.032h.06a2.08 2.08 0 01.612-.84c.28-.224.66-.336 1.14-.336.64 0 1.136.212 1.488.636.36.416.54 1.012.54 1.788V28h-1.308v-3.792c0-.976-.392-1.464-1.176-1.464-.168 0-.336.024-.504.072a1.32 1.32 0 00-.432.192c-.128.088-.232.2-.312.336a1.012 1.012 0 00-.108.48V28h-1.308zM21.936 28v-6.24h1.308v1.032h.06c.064-.16.14-.312.228-.456.096-.144.208-.268.336-.372.136-.112.292-.196.468-.252.184-.064.396-.096.636-.096.424 0 .8.104 1.128.312.328.208.568.528.72.96h.036c.112-.352.328-.652.648-.9s.732-.372 1.236-.372c.624 0 1.108.212 1.452.636.344.416.516 1.012.516 1.788V28H29.4v-3.804c0-.48-.092-.84-.276-1.08-.184-.248-.476-.372-.876-.372-.168 0-.328.024-.48.072-.152.04-.288.104-.408.192-.112.088-.204.2-.276.336a.985.985 0 00-.108.468V28h-1.308v-3.804c0-.968-.38-1.452-1.14-1.452-.16 0-.32.024-.48.072-.152.04-.288.104-.408.192a.977.977 0 00-.288.336.985.985 0 00-.108.468V28h-1.308zm15.154 0c-.344 0-.608-.096-.792-.288a1.344 1.344 0 01-.336-.756h-.06c-.12.392-.34.688-.66.888-.32.2-.708.3-1.164.3-.648 0-1.148-.168-1.5-.504-.344-.336-.516-.788-.516-1.356 0-.624.224-1.092.672-1.404.456-.312 1.12-.468 1.992-.468h1.128v-.528c0-.384-.104-.68-.312-.888-.208-.208-.532-.312-.972-.312-.368 0-.668.08-.9.24-.232.16-.428.364-.588.612l-.78-.708c.208-.352.5-.64.876-.864.376-.232.868-.348 1.476-.348.808 0 1.428.188 1.86.564.432.376.648.916.648 1.62v3.132h.66V28h-.732zm-2.64-.852c.408 0 .744-.088 1.008-.264.264-.184.396-.428.396-.732v-.9H34.75c-.904 0-1.356.28-1.356.84v.216c0 .28.092.492.276.636.192.136.452.204.78.204zm3.958.852l2.196-3.156-2.136-3.084h1.512l1.404 2.172h.036l1.44-2.172h1.392l-2.136 3.072L44.288 28h-1.512l-1.44-2.268H41.3L39.8 28h-1.392z"

                -- Se puede cambiar el color
                , Svg.Attributes.fill "#000"
                ]
                []
            ]
        ]
