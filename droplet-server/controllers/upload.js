'use strict';
var fs = require('fs'),
  path = require('path'),
  rand = require('generate-key');

module.exports = function (server) {

    server.post('/upload', function (req, res) {
      console.log(__dirname);
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

            // Generate random string to optimistically avoid duplicates
            var newFileName = rand.generateKey(7) + '-' + fileName;
            var newPath = path.normalize(path.dirname(process.mainModule.filename) + '/public/files/' + newFileName);
            console.log(newPath);
            console.log();

            // Move the file to the new path
            fs.rename(tempPath, newPath, function(err) {

              if(err) {
                console.log(err);
              }

              //res.redirect('/files/' + newFileName);
              res.send(req.protocol + "://" + req.get('host') + '/files/' + newFileName);
              //res.send('ok');
            });
          }
        });
      }
      else {
        res.writeHead(400, {'content-type': 'text/plain'});
        res.end('400');
      }
    });
};