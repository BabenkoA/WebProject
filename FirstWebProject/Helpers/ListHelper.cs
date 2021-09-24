using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace FirstWebProject.Helpers
{
    public static class ListHelper
    {
        public static MvcHtmlString ShowList(this HtmlHelper html, string [] item) 
        {
            TagBuilder ul = new TagBuilder("ul");
            foreach (string s in item)
            {
                TagBuilder li = new TagBuilder("li");
                li.SetInnerText(s);
                ul.InnerHtml += li.ToString();
            }
            return new MvcHtmlString(ul.ToString());
        }
    }
}