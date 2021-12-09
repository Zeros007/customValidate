require_relative 'custom_validate.rb'

class Book
    include CustomValidate
    attr_accessor :author, :genre, :page_quantity
    
    validate :author, format: /^[a-z ,.'-]+$/i, presence: true
    validate :genre, format: /\A[a-zA-Z]+\z/ 
    validate :page_quantity, type: BasicObject, format: /^\d+$/
    
    def page_quantity
        @page_quantity = 'Ten' 
    end

    def genre
        @genre = "Fantasy1"
    end

end

book = Book.new
book.author = "John Smith"
# if book.author = "John Smith0" || nil || "" -> raise format error or presence error
book.page_quantity
book.genre
# page_quantity and genre added to book object
p book.validate!
# => Return 3 validate exception 
p book.valid?
# => Return true only if all validation were performed correctly