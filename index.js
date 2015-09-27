var http = require('http')
var Mustache = require('mustache')
var episodes = require('./episode_list.json')
var fs = require('fs')
var path = require('path')
var ecstatic = require('ecstatic')

var templatePath = path.join(__dirname, 'index.ms')
var template = fs.readFileSync(templatePath).toString()
Mustache.parse(template)

var staticPath = path.join(__dirname, 'static')
var staticHandler = ecstatic({ root: staticPath })

var port = process.env.PORT || 7777

http.createServer(handleConnection).listen(port, function(){
  console.log(`Now listening on port ${port}`)
})

function handleConnection(req, res) {
  console.dir(req.url)
  if (req.url == '/'){ // Root or any .html file
    renderTemplate(req, res)
  } else {
    staticHandler(req, res)
  }
}

function renderTemplate (req, res){
  var randomEpisode = Math.ceil(episodes.length * Math.random())
  var episode = episodes[randomEpisode]
  res.writeHead(200, {
    type: 'text/html'
  })
  console.log("Attempting to render episode " + JSON.stringify(episode))
  res.end(Mustache.render(template, episode))
}
