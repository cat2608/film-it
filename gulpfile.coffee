"use strict"

# -- DEPENDENCIES --------------------------------------------------------------
gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
connect = require 'gulp-connect'
flatten = require 'gulp-flatten'
header  = require 'gulp-header'
uglify  = require 'gulp-uglify'
gutil   = require 'gulp-util'
stylus  = require 'gulp-stylus'
yml     = require 'gulp-yml'
pkg     = require './package.json'

# -- FILES ---------------------------------------------------------------------
www =
  coffee    : [ 'source/www/app.coffee'
                'source/www/app.*.coffee']
  styl      : [ 'bower_components/stylmethods/vendor.styl'
                'source/www/style/__init.styl'
                'source/www/style/page.styl'
                'source/www/style/page.*.styl']
  thirds:
    js      : [ 'bower_components/modernizr/modernizr.js'
                'bower_components/jquery/dist/jquery.js']
  assets    : 'assets/'

app =
  coffee    : [ 'source/app/atom/*.coffee'
                'source/app/molecule/*.coffee'
                'source/app/organism/*.coffee'
                'source/app/entity/*.coffee'
                'source/app/app.coffee'
                'source/app/app.*.coffee']
  styl      : [ 'source/app/style/__init.styl'
                'source/app/style/__vendor.styl'
                'source/app/style/app.styl'
                'source/app/style/atom.*.styl'
                'source/app/style/molecule.*.styl'
                'source/app/style/organism.*.styl'
                'source/app/style/app.*.styl']
  yml       : [ 'source/app/organism/*.yml']
  thirds:
    js      : [ 'bower_components/hope/hope.js',
                'bower_components/atoms/atoms.js',
                'bower_components/atoms/atoms.app.js']
    css     : [ 'bower_components/atoms/atoms.app.css',
                'bower_components/atoms-icons/atoms.icons.css',]

  third_js  : [ 'bower_components/hope/hope.js',
                'bower_components/atoms/atoms.js',
                'bower_components/atoms/atoms.app.js']
  third_css : [ 'bower_components/atoms/atoms.app.css',
                'bower_components/atoms-icons/atoms.icons.css',]
  assets      : 'assets/app/assets'

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
  # WWW
  for key, value of www.thirds
    gulp.src(value)
      .pipe(concat('film-it.thirds.' + key))
      .pipe(gulp.dest(www.assets + '/' + key))
  # APP
  for key, value of app.thirds
    gulp.src(value)
      .pipe(concat('atoms.' + key))
      .pipe(gulp.dest(app.assets + '/' + key))


gulp.task 'coffee', ->
  gulp.src(www.coffee)
    .pipe(concat(pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(www.assets + '/js'))
  gulp.src(app.coffee)
    .pipe(concat('atoms.' + pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(app.assets + '/js'))
    .pipe(connect.reload())

gulp.task 'styl', ->
  gulp.src(www.styl)
    .pipe(concat(pkg.name + '.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(www.assets + '/css'))
  gulp.src(app.styl)
    .pipe(concat('atoms.' + pkg.name + '.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(app.assets + '/css'))
    .pipe(connect.reload())

gulp.task 'yml', ->
  gulp.src(app.yml)
    .pipe(yml().on('error', gutil.log))
    .pipe(gulp.dest(app.assets + '/scaffold'))
    .pipe(connect.reload())

gulp.task 'webserver', ->
  connect.server
    port: 8000, root: 'assets/app/', livereload: true

gulp.task 'init', ->
  gulp.run(['thirds', 'coffee', 'styl', 'yml'])

gulp.task 'default', ->
  gulp.run(['webserver'])
  gulp.watch(www.coffee, ['coffee'])
  gulp.watch(www.styl, ['styl'])
  gulp.watch(app.coffee, ['coffee'])
  gulp.watch(app.styl, ['styl'])
  gulp.watch(app.yml, ['yml'])
