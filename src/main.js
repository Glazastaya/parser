/*global require*/
'use strict';

// Require.js allows us to configure shortcut alias
require.config({
    // The shim config allows us to configure dependencies for
    // scripts that do not call define() to register a module
    //baseUrl: '../parser/',
    shim: {
        //underscore: {
        //    exports: '_'
        //},
        jquery: {
            exports: 'jquery'
        }
    },
    paths: {
        jquery: '../node_modules/jquery/jquery-1.11.2.min',
        underscore: '../node_modules/underscore/underscore-min',
        jade: '../node_modules/jade/jade',
        lodash: '../bower_components/lodash/lodash'
    }
});

require(["app"],function(app) {
        app.init()
    });