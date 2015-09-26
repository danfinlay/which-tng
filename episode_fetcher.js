var cheerio = require('cheerio')
var request = require('request')
var fs = require('fs')
var path = require('path')

var outputPath = path.join(__dirname, 'episode_list.json')

console.log('requesting')
request.get('https://en.wikipedia.org/wiki/List_of_Star_Trek:_The_Next_Generation_episodes',
function (err, res, body){
  console.log("Called back")
  if (err) {
    console.log("err: ");
    console.dir(err)
    throw err
  }
  console.dir(res.statusCode)
  var $ = cheerio.load(body)
  var episodeRows = $('table tr.vevent')
  debugger
  console.log(`Fetched ${episodeRows.length} episodes`)
  var episodes = []
  for(var i = 0; i < episodeRows.length; i++){
    var row = episodeRows[i]
    var title = $(row).find('.summary').text()
    episodes.push({
      num: $(row).find('th').text(),
      title: title.substr(1, title.length-2),
    })
  }
  fs.writeFileSync(outputPath, JSON.stringify(episodes, null, 2))
})
console.log('requested')
