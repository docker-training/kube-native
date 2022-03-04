var express = require('express'),
	bodyParser = require('body-parser'),
	methodOverride = require('method-override'),
	errorHandler = require('errorhandler'),
	morgan = require('morgan'),
	prometheus = require('prom-client'),
	routes = require('./backend'),
	api = require('./backend/api');
var app = module.exports = express();

app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

// middleware monitoring function
var monitor = function (req, res, next){
   res.on("finish", function() {
       routeRequests.labels(req.method, req.path, res.statusCode).inc()
    });
    next();
}

// middleware stack
app.use(monitor)
app.use(morgan('dev'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(methodOverride());
app.use(express.static(__dirname + '/'));
app.use('/build', express.static('public'));
var env = process.env.NODE_ENV;
if ('development' == env) {
    app.use(errorHandler({
     dumpExceptions: true,
     showStack: true
    }));
}
if ('production' == app.get('env')) {
	app.use(errorHandler());
}
// counter for Prometheus:
const routeRequests = new prometheus.Counter({
   name: 'bb_route_requests',
   help: 'request by route',
   labelNames: ['method', 'route', 'code']
})

app.get('/', routes.index);
app.get('/api/events', api.events);
app.post('/api/events', api.event);
app.delete('/api/events/:eventId', api.event);
app.get('/metrics', (req, res) => {
	res.set('Content-Type', prometheus.register.contentType)
	res.end(prometheus.register.metrics())
	})
prometheus.collectDefaultMetrics();

app.listen(8080);
console.log('Magic happens on port 8080...');