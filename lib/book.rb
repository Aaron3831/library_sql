class Book
  attr_reader(:id, :title, :author_id)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @title = attributes.fetch(:title)
    @author_id = attributes.fetch(:author_id)
  end

  define_singleton_method(:all) do
    returned_book = DB.exec("SELECT * FROM books;")
    books = []
    returned_book.each() do |book|
      title = book.fetch("title")
      author_id = book.fetch("author_id").to_i() # The information comes out of the database as a string.
      id = book.fetch("id").to_i()
      books.push(Book.new({:id => id, :title => title, :author_id => author_id}))
    end
    books
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title, author_id) VALUES ('#{@title}', #{@author_id}) RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  define_method(:==) do |another_book|
    self.title().==(another_book.title()).&(self.author_id().==(another_book.author_id()))
  end

  define_singleton_method(:find) do |id|
    found_book = nil
    Book.all().each() do |book|
      if book.id() == id.to_i()
        found_book = book
      end
    end
    found_book
  end

  define_method(:update) do |attributes|
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{self.id};")

    attributes.fetch(:author_id, []).each() do |author_id|
    DB.exec("INSERT INTO checkout (author_id, book_id) VALUES (#{author_id}, #{self.id()});")
  end
end

define_method(:authors) do
  checkout = []
  results = DB.exec("SELECT author_id FROM checkout WHERE book_id = #{self.id()};")
  results.each() do |result|
    author_id = result.fetch("author_id").to_i()
    author = DB.exec("SELECT * FROM authors WHERE id = #{author_id};")
    name = author.first().fetch("name")
    checkout.push(Author.new({:name => name, :id => author_id}))
  end
  checkout
end



end
