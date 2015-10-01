module.exports = function(grunt) {
  grunt.initConfig({
    uglify: {
      options: {
        sourceMap: true
      },
      all: {
        files: {
          'public/js/dist/ollert.min.js': 'public/js/*.js',
          'public/js/dist/vendor.min.js': 'public/js/vendor/*.js'
        }
      }
    },
    sass: {
      options: {
        style: 'compressed',
        precision: 5
      },
      all: {
        files: {
          'public/css/styles.css': 'public/css/styles.scss'
        }
      }
    },
    watch: {
      javascript: {
        files: 'public/js/*.js',
        tasks: ['uglify']
      },
      sass: {
        files: 'public/css/*.scss',
        tasks: 'sass'
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-sass');
};
