"use strict"

jQuery(document).ready ($) ->

  showProductIntro = ->
    $("header").removeClass "slide-down"
    $("article").removeClass "in-tour"

  updateSlider = (active, direction) ->
    selected = undefined
    if direction is "next"
      selected = active.next()
      setTimeout (->
        active.removeClass("active").addClass("hidden").next().removeClass("move-right").addClass("active").one "webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend", ->
          active.addClass "not-visible"
      ), 50
    else
      selected = active.prev()
      setTimeout (->
        active.removeClass("active").addClass("move-right").prev().addClass("active").one "webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend", ->
          active.addClass "not-visible"
      ), 50
    selected.removeClass "not-visible"
    updateSliderNav selected

  updateSliderNav = (selected) ->
    (if (selected.is(":last-child")) then $(".next").addClass("inactive") else $(".next").removeClass("inactive"))


  MqL = 1070
  $("a[href=\"#tour\"]").on "click", (event) ->
    event.preventDefault()
    $("header").addClass "slide-down"
    if $(window).width() < MqL
      $("body,html").animate
        scrollTop: $("#tour").offset().top - 30
      , 200
    else
      $("article").addClass "in-tour"

  $(".prev").on "click", (event) ->
    event.preventDefault()
    activeSlide = $(".active")
    if activeSlide.is(":first-child")
      showProductIntro()
    else
      updateSlider activeSlide, "prev"

  $(".next").on "click", (event) ->
    event.preventDefault()
    activeSlide = $(".active")
    updateSlider activeSlide, "next"

  $(document).keyup (event) ->
    if event.which is "37" and $("article").hasClass("in-tour")
      activeSlide = $(".active")
      if activeSlide.is(":first-child")
        showProductIntro()
      else
        updateSlider activeSlide, "prev"
    else if event.which is "39" and $("article").hasClass("in-tour")
      activeSlide = $(".active")
      updateSlider activeSlide, "next"

  $(window).on "resize", ->
    window.requestAnimationFrame ->
      if $(window).width() < MqL
        $(".step").each ->
          $(this).find("img").css("opacity", 1).end()
      else
        (if ($("article").hasClass("in-tour")) then $("header").addClass("slide-down") else $("header").removeClass("slide-down"))

  $(window).on "scroll", ->
    window.requestAnimationFrame ->
      if $(window).width() < MqL and $(window).scrollTop() < $("#tour").offset().top - 30
        $("header").removeClass "slide-down"
      else $("header").addClass "slide-down"  if $(window).width() < MqL and $(window).scrollTop() >= $("#tour").offset().top - 30
