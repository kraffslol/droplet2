'use strict';


module.exports = function (server) {

    server.get('/image/:id', function (req, res) {
        var model = { 
			title: req.params.id + ' - Droplet',
			id:  req.params.id
        };
        
        res.render('image', model);
        
    });

};
