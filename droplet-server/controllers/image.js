'use strict';
var sqlite3 = require('sqlite3').verbose(),
	path = require('path'),
	nconf = require('nconf');


module.exports = function (server) {

    server.get('/image/:id', function (req, res) {
		var file = path.dirname(process.mainModule.filename) + '/db/droplet.sqlite3';
		var db = new sqlite3.Database(file);
		var imagedata;
		var url;
		if(nconf.get('s3Config')) {
			var conf = nconf.get('s3Config');
			if(conf.hostname) {
				url = conf.hostname;
			} else {
				url = 'https://' + conf.bucket + '.s3.amazonaws.com/items/';
			} 
		} else {
			url = req.protocol + '://' + req.get('host') + '/files/';
		}

		//db.serialize(function() {
		db.get('SELECT filename FROM Files WHERE slug = ?', [req.params.id], function(err, row){
			if(row) {
				imagedata = row;
				console.log(row.filename);

				if(nconf.get('s3Config')) {
					url = url +'/'+ row.filename;
				} else {
					url = url + row.filename;
				}

				var model = {
					title: row.filename + ' - Droplet',
					id: req.params.id,
					filename: row.filename,
					filepath: url
				};

				res.render('image', model);
			}
		});
		//});

		db.close();
    });

};
