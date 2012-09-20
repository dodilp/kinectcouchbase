using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using Couchbase;
using Couchbase.Configuration;

namespace PoppitWeb.Controllers
{
	public class LeaderBoardController : Controller
	{
		private static readonly CouchbaseClient _client;

		static LeaderBoardController()
		{
			var config = new CouchbaseClientConfiguration();
			config.Bucket = "default";
			config.Urls.Add(new Uri("http://localhost:8091/pools/"));

			_client = new CouchbaseClient(config);
		}
		
		public ActionResult Index ()
		{
			var view = _client.GetView<GameResult>("scoreboard", "by_score", true);

			return Json(view.ToArray(), JsonRequestBehavior.AllowGet);
		}
	}
}

