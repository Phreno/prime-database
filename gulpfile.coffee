gulp=require 'gulp'
coffee=require 'gulp-coffee'

gulp.task 'compile-coffee', ->
  src="#{__dirname}/src/**/*.coffee"
  console.log src
  gulp.src(src)
    .pipe(coffee({bare:true}))
    .pipe(gulp.dest "#{__dirname}/public")
    #.on 'error', gutil.log
