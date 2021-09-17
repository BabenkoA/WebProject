using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace FirstWebProject.Models
{
    public class BookContext: DbContext
    {
        public DbSet<Book> Books { get; set; }
        public DbSet<Purchase> Purchases { get; set; }
    }

    public class BookDbInitializer : DropCreateDatabaseAlways<BookContext> 
    {
        protected override void Seed(BookContext db)
        {
            db.Books.Add(new Book {Name = "Воскресения", Author = "Andrii", Price = 220});

            db.Books.Add(new Book { Name = "Гнездо", Author = "Тургенев", Price = 100 });

            base.Seed(db);

        }
    }

}