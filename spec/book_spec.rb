require('spec_helper')

describe(Book) do
  describe(".all") do
    it("is empty at first") do
      expect(Book.all()).to(eq([]))
    end
  end

  describe("#save") do
    it("adds a book to the array of saved books") do
      test_book = Book.new({:id => nil, :title => "learn SQL", :author_id => 1})
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

  describe("#author_id") do
    it("lets you read the author ID out") do
      test_book = Book.new({:id => nil, :title => "learn SQL", :author_id => 1})
      expect(test_book.author_id()).to(eq(1))
    end
  end

  describe("#==") do
    it("is the same book if it has the same title and author ID") do
      book1 = Book.new({:id => nil, :title => "learn SQL", :author_id => 1})
      book2 = Book.new({:id => nil, :title => "learn SQL", :author_id => 1})
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

end
