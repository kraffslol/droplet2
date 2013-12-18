'use strict';
var fs = require('fs'),
path = require('path'),
rand = require('generate-key'),
nconf = require('nconf'),
knox = require('knox'),
sqlite3 = require('sqlite3').verbose();

module.exports = function (server) {

    server.post('/upload', function (req, res) {
        console.log(__dirname);
        // Check that post data field "file" exists
        if (req.files.file) {

            // Temporary path of file 
            var tempPath = req.files.file.path;

            // Read the file (Oh why thank you, captain obvious)
            fs.readFile(req.files.file.path, function (err, data) {
                var fileName = req.files.file.name;

                // Is the file valid?
                if (!fileName) {
                    console.log('Error');
                    res.end();
                } else {

                    // Generate random string to optimistically avoid duplicates
                    var hash = rand.generateKey(7);
                    var newFileName = hash + '-' + fileName;
                    var file = path.dirname(process.mainModule.filename) + '/db/droplet.sqlite3';
                    var db = new sqlite3.Database(file);

                    if(nconf.get('s3Config')) {
                        var conf = nconf.get('s3Config');
                        var client = knox.createClient({
                            key: conf.access_key,
                            secret: conf.secret,
                            bucket: conf.bucket,
                            region: conf.region
                        });

                        var s3path = '/items/' + hash + '/' + fileName;

                        client.putFile(tempPath, s3path, { 'x-amz-acl': 'public-read' }, function(err, resp){
                            if(err) {
                                console.log(err);
                            } else {
                                if(resp.statusCode === 200) {
                                    var url;
                                    if(conf.hostname) {
                                        url = conf.hostname+s3path;
                                    } else {
                                        url = 'https://' + conf.bucket + '.s3.amazonaws.com' + s3path;
                                    }
                                    db.serialize(function() {
                                        db.run('INSERT INTO Files (slug, filename) VALUES (?, ?)', [hash, fileName]);
                                    });
                                    db.close();
                                    res.send(url);
                                    resp.resume();
                                }
                                
                            }
                        });

                    } else {
                        var newPath = path.normalize(path.dirname(process.mainModule.filename) + '/public/files/' + newFileName);
                        console.log(newPath);
                        console.log();

                        // Move the file to the new path
                        fs.rename(tempPath, newPath, function (err) {

                            if (err) {
                                console.log(err);
                            }

                            //res.redirect('/files/' + newFileName);
                            db.serialize(function() {
                                db.run('INSERT INTO Files (slug, filename) VALUES (?, ?)', [hash, newFileName]);
                            });
                            db.close();
                            res.send(req.protocol + '://' + req.get('host') + '/files/' + newFileName);
                            //res.send('ok');
                        });
                    }
                }
            });
        } else {
            res.writeHead(400, {
                'content-type': 'text/plain'
            });
            res.end('400');
        }
    });
};