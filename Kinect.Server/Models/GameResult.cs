using System;
using Newtonsoft.Json;

namespace Kinect.Server
{
	public class GameResult
	{
		[JsonProperty("name")]
		public string Name {
			get;
			set;
		}

		[JsonProperty("score")]
		public int Score {
			get;
			set;
		}

		[JsonProperty("type")]
		public string Type {
			get { return "gameResult"; }
		}
	}
}

