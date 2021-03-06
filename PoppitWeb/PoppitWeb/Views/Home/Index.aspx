<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<!DOCTYPE html>
<html>
  <a href="http://www.couchbase.com/couchbase-server/beta">
    <img style="position: absolute; top: 0; right: 0; border: 0;" src="http://www.couchbase.com/sites/default/files/uploads/all/images/products/Powered_by_Couchbase2_red.png" alt="Powered by Couchbase Server 2.0">
  </a><head>
    <title>Couchbase Server 2.0 - Poppit! Powered by Couchbase</title>
    <style type="text/css">
      canvas {
      border-width: 1px;
      border-color: black;
      border-style: solid;
      margin-left: auto;
      margin-right: auto;
      display: block;
      }

      body {
      background: url(content/wallpaper.jpg) no-repeat;
      background-size: 100%;
      }
    </style>
    <link rel="stylesheet" href="content/style.css" />
    <script type="text/javascript" src="scripts/excanvas.js"></script>
    <script src="scripts/color-0.4.1.min.js"></script>
</head>
  <body>
    <h1 align="center">Poppit! Powered by Couchbase</h1>
    
    
    <iframe src="/Home/LeaderBoard" style="position:absolute;left:0;height:100%;border:0px;"></iframe>
    
    
    <canvas id="canvas" width="640" height="480"></canvas>
    Status: <label id="status">None</label>
    <script src="scripts/propulsion_1.2.js" type="text/javascript"></script>
    <script src="scripts/game.js" type="text/javascript"></script>
    <div id="wrapper">
      <iframe src="/Home/Twitter" id="twitterframe" frameBorder="0" width="100%" height="100%"></iframe>
    </div>
    <script language="javascript">
      function timeout_trigger()
      {
      var iframe = document.getElementById('twitterframe');
      iframe.src = iframe.src;
      }

      setTimeout('timeout_trigger()', 120000);
    </script>
    <!--
  <script type="text/javascript" src="http://twitter.com/javascripts/blogger.js"></script>
  <script type="text/javascript" src="http://twitter.com/statuses/user_timeline/dodilp.json?callback=twitterCallback2&amp;count=2"></script
  -->
  </body>
</html>

