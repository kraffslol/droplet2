'use strict';


var kraken = require('kraken-js'),
	express = require('express'),
    fs = require('fs'),
    path = require('path'),
    sqlite3 = require('sqlite3').verbose(),
    app = {};


app.configure = function configure(nconf, next) {
    // Fired when an app configures itself
    var file = path.dirname(process.mainModule.filename) + '/db/droplet.sqlite3';
    var exists = fs.existsSync(file);
    if(!exists) {
        console.log('Creating DB file.');
        fs.openSync(file, 'w');

        var db = new sqlite3.Database(file);
        db.serialize(function() {
            db.run('CREATE TABLE IF NOT EXISTS Files ( id integer PRIMARY KEY, slug varchar(7), filename varchar(255), views integer )');
        });

        db.close();
    }

    next(null);
};


app.requestStart = function requestStart(server) {
    // Fired at the beginning of an incoming request
};


app.requestBeforeRoute = function requestBeforeRoute(server) {
    // Fired before routing occurs
    server.use(express.limit('10mb'));
    server.use(express.methodOverride());
};


app.requestAfterRoute = function requestAfterRoute(server) {
    // Fired after routing occurs
};


kraken.create(app).listen(function (err) {
    if (err) {
        console.error(err);
    }
});
