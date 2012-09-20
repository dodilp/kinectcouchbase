using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;

namespace PoppitWeb.Controllers
{
	public class HomeController : Controller
	{
		public ActionResult Index()
		{
			return View();
		}

		public ActionResult Twitter()
		{
			return View();
		}

		public ActionResult LeaderBoard()
		{
			return View ();
		}


	}
}

