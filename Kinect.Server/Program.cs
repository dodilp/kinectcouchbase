using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Timers;
using Fleck;
using Microsoft.Kinect;
using Couchbase;
using Enyim.Caching;
using Twitterizer;

namespace Kinect.Server
{
    class Program
    {
        static List<IWebSocketConnection> _sockets;
        static Skeleton[] skeletons;
        static KinectSensor m_kinect;
        static CouchbaseClient m_cclient;

        static bool _initialized = false;
        static bool _isgameover = false;

        static void Main(string[] args)
        {
            InitializeCouchbase();
            //DiscoverKinectSensor();
            InitializeSockets();
        }

        private static void DiscoverKinectSensor()
        {
            foreach (KinectSensor sensor in KinectSensor.KinectSensors)
            {
                if (sensor.Status == KinectStatus.Connected)
                {
                    // Found one, set our sensor to this
                    m_kinect = sensor;
                    break;
                }
            }

            if (m_kinect == null)
            {
                Console.WriteLine("Found none Kinect Sensors connected to USB");
                return;
            }

            // You can use the kinectSensor.Status to check for status
            // and give the user some kind of feedback
            switch (m_kinect.Status)
            {
                case KinectStatus.Connected:
                    {
                        Console.WriteLine("Status: Connected");
                        break;
                    }
                case KinectStatus.Disconnected:
                    {
                        Console.WriteLine("Status: Disconnected");
                        break;
                    }
                case KinectStatus.NotPowered:
                    {
                        Console.WriteLine("Status: Connect the power");
                        break;
                    }
                default:
                    {
                        Console.WriteLine("Status: Error");
                        break;
                    }
            }

            // Init the found and connected device
            if (m_kinect.Status == KinectStatus.Connected)
            {
                InitilizeKinect();
            }
        }

        private static void InitializeCouchbase()
        {
            m_cclient = new CouchbaseClient();
        }

        private static void InitializeSockets()
        {
            _sockets = new List<IWebSocketConnection>();

            var server = new WebSocketServer("ws://localhost:9999");

            server.Start(socket =>
            {
                socket.OnOpen = () =>
                {
                    Console.WriteLine("Connected to " + socket.ConnectionInfo.ClientIpAddress);
                    _sockets.Add(socket);
                };
                socket.OnClose = () =>
                {
                    Console.WriteLine("Disconnected from " + socket.ConnectionInfo.ClientIpAddress);
                    _sockets.Remove(socket);
                };
                socket.OnMessage = message =>
                {
                    //Console.WriteLine(message);
                    int barIndex = message.IndexOf("|",0);
                    String name = message.Substring(0, barIndex);
                    Int32 score = Int32.Parse(message.Substring(barIndex + 1));
                    if (score > 100) //We only want to tweet sometimes -- not for all games
                    {
                        String msgformat = "{0} just scored {1}";
                        Tweet(String.Format(msgformat, name, score));
                    }
                };
            });

            _initialized = true;

            Console.ReadLine();
        }

        private static void InitilizeKinect()
        {
                m_kinect.ColorStream.Enable();

                m_kinect.DepthStream.Enable();

                m_kinect.SkeletonStream.Enable();

                m_kinect.ColorStream.Enable(ColorImageFormat.RgbResolution640x480Fps30);
         
                m_kinect.Start();

                _initialized = true;

                m_kinect.SkeletonFrameReady += new EventHandler<SkeletonFrameReadyEventArgs>(nui_SkeletonFrameReady);
                m_kinect.ColorFrameReady +=new EventHandler<ColorImageFrameReadyEventArgs>(m_kinect_ColorFrameReady);
        }

        static void m_kinect_ColorFrameReady(object sender, ColorImageFrameReadyEventArgs e)
        {
            using (ColorImageFrame colorImageFrame = e.OpenColorImageFrame())
            {
                if (colorImageFrame == null) return;

                byte[] pixeldata = new byte[colorImageFrame.PixelDataLength];
                

            }
        }

        static private void nui_SkeletonFrameReady(object sender, SkeletonFrameReadyEventArgs e)
        {
            if (!_initialized && !_isgameover) return;
            List<Skeleton> users = new List<Skeleton>();

            if (e.OpenSkeletonFrame().SkeletonArrayLength == 0) return;

            using (SkeletonFrame skeletonFrame = e.OpenSkeletonFrame())
            {
                if (skeletonFrame != null)
                {
                    if (skeletons == null)
                    {
                        skeletons = new Skeleton[skeletonFrame.SkeletonArrayLength];
                    }
                    skeletonFrame.CopySkeletonDataTo(skeletons);
                }
            }

            //Add to users local array
            foreach (Skeleton s in skeletons)
            {
                if (s.TrackingState == SkeletonTrackingState.Tracked)
                {
                    users.Add(s);
                }
            }

            //Begin serializing
            if (users.Count > 0)
            {
                string json = users.Serialize();
                foreach (var socket in _sockets)
                {
                    socket.Send(json);
                    TimeSpan t = (DateTime.UtcNow - new DateTime(1970, 1, 1));
                    int timestamp = (int)t.TotalSeconds;
                    //m_cclient.Store(Enyim.Caching.Memcached.StoreMode.Set, timestamp.ToString(), json);         
                }
            }
        }


        public static void Tweet(string message)
        {
            OAuthTokens tokens = new OAuthTokens();
            tokens.ConsumerKey = "QZxTYQeFeAwpOdi1UobUAQ";
            tokens.ConsumerSecret = "qhccvDMXy9xmmS2OdkvzTOeQYjTdBp7ujmttRcZihTQ";
            tokens.AccessToken = "227787412-KM06CbVWjwCOHWGIIWAWLFh3dE1gfBJDrC0pqcuI";
            tokens.AccessTokenSecret = "z9A0kSEOpfW2xasCX4SLNpyBDuqnRpjswOrVVoghQ";

            IAsyncResult asyncResult = TwitterStatusAsync.Update(
                tokens,
                message,
                null,
                new TimeSpan(0, 3, 0),
                updateResponse =>
                {

                });
        }
    }
}
