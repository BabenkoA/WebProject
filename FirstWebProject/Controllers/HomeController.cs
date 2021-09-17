using FirstWebProject.Models;
using FirstWebProject.Util;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FirstWebProject.Controllers
{
    public class HomeController : Controller
    {
        BookContext db = new BookContext();
        public ViewResult Index()
        {
            IEnumerable books = db.Books;
            ViewBag.Books = books;
            //return View();
            ViewData["Head"] = "Hello!";
            ViewBag.HeadSec = "Hello Bag!";
            ViewBag.Fruit = new List<string>
            {
                "яблоки", "груши" , "Уши"
            };
            return View("~/Views/Some/Index.cshtml");
        }

        [HttpGet]
        public HtmlResult GetHtml()
        {
            return new HtmlResult("<h1> Hello world! </h1>");
        }

        [HttpGet]
        public ActionResult GetImage()
        {
            return new ImageResult("../Content/Images/macos-big-sur-2560x1440-23097.jpg");
        }

        [HttpGet]
        public ActionResult Buy(int id) 
        {
            ViewBag.BookId = id;
            return View();
        }

        [HttpPost]
        public ContentResult Buy(Purchase purchase) 
        {
            purchase.Date = DateTime.Now;
            db.Purchases.Add(purchase);
            db.SaveChanges();
            return Content("Thanks, " + purchase.Person + ", for ordering");
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }

        public ActionResult GetVoid(int id) 
        {
            if (id > 3)
            {
                //return Redirect("/Home/Contact");
                //return RedirectToAction("Contact");
                //return RedirectToRoute(new { controller = "Home", action = "Contact" }) ;
                return RedirectToAction("Buy","Home", new {id = 1});
            }
            return View("About");
        }

        public HttpStatusCodeResult GetHttpCode(int id) 
        {
            if (id>3)
            {
                return new HttpStatusCodeResult(404);
            }
            return new HttpStatusCodeResult(200);
        }
    }
}