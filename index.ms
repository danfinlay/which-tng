<!doctype html>

<html>
<head>
<title>TNG Suggestor</title>
<style>

@font-face {
  font-family: 'Star Trek';
  src:url(/static/fonts/TNG_Title.otf) format('opentype'),
      url(/static/fonts/fed.ttf) format('truetype');
  font-weight:400;
}
/**{
  font-family: sans-serif;
}*/
h1, h2 {
  font-family: 'Star Trek', 'San Francisco', 'Helvetica', 'serif';
  line-height: 20px;
}
h1 { font-size: 65pt;}
h2 { font-size: 55pt;}
section {
  font-size: 26pt;
}

</style>
</head>

<body>
  <h1>Star Trek: TNG</h1>
  <h2>Episode Suggestor</h2>
  <section class="suggestion">
    How about episode <span class="number">{{num}}</span>: "<a class="title" href={{url}}>{{title}}</a>"?
  </section>
</body>

</html>
