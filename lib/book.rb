class Book
  attr_reader(:id, :title)

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @title = attributes.fetch(:title)
  end

  define_singleton_method(:all) do
    returned_book = DB.exec("SELECT * FROM books;")
    books = []
    returned_book.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i()
      books.push(Book.new({:id => id, :title => title}))
    end
    books
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  define_method(:==) do |another_book|
    self.title().==(another_book.title()).&(self.id().==(another_book.id()))
  end

  define_singleton_method(:find) do |id|
    result = DB.exec("SELECT * FROM books WHERE id = #{id};")
    title = result.first().fetch('title')
    Book.new({:title => title, :id => id})
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

  define_method(:delete) do
    DB.exec("DELETE FROM checkout WHERE book_id = #{self.id()};")
    DB.exec("DELETE FROM books WHERE id = #{self.id()};")
  end
end
