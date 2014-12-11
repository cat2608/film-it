"use strict"

# -- DEPENDENCIES --------------------------------------------------------------
gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
flatten = require 'gulp-flatten'
header  = require 'gulp-header'
uglify  = require 'gulp-uglify'
gutil   = require 'gulp-util'
stylus  = require 'gulp-stylus'
pkg     = require './package.json'

# -- FILES ---------------------------------------------------------------------
assets = 'assets/'
source =
  coffee  : [ 'source/app.coffee'
              'source/app.*.coffee']
  styl    : [ 'bower_components/stylmethods/vendor.styl'
              'source/styles/__init.styl'
              'source/styles/page.styl'
              'source/styles/page.*.styl']

thirds =
    js   :[ 'bower_components/modernizr/modernizr.js'
            'bower_components/jquery/dist/jquery.js']

banner = [
  '/**'
  ' * <%= pkg.name %> - <%= pkg.description %>'
  ' * @version v<%= pkg.version %>'
  ' * @link    <%= pkg.homepage %>'
  ' * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)'
  ' * @license <%= pkg.license %>'
  ' */'
  ''].join('\n')

# -- TASKS ---------------------------------------------------------------------
gulp.task 'thirds', ->
  gulp.src(thirds.js)
    .pipe(concat(pkg.name + '.thirds.js'))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/js'))

gulp.task 'coffee', ->
  gulp.src(source.coffee)
    .pipe(concat(pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/js'))

gulp.task 'styl', ->
  gulp.src(source.styl)
    .pipe(concat(pkg.name + '.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/css'))

gulp.task 'init', ->
  gulp.run(['thirds', 'coffee', 'styl'])

gulp.task 'default', ->
  gulp.watch(source.coffee, ['coffee'])
  gulp.watch(source.styl, ['styl'])
