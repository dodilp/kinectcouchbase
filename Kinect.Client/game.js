

var hands = [];

(function() {
	var spr=PP.spr,rm=PP.rm,obj=PP.obj,snd=PP.snd,al=PP.al,global=PP.global,Alarm=PP.Alarm,collision=PP.collision,draw=PP.draw,init=PP.init,key=PP.key,load=PP.load,loop=PP.loop,mouse=PP.mouse,physics=PP.physics,Sound=PP.Sound,SoundEffect=PP.SoundEffect,Sprite=PP.Sprite,view=PP.view,walkDown=PP.walkDown;
	setTimeout(function() { obj.balloon.red.vspeed = 15;mma=2 }, 20000);
	setTimeout(function() { obj.balloon.red.vspeed = 40;mma=3 }, 40000);
	setTimeout(function() { obj.balloon.blue.vspeed = 12; }, 20000);
	setTimeout(function() { obj.balloon.blue.vspeed = 18; }, 40000);
	setTimeout(function() { obj.balloon.green.vspeed = 9; }, 20000);
	setTimeout(function() { obj.balloon.green.vspeed = 15; }, 40000);

	setTimeout(function() { loop.room = rm.gameOver;  }, 100);


	function timeMsg()
		{
	setTimeout(function() { obj.balloon.red.vspeed = 15;mma=2 }, 20000);
	setTimeout(function() { obj.balloon.red.vspeed = 40;mma=3 }, 40000);
	setTimeout(function() { obj.balloon.blue.vspeed = 12; }, 20000);
	setTimeout(function() { obj.balloon.blue.vspeed = 18; }, 40000);
	setTimeout(function() { obj.balloon.green.vspeed = 9; }, 20000);
	setTimeout(function() { obj.balloon.green.vspeed = 15; }, 40000);

	setTimeout(function() { obj.balloon.red.vspeed = 10;mma=1 }, 100);
	setTimeout(function() { obj.balloon.blue.vspeed = 7;mma=1 }, 100);
	setTimeout(function() { obj.balloon.green.vspeed = 5;mma=1 }, 100);
	}

	var status = document.getElementById("status");
	var canvas = document.getElementById("canvas");
	var context = canvas.getContext("2d");

  	if (!window.WebSocket) {
        	status.innerHTML = "Your browser does not support web sockets!";
        	return;
    	}

    	status.innerHTML = "Connecting to server...";

    	// Initialize a new web socket.
    	var socket = new WebSocket("ws://localhost:9999");

    	// Connection established.
    	socket.onopen = function () {
        	status.innerHTML = "Connection successful.";
    	};

    	// Connection closed.
    	socket.onclose = function () {
        	status.innerHTML = "Connection closed.";
    	}


  		// Receive data FROM the server!
    	socket.onmessage = function (evt) {
        status.innerHTML = "Kinect data received.";

        // Get the data in JSON format.
        var jsonObject = eval('(' + evt.data + ')');
			
        hands = [];
        // Display the skeleton joints.
        for (var i = 0; i < jsonObject.skeletons.length; i++) 
		{
            for (var j = 0; j < jsonObject.skeletons[i].joints.length; j++) 
			{
                	var joint = jsonObject.skeletons[i].joints[j];

		            draw.circle(parseFloat(joint.x), parseFloat(joint.y), 20, false, 'red');
                    hands.push({ "x": joint.x, "y": joint.y });
            }
        }
    };

	init('canvas',640,480);
	loop.rate = 30;

	// The balloon object is created to better organize the sprites
	spr.balloon = {};

	// The new Sprite function will return a new sprite object.
	spr.balloon.red = new Sprite('sprites/balloon_red.png',1,32,43);
	spr.balloon.blue = new Sprite('sprites/balloon_blue.png',1,32,43);
	spr.balloon.green = new Sprite('sprites/balloon_green.png',1,32,43);
	spr.background = new Sprite('sprites/background.png',1,0,0);

	// This function will be invoked when all of the resources have finished downloading
	load(function() {

		obj.balloon = {
			parent: {
				mask: spr.balloon.red.mask,

				// The initialization function will be invoked when an object is registered.
				initialize: function(t) {
					// The t parameter passed to this function will hold the same value as "this" will inside a function
					// It could be written like this in every function:
					// var t = this;
					// Having it passed as a parameter saves time.

					// The x and y properties determine the position of the object in game space.
					// The x coordinates increase to the left and the y coordinates increase downwards.

					// The balloon will be randomly assigned a position
					t.x = Math.floor(Math.random()*640);

					// This y coordinate will start the balloon below the view of the game view.
					t.y = 523;

					t.angle = 0;



				},

				tick: function(t) {
					// This controls the upward movement of the balloon
					t.y -= t.vspeed;

					// mouse.left.down holds a value of true if the left mouse button has been
					// pressed down since the end of the last loop
					// The collision.point function determines if a point lies within a mask.
					if (mouse.left.down) {
                      hands[0] = { "x": mouse.x, "y": mouse.y }
                    }

                    for (var i = 0; i < hands.length; i++) {
                      var hand = hands[i];
                      if (collision.point(t,hand.x,hand.y,false)) {
						global.score += t.vspeed;
						loop.remove(t);
                      }
					}

					// If the balloon moves so far up that it is outside of the view, remove it
					if (t.y < -40) {
						loop.remove(t);
					}
				},

				draw: function(t) {
					// The actual sprite of the balloon is drawn here.
					// All sprite objects have a draw method that is used to draw a sprite.
					t.sprite.draw(t.x,t.y);
				}
			},

			red: {
				vspeed: redVSpeed,
				sprite: spr.balloon.red
			},

			blue: {
				vspeed: blueVSpeed,
				sprite: spr.balloon.blue
			},

			green: {
				vspeed: greenVSpeed,
				sprite: spr.balloon.green
			}
		};

		// Set up the inheritence chain
		obj.balloon.red.proto = obj.balloon.parent;
		obj.balloon.blue.proto = obj.balloon.parent;
		obj.balloon.green.proto = obj.balloon.parent;

		obj.background = {
			depth: -1,
			draw: function(t) {
				spr.background.draw(0,0);
			}
		};

		// The gameOver object controls the drawing of the final score and allows the user
		// to press enter to start a new game.
		obj.gameOver = {
		   tick: function(t) {
				// If the enter key has been released, switch back to the play room
				if (key.space.up) {
					loop.room = rm.play;
				}
			},

			// Here the game over texts are drawn
			draw: function(t) {
				draw.textHalign = 'center';
				draw.textValign = 'middle';
				draw.color = 'white';
				draw.font = 'normal normal normal 50px Georgia';
				draw.text(320,240,'Score: '+global.score);
				draw.font = 'normal normal normal 20px Georgia';
				draw.textValign = 'alphabetic';
				draw.text(320,15,'Press space to start a new game');
				//alert(global.score);
				//socket.send(global.score);
			}
		};

		obj.score = {
			initialize: function(t) {
				// Create the alarm to be used as a countdown
				t.countdown = new Alarm(function() {
					// When the alarm reaches 0, switch to the rm.gameOver room.
					if(global.sendscore == 0)
					{
						socket.send(global.name + "|" + global.score);
						global.sendscore = 1;
					}
					loop.room = rm.gameOver;
				});

				// Alarms are decremented by 1 each loop. If we take the loops per second and multiply by some
				// number, we will be able to count down in seconds. Here, the countdown will take 30 seconds.
				t.countdown.time = loop.rate*60;
			},

			draw: function(t) {
				// The textHalign property sets the horizontal alignment of the draw.text function
				draw.textHalign = 'left';
				// The textValign property sets the vertical alignment of the draw.text function
				draw.textValign = 'bottom';
				// Change the drawing color (used for things like primitive shapes and text) to white, so the score text
				// will be visible against a brown background
				draw.color = 'white';
				// The draw.font property takes a css font string, to be used by the draw.text function
				draw.font = 'normal normal normal 20px Georgia';
				// Here, the score is drawn in the bottom left at position (0,480)
				draw.text(0,480,'Score: '+global.score);
				
				// If there are 5 seconds left, switch to red
				if (t.countdown.time <= loop.rate*5) {
					draw.color = 'red';
				}

				// Draw the current time remaining.
				draw.text(0,450,Math.ceil(t.countdown.time/loop.rate)+' Seconds Left');
			}
		};

		rm.play = function() {
		    timeMsg();
			// Register the background and score objects
			loop.register(obj.background,0,0);
			loop.register(obj.score,0,0);

			global.score = 0;
			global.sendscore = 0;
			
			// The balloonCreator alarm controls the timing of the creations of the balloons
			var balloonCreator = new Alarm(function() {
				var bal = obj.balloon;


				// The choose function will randomly choose one of the passed parameters and return it.
				// The loop.beget function is a combination of the Object.create and loop.register functions
				loop.beget(Math.choose(bal.red,bal.blue,bal.green));

				// The alarm resets itself for half a second. Balloons will spawn half a second apart.
				this.time = loop.rate*.5;
			});

			// Set the initial alarm time to 0 so it will trigger right away.
			balloonCreator.time = 0;
		};

		rm.gameOver = function() {
			loop.register(obj.background,0,0);
			loop.register(obj.gameOver);
			/*
			jPrompt('Type something:', 'Prefilled value', 'Prompt Dialog', function(r) {
				if( r ) global.name = r;
			});*/ 
			global.name = prompt("Interested to play? Enter your name :", "CouchbaseGuest");
		};

		loop.active = true;
		loop.room = rm.play;
	});
}());
var redVSpeed = 10;
var blueVSpeed = 7;
var greenVSpeed = 5;
