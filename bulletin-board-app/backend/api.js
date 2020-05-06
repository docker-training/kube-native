var db = require('./db.js');
const log = require('log-to-file');

log('beginning API logs', '/logs/api.log')
exports.events = function (req, res) {
  log('Loading DB events...', '/logs/api.log');
  db.Events
    .findAll()
    .then(events => {
        log('Fetched events, count: ' + events.length, '/logs/api.log');
        res.json(events);
    })
    .catch(err => {
        console.error('** Fetch failed: ', err);
    });
};

exports.event = function (req, res) {
  log('Handling event call, method: ' + req.method + ', event ID: ' + req.params.eventId, '/logs/api.log')
  switch(req.method) {
    case "DELETE":
      db.Events
      .destroy({
        where: {
          id: req.params.eventId
        }
      }).then(function() {
        log('Deleted event with id: ' + req.params.eventId, '/logs/api.log')
        res.status(200).end();
      });
      break
    case "POST":
      db.Events
        .create({
          title: req.body.title,
          detail: req.body.detail,
          date: req.body.date
        })
        .then(function() {
          res.send('{}');
          res.status(201).end();
        });
      break
  }
};
