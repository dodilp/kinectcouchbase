<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" debug="true">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<script src="/Content/jquery.js" type="text/javascript"></script>

	<title>Dynamic Leaderboard</title>

<style>
@CHARSET "UTF-8";
/* http://meyerweb.com/eric/tools/css/reset/ 
   v2.0 | 20110126
   License: none (public domain)
*/

html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed, 
figure, figcaption, footer, header, hgroup, 
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
	margin: 0;
	padding: 0;
	border: 0;
	font-size: 100%;
	font: inherit;
	vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure, 
footer, header, hgroup, menu, nav, section {
	display: block;
}
body {
	line-height: 1;
	font-family: Helvetica, arial, sans-serif;
	margin:10pt;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}

h1 { font-size: 200% }

</style>
</head>

<body>
	<ul id="leaderboard"></ul>
	
	<script type="text/javascript">
	//alert('Hi');
    poll();

    function poll()
    {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/LeaderBoard", true);
    xhr.onreadystatechange = function() {
    if (xhr.readyState == 4) {
    if(xhr.status == 200) {
    //alert('Me');
    // JSON.parse does not evaluate the attacker's scripts.
    //var resp = JSON.parse(xhr.responseText);
    //alert(xhr.responseText);
    result(xhr.responseText);
    }
    }
    };
    xhr.send();

    // play it again, sam
    var t=setTimeout("poll()",3000);
    }

    function result(data)
    {
      //alert(data);
      var obj = jQuery.parseJSON(data);
      // alert(obj[3].Score);
      
      for(var i=0;i<obj.length;i++)
      { 
      
      	//alert(obj.rows[i]);
        //alert(obj.rows[i]);
        if ($("#user-"+obj[i].Name).length == 0)
        {
        //console.log($("<li><h1 style=\'display:inline\' id=\'user-" + obj[i].Name + "\'>" + obj[i].Score + "</h1><img style=\'height:50px\' src=\'https://api.twitter.com/1/users/profile_image/" + obj[i].Name + "\'/></li>"))
          //alert("<li><h1 style=\'display:inline\' id=\'user-" + obj[i].Name + "\'>" + obj[i].Score + "</h1><img style=\'height:50px\' src=\'https://api.twitter.com/1/users/profile_image/" + obj[i].Name + "\'/></li>");
          $("#leaderboard").append("<li><h1 style=\'display:inline\' id=\'user-" + obj[i].Name + "\'>" + obj[i].Name + " : " + obj[i].Score + "</h1></li>");
          //https://api.twitter.com/1/users/profile_image/abraham
          //$("#user-"+obj[i].Name).html(obj[i].Score);
        }
        else
        {
          $("#user-"+obj[i].Name).html(obj[i].Name + " : " + obj[i].Score);
        }
      }
      //sort();
    }

    function sort()
    {
    var $Ul = $('ul#leaderboard');
    $Ul.css({position:'relative',height:$Ul.height(),display:'block'});
    var iLnH;
    var $Li = $('ul#leaderboard>li');
    $Li.each(function(i,el){
    var iY = $(el).position().top;
    $.data(el,'h',iY);
    if (i===1) iLnH = iY;
    });
    $Li.tsort('h1:eq(0)',{order:'desc'}).each(function(i,el){
    var $El = $(el);
    var iFr = $.data(el,'h');
    var iTo = i*iLnH;
    $El.css({position:'absolute',top:iFr}).animate({top:iTo},500);
    });
    }
  </script>
</body>
</html>