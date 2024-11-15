var Memcached = require('memcached');
var http = require('http');

//Lets define a port we want to listen to
const WEB_PORT = process.env.WEB_PORT || '80';
const CACHE_ADDRESS = process.env.CACHE_ADDRESS || '127.0.0.1';
const CACHE_PORT = process.env.CACHE_PORT || '11211';
const options = {};
var memcachedDSN = CACHE_ADDRESS + ':' + CACHE_PORT;
console.log('Connecting to memcached server: ' + memcachedDSN);

function getMemcached() {
	return new Memcached(memcachedDSN, options);
}

// set random data
var memcached = getMemcached();
memcached.set( "hello", 1, 10000, function( err, result ){
	if( err ) console.error( err );
	
	console.dir( result );
	memcached.end(); // as we are 100% certain we are not going to use the connection again, we are going to end it
})
memcached.end();

//We need a function which handles requests and send response
function handleRequest(request, response){
	var memcached = getMemcached();
    memcached.items(function( err, result ){
		if( err ) console.error( err );
		
		console.log( JSON.stringify ( result ));
		memcached.end(); // as we are 100% certain we are not going to use the connection again, we are going to end it
		response.end(JSON.stringify ( result ));
	})
}

//Create a server
var server = http.createServer(handleRequest);

//Lets start our server
server.listen(WEB_PORT, function(){
    //Callback triggered when server is successfully listening. Hurray!
    console.log("Server listening on: http://localhost:%s", WEB_PORT);
});