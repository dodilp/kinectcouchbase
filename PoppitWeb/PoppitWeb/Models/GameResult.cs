using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using Newtonsoft.Json;

namespace PoppitWeb.Controllers
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
