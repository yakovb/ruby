require_relative 'library'
require 'test/unit'

class TC_Library < Test::Unit::TestCase

  def setup
    @lib = Library.instance
  end

  def teardown
    Library.reset
    Calendar.reset
  end

  def test_initialize_single_library
    assert_raise(NoMethodError) { Library.new }
  end

  def test_initialize_makes_calendar
    assert_nothing_raised { @lib.calendar.get_date }
  end

  # TODO
  def test_load_books
  end

  def test_close_on_closed
    assert_raise(Exception) { @lib.close }
  end

  def test_close_on_open
    assert_nothing_raised {
      @lib.open
      @lib.close
    }
  end

  def test_open_on_closed
    assert_nothing_raised { @lib.open }
  end

  def test_open_on_closed_with_msg
    str = @lib.open
    assert str == 'Today is day 1.', "Message should be 'Today is day 1.' but was '#{str}'"
  end

  def test_open_on_open
    assert_raise(Exception) { 2.times {@lib.open} }
  end

  def test_issue_card_to_new_member
    @lib.open
    str = @lib.issue_card('person')
    assert str == 'Library card issued to person', "Returned wrong string: #{str}"
  end

  def test_issue_card_to_existing_member
    @lib.open
    @lib.issue_card('person')
    str = @lib.issue_card('person')
    assert str == 'person already has a library card.', "Returned wrong string: #{str}"
  end

  def test_issue_card_library_closed
    assert_raise(Exception) { @lib.issue_card('person') }
  end

  def test_serve_existing_member
    @lib.open
    @lib.issue_card('person')
    assert @lib.serve('person') == 'Now serving person.'
  end

  def test_serve_non_existent_member
    @lib.open
    str = @lib.serve('person')
    assert str == 'person does not have a library card.', "Returned wrong string: #{str}"
  end

  def test_quit
    assert @lib.quit == 'The library is now closed for renovations.', 'Quit message was wrong'
  end

end


class TC_Calendar < Test::Unit::TestCase
  def setup
    @cal = Calendar.instance
  end

  def teardown
    Calendar.reset
  end

  def test_initialize_single_calendar
    assert_raise(NoMethodError) { Calendar.new }
  end

  def test_create_and_advance
    assert @cal.get_date == 0, 'date at creation should be 0'
    assert @cal.advance == 1, 'date after one advance() should be 1'
  end
end


class TC_Book < Test::Unit::TestCase
  def setup
    @b = Book.new(1, 'title', 'author')
  end
  def teardown
    @b = nil
  end

  def test_initialize_book_and_getters
    assert @b.get_id == 1, 'Book id should be 1'
    assert @b.get_title == 'title', 'Book title should be "title"'
    assert @b.get_author == 'author', 'Book author should be "author"'
  end

  def test_new_book_bad_id
    assert_raise(Exception) { Book.new('x', 't', 'a') }
  end

  def test_new_book_duck_id
    assert_nothing_raised { Book.new('3', 't', 'a') }
  end

  def test_get_duedate_for_new_book
    assert @b.get_due_date == nil, 'Due date should be nil for a new book'
  end

  def test_checkout_returns_nil
    assert @b.check_out(3) == nil, 'Checkout should return nil'
  end

  def test_checkout_bad_duedate
    assert_raise(Exception) { @b.check_out 'ten' }
  end

  def test_checkout_and_get_duedate
    @b.check_out 20
    assert @b.get_due_date == 20, 'Book due date should be 20'
  end

  def test_checkin
    @b.check_out(3)
    @b.check_in
    assert @b.get_due_date == nil, 'Due date of checked in book should be nil'
  end

  def test_to_s
    assert @b.to_s == '1: title, by author', 'Book.to_s returns wrong string'
  end
end


class TC_Member < Test::Unit::TestCase

  class DummyBook
    attr_accessor :id, :title, :author
    def initialize(id, title, author)
      @id = id
      @title = title
      @author = author
    end
    def to_s
      "Dummy Book"
    end
  end

  def setup
    @m = Member.new 'Bob', :lib
  end

  def teardown
    @m = nil
  end

  def test_initialize_and_get_name
    assert @m.get_name == 'Bob', 'New member should be called Bob'
  end

  def test_check_out_one_book
    @m.check_out 'a book'
    assert @m.get_books.size == 1, 'Member should only have one book checked out'
  end

  def test_check_out_4_books
    assert_raise(Exception) { 4.times { @m.check_out 'a book' } }
  end

  def test_give_back_success_message
    b = DummyBook.new(1, 'aTitle', 'aAuthor')
    @m.check_out(b)
    assert @m.give_back(b) == 'Returned Dummy Book', 'Giving back a book should return string signifying success'
  end

  def test_give_back_successful_removal
    b = DummyBook.new(1, 'aTitle', 'aAuthor')
    @m.check_out(b)
    @m.give_back(b)
    puts @m.get_books
    assert @m.get_books == [], 'Books array should be empty after 1 book is checked out then checked back in'
  end

  def test_give_back_unsuccessful_message
    b = DummyBook.new(1, 'aTitle', 'aAuthor')
    assert @m.give_back(b) == 'This member did not recently check out Dummy Book', 'Giving back a book the member does not have should return failure message'
  end

  def test_get_books_empty
    assert @m.get_books == [], 'New member should not have any books'
  end
end