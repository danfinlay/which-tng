<!doctype html>

<html>
<head>
<title>TNG Suggestor</title>
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>

<script src="http://cdnjs.cloudflare.com/ajax/libs/three.js/r61/three.min.js"></script>
<style>

html, body {
  /*background-color: black;*/
  color: rgb(40,102,186);
  margin: 0px; padding:0px; overflow: hidden;
}
#WebGL-output{
  z-index:0;
  position: absolute;
}
.overlay {
  text-align: center;
  position: relative;
  z-index:1;
  padding-top: 50px;
  color: #ABADFF;
  perspective: 500px;
}

@font-face {
  font-family: 'Star Trek';
  font-weight:400;
  src:local('Star Trek TNG'), local('Star Trek TNG Title'),
      url(fonts/TNG_Title.otf) format('opentype'),
      url(fonts/TNG_Title.woff2) format('woff2'),
      url(fonts/TNG_Title.0) format('woff');
  /*unicode-range: U+0460-052F, U+20B4, U+2DE0-2DFF, U+A640-A69F;*/
}
/**{
  font-family: sans-serif;
}*/
h1, h2 {
  color: rgb(77, 153, 255);
  font-family: 'Star Trek', 'San Francisco', 'Helvetica', 'serif';
  text-shadow: 1px 1px 15px #5847E3;
  line-height: 20px;
  animation: throb 3s infinite;
}
@keyframes throb {
  0% { text-shadow: 1px 1px 15px #5738FF }
  50% { text-shadow: 1px 1px 20px #806BF1 }
  100% { text-shadow: 1px 1px 15px #5738FF; }
}

h1 { font-size: 65pt;}
h2 { font-size: 45pt;}
section {
  font-size: 26pt;
}
a{
  text-decoration: underline;
  color: inherit;
  transition: color 0.4s;
}
a:hover{
  color: white;
}
#enterprise{
  position: relative;
  animation: swoop 8s infinite;
/*transform: translateX(140000px) translateZ(100000px) translateY(0) scaleX(-1);*/


  /*transform: translateX(-14000px) translateZ(-10000px) translateY(-3000px) scaleX(-100%);*/
  /*transform: scale(0.02) translateX(-46000px) translateY(-13000px)*/
  /*transform: scale(0.01) translateX(-8000px) translateY(-3000px)*/
  /*transform: scale(1) translateX(3200px) translateY(-1600px)*/
}
@keyframes swoop {
  0% {
    transform: translateX(-140000px) translateZ(-100000px) translateY(0px);
  }
  45% {
    transform: translateX(-14000px) translateZ(-10000px) translateY(-3000px);
  }
  50% {
    transform: translateZ(100px) translateX(1600px) translateY(-900px);
  }
  51% {
    transform: translateX(129998px) translateZ(-100000px) translateY(0) scaleX(-1)
  }
  95% {
    transform: translateX(9598px) translateZ(-8000px) translateY(-1000px) scaleX(-1)
  }
  100% {
    transform: translateX(-1900px) translateZ(100px) translateY(-600px) scaleX(-1)
  }
}

</style>
</head>

<body>
  <div id ="WebGL-output" > </div>

  <div class="overlay">
    <h1>Star Trek: TNG</h1>
    <h2>Episode Suggestor</h2>
    <section class="suggestion">
      How about episode <span class="number">{{num}}</span>, "<a class="title" href={{url}}>{{title}}</a>"?
    </section>
    <img src='/img/enterprise.jpg' id="enterprise">
  </div>
</body>

<script>
$(function () {
  var scene = new THREE.Scene();
  var camera = new THREE.PerspectiveCamera(45 , window.innerWidth / window.innerHeight , 0.1, 1000);
  var renderer = new THREE.WebGLRenderer();

  renderer.setSize(window.innerWidth, window.innerHeight);

  var planetGeometry = new THREE.SphereGeometry(4,20,20);

  //Load the planet textures
  var texture = THREE.ImageUtils.loadTexture("https://s3-us-west-2.amazonaws.com/s.cdpn.io/96252/planet-512.jpg");
  var normalmap = THREE.ImageUtils.loadTexture("https://s3-us-west-2.amazonaws.com/s.cdpn.io/96252/normal-map-512.jpg");
  var specmap = THREE.ImageUtils.loadTexture("https://s3-us-west-2.amazonaws.com/s.cdpn.io/96252/water-map-512.jpg");

  var planetMaterial = new THREE.MeshPhongMaterial();
  planetMaterial.map = texture;

  planetMaterial.specularMap = specmap;
  planetMaterial.specular = new THREE.Color( 0xff0000 );
  planetMaterial.shininess = 1;

  planetMaterial.normalMap = normalmap;
  planetMaterial.normalScale.set(-0.3,-0.3);

  var planet = new THREE.Mesh(planetGeometry, planetMaterial);

  //Space background is a large sphere
  var spacetex = THREE.ImageUtils.loadTexture("https://s3-us-west-2.amazonaws.com/s.cdpn.io/96252/space.jpg");
  var spacesphereGeo = new THREE.SphereGeometry(20,20,20);
  var spacesphereMat = new THREE.MeshPhongMaterial();
  spacesphereMat.map = spacetex;

  var spacesphere = new THREE.Mesh(spacesphereGeo,spacesphereMat);

  //spacesphere needs to be double sided as the camera is within the spacesphere
  spacesphere.material.side = THREE.DoubleSide;

  spacesphere.material.map.wrapS = THREE.RepeatWrapping;
  spacesphere.material.map.wrapT = THREE.RepeatWrapping;
  spacesphere.material.map.repeat.set( 5, 3);

  scene.add(spacesphere);

  //position camera
  camera.position.x = 0;
  camera.position.y = 0;
  camera.position.z = -15;
  camera.lookAt(scene.position);

  //create two spotlights to illuminate the scene
  var spotLight = new THREE.SpotLight( 0xffffff );
  spotLight.position.set( -40, 60, -10 );
  spotLight.intensity = 2;
  scene.add( spotLight );

  var spotLight2 = new THREE.SpotLight( 0x5192e9 );
  spotLight2.position.set( 40, -60, 30 );
  spotLight2.intensity = 1.5;
  scene.add( spotLight2 );

  $("#WebGL-output"). append(renderer.domElement);

  //call render loop once
  render();

  //render loop
  function render() {
    requestAnimationFrame(render);
    //rotate planet and spacesphere
    planet.rotation.y += 0.002;
    spacesphere.rotation.y += 0.001;
    renderer.render(scene, camera);
  };

});

</script>

</html>
