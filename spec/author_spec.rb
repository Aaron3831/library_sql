require('spec_helper')

describe(Author) do
  describe(".all") do
    it("starts off with no authors") do
      expect(Author.all()).to(eq([]))
    end
  end

  describe("#name") do
    it("tells you its name") do
      author = Author.new({:name => "Epicodus stuff", :id => nil})
      expect(author.name()).to(eq("Epicodus stuff"))
    end
  end

  describe("#id") do
    it("sets its ID when you save it") do
      author = Author.new({:name => "Epicodus stuff", :id => nil})
      author.save()
      expect(author.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#save") do
    it("lets you save authors to the database") do
      author = Author.new({:name => "Epicodus stuff", :id => nil})
      author.save()
      expect(Author.all()).to(eq([author]))
    end
  end

  describe("#==") do
    it("is the same author if it has the same name") do
      author1 = Author.new({:name => "Epicodus stuff", :id => nil})
      author2 = Author.new({:name => "Epicodus stuff", :id => nil})
      expect(author1).to(eq(author2))
    end
  end

  describe(".find") do
    it("returns a author by its ID") do
      test_author = Author.new({:name => "Epicodus stuff", :id => nil})
      test_author.save()
      test_author2 = Author.new({:name => "Home stuff", :id => nil})
      test_author2.save()
      expect(Author.find(test_author2.id())).to(eq(test_author2))
    end
  end

  describe("#books") do
    it("returns an array of books for that author") do
      test_author = Author.new({:name => "Epicodus stuff", :id => nil})
      test_author.save()
      test_book = Book.new({:id => nil, :title => "Learn SQL", :author_id => test_author.id()})
      test_book.save()
      test_book2 = Book.new({:id => nil, :title => "Review Ruby", :author_id => test_author.id()})
      test_book2.save()
      expect(test_author.books()).to(eq([test_book, test_book2]))
    end
  end

  describe('#update') do
    it('lets you update authors in the database') do
      author = Author.new({:name => "Stephen King", :id => nil})
      author.save()
      author.update({:name => "Homework Stuff"})
      expect(author.name()).to(eq("Homework Stuff"))
    end
    it("lets you associate an author to a book") do
      author = Author.new({:name => "Stephen King", :id => nil})
      author.save()
      it = Book.new({:id => nil, :title => "IT", :author_id => nil})
      it.save()
      mist = Book.new({:id => nil, :title => "The Mist", :author_id => nil})
      mist.save()
      author.update({:book_ids => [it.id(), mist.id()]})
      expect(author.books()).to(eq([it, mist]))
    end
  end


  end
  describe("#delete") do
    it("lets you delete a author from the database") do
      author = Author.new({:name => "Epicodus stuff", :id => nil})
      author.save()
      author2 = Author.new({:name => "House stuff", :id => nil})
      author2.save()
      author.delete()
      expect(Author.all()).to(eq([author2]))
    end
    it("deletes a author's books from the database") do
      author = Author.new({:name => "Epicodus stuff", :id => nil})
      author.save()
      book = Book.new({:id => nil, :title => "learn SQL", :author_id => author.id()})
      book.save()
      book2 = Book.new({:id => nil,:title => "Review Ruby", :author_id => author.id()})
      book2.save()
      author.delete()
      expect(Book.all()).to(eq([]))
    end
  end
