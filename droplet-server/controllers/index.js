'use strict';


module.exports = function (server) {

    server.get('/', function (req, res) {
        var model = { name: 'droplet' };
        
        res.render('index', model);
        
    });

};
