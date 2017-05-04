require('spec_helper')

describe(Book) do
  describe(".all") do
    it("is empty at first") do
      expect(Book.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("adds a book to the array of saved books") do
      test_book = Book.new({:title => "learn SQL", :id => nil })
      test_book.save()
      expect(Book.all()).to(eq([test_book]))
    end
  end

  describe("#title") do
    it("lets you read the title out") do
      test_book = Book.new({:id => nil, :title => "learn SQL", :author_id => 1})
      expect(test_book.title()).to(eq("learn SQL"))
    end
  end

  describe("#==") do
    it("is the same book if it has the same title and author ID") do
      book1 = Book.new({:id => nil, :title => "learn SQL", :author_id => nil})
      book2 = Book.new({:id => nil, :title => "learn SQL", :author_id => nil})
      expect(book1).to(eq(book2))
    end
  end

  describe(".find") do
    it("returns a book by its ID") do
      test_book = Book.new({:id => nil,:title => "Epicodus stuff", :author_id => 1})
      test_book.save()
      test_book2 = Book.new({:id => nil,:title => "Home stuff", :author_id => 1})
      test_book2.save()
      expect(Book.find(test_book2.id)).to(eq(test_book2))
    end
  end

  describe("#update") do
    it("lets you update books in the database") do
      book = Book.new({:title => "Oceans Eleven", :author_id => 1, :id => nil})
      book.save()
      book.update({:title => "Oceans Twelve"})
      expect(book.title()).to(eq("Oceans Twelve"))
    end
  end

  describe("#authors") do
  it("returns all of the authors for a particular book") do
    author = Author.new(:name => "Stephen King", :id => nil)
    author.save()
    author2 = Author.new(:name => "Homer", :id => nil)
    author2.save()
    book = Book.new(:title => "IT", :author_id => nil, :id => nil)
    book.save()
    book.update(:author_id => [author.id()])
    book.update(:author_id => [author2.id()])

    expect(book.authors()).to(eq([author, author2]))
  end
end

end
