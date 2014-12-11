"use strict"

jQuery(document).ready ($) ->

  showProductIntro = ->
    $("header").removeClass "slide-down"
    $("article").removeClass "is-product-tour"

  updateSlider = (active, direction) ->
    selected = undefined
    if direction is "next"
      selected = active.next()
      setTimeout (->
        active.removeClass("cd-active").addClass("cd-hidden").next().removeClass("cd-move-right").addClass("cd-active").one "webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend", ->
          active.addClass "cd-not-visible"
      ), 50
    else
      selected = active.prev()
      setTimeout (->
        active.removeClass("cd-active").addClass("cd-move-right").prev().addClass("cd-active").one "webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend", ->
          active.addClass "cd-not-visible"
      ), 50
    selected.removeClass "cd-not-visible"
    updateSliderNav selected

  updateSliderNav = (selected) ->
    (if (selected.is(":last-child")) then $(".cd-next").addClass("cd-inactive") else $(".cd-next").removeClass("cd-inactive"))


  MqL = 1070
  $("a[href=\"#cd-product-tour\"]").on "click", (event) ->
    event.preventDefault()
    $("header").addClass "slide-down"
    if $(window).width() < MqL
      $("body,html").animate
        scrollTop: $("#cd-product-tour").offset().top - 30
      , 200
    else
      $("article").addClass "is-product-tour"

  $(".cd-prev").on "click", (event) ->
    event.preventDefault()
    activeSlide = $(".cd-active")
    if activeSlide.is(":first-child")
      showProductIntro()
    else
      updateSlider activeSlide, "prev"

  $(".cd-next").on "click", (event) ->
    event.preventDefault()
    activeSlide = $(".cd-active")
    updateSlider activeSlide, "next"

  $(document).keyup (event) ->
    if event.which is "37" and $("article").hasClass("is-product-tour")
      activeSlide = $(".cd-active")
      if activeSlide.is(":first-child")
        showProductIntro()
      else
        updateSlider activeSlide, "prev"
    else if event.which is "39" and $("article").hasClass("is-product-tour")
      activeSlide = $(".cd-active")
      updateSlider activeSlide, "next"

  $(window).on "resize", ->
    window.requestAnimationFrame ->
      if $(window).width() < MqL
        $(".cd-single-item").each ->
          $(this).find("img").css("opacity", 1).end()
      else
        (if ($("article").hasClass("is-product-tour")) then $("header").addClass("slide-down") else $("header").removeClass("slide-down"))

  $(window).on "scroll", ->
    window.requestAnimationFrame ->
      if $(window).width() < MqL and $(window).scrollTop() < $("#cd-product-tour").offset().top - 30
        $("header").removeClass "slide-down"
      else $("header").addClass "slide-down"  if $(window).width() < MqL and $(window).scrollTop() >= $("#cd-product-tour").offset().top - 30
