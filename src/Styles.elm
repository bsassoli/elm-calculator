module Styles exposing (..)
import Css exposing (..)


body : List Style
body =
    [ backgroundImage (url "https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=824&q=80")
    , textAlign center
    , fontFamilies [ "Montserrat", "sans-serif" ]
    ]


container : List Style
container =
    [ boxShadow4 (px 0) (px 4) (px 30) (rgba 0 0 0 0.1)
    , property "-webkit-backdrop-filter" "blur(10px)"
    , property "backdropFilter" "blur (10px))"
    , border3 (em 1.1) solid (rgba 255 255 255 0.03)
    , width (px 320)
    , height (px 550)
    , borderRadius (em 0.5)
    , margin2 (px 0) auto
    , padding2 (px 32) (px 16)
    , displayFlex
    , flexDirection column
    , justifyContent spaceBetween
    ]

result : List Style
result = [
    width (pc 100)
  , height (px 150)
    ]

par = [
    fontSize (pt 45)
    , overflowY auto
    , textAlign right
    ]