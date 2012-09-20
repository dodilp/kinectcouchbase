<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<!DOCTYPE html> 

<html>

	<head>

		<meta charset="UTF-8"/>

		<title>Scrolling Twitter Feed</title> 

		<style>
			body {
				background: #fff;
				font: 12px/1.2 Arial, sans-serif;
				color: #333;
			}

			/* The container for the module */
			#twitter {
				background: #f1f2f8;

				width: 600px; /* Up to you but remember to change the div width below as well if you change it */
				padding: 0 10px;

				overflow: hidden; /* clearfix */

				-moz-border-radius: 5px;
				-webkit-border-radius: 5px;
				-o-border-radius: 5px;
				-ms-border-radius: 5px;
				border-radius: 5px;
			}

				#twitter h2 {
					float: left; /* We'll make the heading sit on its own line next to the tweets */
					width: 85px; /* Might wanna change this depending on the text in the heading */
					margin: 0;
					padding: 6px 0; /* I'll set the top and bottom padding here rather than in the container so as not to cut off any text */

					font-size: 12px;
					color: #4b9fff;
					line-height: 1;
				}

				/* The marquee plug-in turns a marquee element into a div */
				#twitter p, 
				#twitter marquee, 
				#twitter div {
					float: left;
					width: 505px; /* Container width - heading width - 10px (for some right padding) */
					margin: 0;
					padding: 6px 0; /* Again we set the padding in here so as not to cut text */
					line-height: 1;
				}

					/* All the tweets will be links pointing to your page on twitter */
					#twitter marquee a, 
					#twitter div a {
						margin: 0 10px 0 0;
						color: #333;
						text-decoration: none;
					}

						/* The i is used to display the date of the tweet */
						#twitter marquee a i, 
						#twitter div a i {
							font-style: normal;
							color: #999;
						}
		</style>

	</head>

	<body>

		<div id="twitter">

			<h2>Latest tweets</h2>

			<p>Loading...</p>

			<noscript>This feature requires JavaScript</noscript>

		</div>

		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
		<script src="http://artistutorials.googlecode.com/files/jquery.marquee.js"></script>
		<script>
      var Twitter = {
      init: function () {
        // Pass in the username you want to display feeds for
        this.insertLatestTweets('dodilp');
      },

      // This replaces the <p>Loading...</p> with the tweets
				insertLatestTweets: function (username) {
					var limit	= 5;	// How many feeds do you want?
					var url		= 'http://twitter.com/statuses/user_timeline.json?screen_name=' + username + '&count=' + limit + '&callback=?';

					// Now ajax in the feeds from twitter.com
					$.getJSON(url, function (data) {
						// We'll start by creating a normal marquee-element for the tweets
						var html = '<marquee behavior="scroll" scrollamount="1" direction="left">';

						// Loop through all the tweets and create a link for each
						for (var i in data) {
							html += '<a href="http://twitter.com/' + username + '#status_' + data[i].id_str + '">' + data[i].text + ' <i>' + Twitter.daysAgo(data[i].created_at) + '</i></a>';
						}

						html += '</marquee>';

						// Now replace the <p> with our <marquee>-element
						$('#twitter p').replaceWith(html);

						// The marquee element looks quite shite so we'll use Remy Sharp's plug-in to replace it with a smooth one
						Twitter.fancyMarquee();
					});
				}, 

				// Replaces the marquee-element with a fancy one
				fancyMarquee: function () {
					// Replace the marquee and do some fancy stuff (taken from remy sharp's website)
					$('#twitter marquee').marquee('pointer')
						.mouseover(function () {
							$(this).trigger('stop');
						})
						.mouseout(function () {
							$(this).trigger('start');
						})
						.mousemove(function (event) {
							if ($(this).data('drag') == true) {
								this.scrollLeft = $(this).data('scrollX') + ($(this).data('x') - event.clientX);
							}
						})
						.mousedown(function (event) {
							$(this).data('drag', true).data('x', event.clientX).data('scrollX', this.scrollLeft);
						})
						.mouseup(function () {
							$(this).data('drag', false);
						});
				}, 

				// Takes a date and return the number of days it's been since said date
				daysAgo: function (date) {
					// TODO: Fix date for IE...
					if ($.browser.msie) {
						return '1 day ago';
					}

					var d = new Date(date).getTime();
					var n = new Date().getTime();

					var numDays = Math.round(Math.abs(n - d) / (1000 * 60 * 60 * 24));
					var daysAgo = numDays + ' days ago';

					if (numDays == 0) {
						daysAgo = 'today';
					}
					else if (numDays == 1) {
						daysAgo = numDays + ' day ago';
					}

					return daysAgo;
				}
			};

			Twitter.init();
		</script>

	</body>

</html>
