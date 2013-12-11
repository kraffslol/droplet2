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
app.use(express.bodyParser({
  uploadDir: __dirname + '/public/files/tmp',
  keepExtensions: true
}));
app.use(express.limit('10mb'));
app.use(express.methodOverride());
//app.use(express.static(path.join(__dirname, 'public')));
app.use(app.router);


/**
 * Routes
 */

app.post('/upload', function(req, res) {
  
  // Check that post data field "file" exists
  if(req.files.file) {

    // Temporary path of file 
    var tempPath = req.files.file.path;

    // Read the file (Oh why thank you, captain obvious)
    fs.readFile(req.files.file.path, function(err, data) {
      var fileName = req.files.file.name;
      
      // Is the file valid?
      if(!fileName) {
        console.log("Error");
        res.end();
      }
      else {
        var newPath = __dirname + "/public/files/" + fileName;

        // Move the file to the new path
        fs.rename(tempPath, newPath, function(err) {

          if(err) {
            console.log(err);
          }

          //res.redirect("/files/" + fileName);
          res.send('ok');
        });
      }
    });
  }
  else {
    res.writeHead(400, {'content-type': 'text/plain'});
    res.end('400');
  }
});


/**
 * Start Server
 */

http.createServer(app).listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});
