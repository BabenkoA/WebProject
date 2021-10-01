using FirstWebProject.Models;
using FirstWebProject.Util;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;

namespace FirstWebProject.Controllers
{
    public class HomeController : Controller
    {
        BookContext db = new BookContext();

        public ActionResult Index() 
        {
            IEnumerable<Book> books = db.Books;
            //ViewBag.Books = books;
            ViewBag.Message = "This is Partial View";
            SelectList authors = new SelectList(books, "Author", "Name");
            ViewBag.Authors = authors;
            return View(books);
        }

        public ActionResult BookIndex()
        {
            IEnumerable<Book> books = db.Books;
            //ViewBag.Books = books;
            return View(books);
        }

        [HttpPost]
        public string GetForm(string color, string text, string authors, string[] countries) 
        {
            string all_countries = "";
            foreach (string country in countries)
            {
                all_countries += country + "; ";
            }
            return color +"\n" +text + "\n" + authors + "\n" + all_countries;
        }

        public ActionResult GetList() 
        {
            string[] arr = new string[] { "Kyiv", "Slavuta", "NAU" };
            ViewBag.Message = "This is Partial View";
            return PartialView(arr);
        }

        public async Task<ActionResult> BookList()
        {
            IEnumerable<Book> books = await  db.Books.ToListAsync();
            ViewBag.Books = books;
            return View();
        }
        //public ViewResult Index()
        //{
        //    Session["name"] = "Andrii";
        //    IEnumerable books = db.Books;
        //    ViewBag.Books = books;
        //    //return View();
        //    ViewData["Head"] = "Hello!";
        //    ViewBag.HeadSec = "Hello Bag!";
        //    ViewBag.Fruit = new List<string>
        //    {
        //        "яблоки", "груши" , "Уши"
        //    };

        //    HttpContext.Response.Cookies["id"].Value = "121";
        //    return View("~/Views/Some/Index.cshtml");
        //}

        public string GetData() 
        {
            string id = HttpContext.Request.Cookies["Id"].Value;
            return id.ToString() + Session["name"].ToString();
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
                return RedirectToAction("Buy", "Home", new { id = 1 });
            }
            return View("About");
        }

        public HttpStatusCodeResult GetHttpCode(int id)
        {
            if (id > 3)
            {
                return new HttpStatusCodeResult(404);
            }
            return new HttpUnauthorizedResult();
        }

        public FileResult GetFile()
        {
            string file_path = Server.MapPath("~/Files/FIXTB_876_PRClast.sql");
            string file_type = "application/octet-stream";
            string file_name = "FIXTB_876_PRClast.sql";
            return File(file_path, file_type, file_name);
        }

        public FileContentResult GetBytes() 
        {
            string path = Server.MapPath("~/Files/FIXTB_876_PRClast.sql");
            byte[] arr = System.IO.File.ReadAllBytes(path);
            string file_type = "application/sql";
            string file_name = "FIXTB_876_PRClast.sql";
            return File(arr, file_type, file_name);

            //FileStreamResult
        }

        public string GetContext() 
        {
            HttpContext.Response.Write("HelloWorld!");
            string browser = HttpContext.Request.Browser.Browser;
            string user_agent = HttpContext.Request.UserAgent;
            string url = HttpContext.Request.RawUrl;
            string ip = HttpContext.Request.UserHostAddress;
            string referrer = HttpContext.Request.UrlReferrer == null ? "" : HttpContext.Request.UrlReferrer.AbsoluteUri;
            HttpContext.Response.Write("<p>Browser: " + browser + "</p><p>User-Agent: " + user_agent + "</p><p>Url запроса: " + url +
            "</p><p>Реферер: " + referrer + "</p><p>IP-адрес: " + ip + "</p>");
            return "Done";


        }
    }
}