require('pry')

class Author
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    returned_authors.each() do |author|
      name = author.fetch("name")
      id = author.fetch("id").to_i()
      authors.push(Author.new({:name => name, :id => id}))
    end
    authors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |another_author|
    self.name().==(another_author.name()).&(self.id().==(another_author.id()))
  end

  define_singleton_method(:find) do |id|
    result = DB.exec("SELECT * FROM authors WHERE id = #{id};")
    name = result.first().fetch('name')
    Author.new({:name => name, :id => id})
  end

  define_method(:books) do
    author_books = []
    results = DB.exec("SELECT book_id FROM checkout WHERE author_id = #{self.id()};")
    results.each() do |result|
      book_id = result.fetch("book_id").to_i()
      book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      title = book.first().fetch("title")
      author_books.push(Book.new({:id => book_id, :title => title}))
    end
    author_books
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id};")

    attributes.fetch(:book_ids, []).each() do |book_id|
    DB.exec("INSERT INTO checkout (book_id, author_id) VALUES (#{book_id}, #{self.id()});")
  end
end
  define_method(:delete) do
    DB.exec("DELETE FROM checkout WHERE author_id = #{self.id()};")
    DB.exec("DELETE FROM authors WHERE id = #{self.id()};")
  end
end
