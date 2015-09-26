var http = require('http')
var Mustache = require('mustache')
var episodes = require('./episode_list.json')
var fs = require('fs')
var path = require('path')

var templatePath = path.join(__dirname, 'index.ms')
var template = fs.readFileSync(templatePath).toString()
Mustache.parse(template)

var port = process.env.PORT || 7777

http.createServer(handleConnection).listen(port, function(){
  console.log(`Now listening on port ${port}`)
})

function handleConnection(req, res) {

  var randomEpisode = Math.ceil(episodes.length * Math.random())

  res.writeHead(200, {
    type: 'text/html'
  })
  res.end(Mustache.render(template, episodes[randomEpisode]))

}
