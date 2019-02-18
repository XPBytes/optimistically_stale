# frozen_string_literal: true

require 'optimistically_stale/version'
require 'active_record'

module OptimisticallyStale
  class MissingLockVersion < ArgumentError
    def initialize(column: 'lock_version')
      super 'Attribute \'%s\' is required.' % column
    end
  end

  ##
  # Checks if a record is valid to update, whilst enforcing optimistic locking using +lock_version+.
  #
  # @return [TrueClass]
  #
  # @throws MissingLockVersion
  #   when the +lock_version+ is missing in +attributes+
  #
  # @throws ActiveRecord::StaleObjectError
  #   when the +lock_version+ from +attributes+ does not match the version of +record+
  #
  # @example Check a record before updating
  #
  #   class UpdateBook
  #     include Command
  #
  #     def call(book:, attributes:)
  #       book.update(attributes)
  #     end
  #
  #     def valid?(book:, attributes:)
  #       valid_for_update?(record: :book, attributes: attributes)
  #     end
  #   end
  #
  #   book = Book.first
  #   attributes = { lock_version: book.lock_version, title: 'new book title' }
  #   result = UpdateBook.call(book: book, attributes: attributes)
  #
  #   result.successful? # => true
  #   book.title # => 'new book title'
  #
  # @example Because the book version has changed, another update fails
  #
  #   attributes[:title] = 'another title'
  #   result = UpdateBook.call(book: book, attributes: attributes)
  #
  #   # => throws ActiveRecord::StaleObjectError
  #
  def valid_for_update?(record:, attributes:, lock_column: :lock_version)
    source_lock_version = attributes.delete(lock_column)

    raise MissingLockVersion.new(column: lock_column) unless source_lock_version.present?
    raise ActiveRecord::StaleObjectError.new(record, 'update') unless record[lock_column] == source_lock_version.to_i

    true
  end
end
