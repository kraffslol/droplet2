/**
 * Module dependencies
 */

var express = require('express'),
  http = require('http'),
  fs = require('fs'),
  path = require('path');

var app = module.exports = express();


/**
 * Configuration
 */

// all environments
app.set('port', process.env.PORT || 3000);
app.use(express.bodyParser({uploadDir: __dirname + '/public/uploads/tmp'}));
app.use(express.methodOverride());
//app.use(express.static(path.join(__dirname, 'public')));
app.use(app.router);


/**
 * Routes
 */

app.post('/upload', function(req, res) {
  fs.readFile(req.files.image.path, function(err, data) {
  		var imageName = req.files.image.name;

		if(!imageName){
  			console.log("Error");
  			res.end();
		} else {
  			var newPath = __dirname + "/public/uploads/" + imageName;

  			fs.readFile(req.files.image.path, function(err, data) {
  				fs.writeFile(newPath, data, function(err) {
  					if(err) {
  						console.log(err);
  					}
  					//res.redirect("/uploads/" + imageName);
  					res.send('ok');
  					
  				});
  			});
  		}
  });
});


/**
 * Start Server
 */

http.createServer(app).listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});
