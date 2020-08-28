require 'byebug'

class YnabSync::Transaction
  def id
    "(#{self.amount}|#{self.date}|#{self.memo})"
  end

  def ==(other)
    return true if is_same_transfer? other

    id == other.id
  end

  def is_same_transfer?(other)
    return false if !is_transfer? || !other.is_transfer?
    return false if amount + other.amount != 0
    return false if false # dates are close enough

    return true
  end
end

class YnabSync::YnabTransaction < YnabSync::Transaction
  def initialize(ynab_transaction)
    @wrapped_transaction = ynab_transaction
  end

  def date
    @wrapped_transaction.date
  end

  def amount
    @wrapped_transaction.amount
  end

  def memo
    @wrapped_transaction.memo
  end

  def is_transfer?
    false
  end
end

class YnabSync::PlaidTransaction < YnabSync::Transaction
  def initialize(
    plaid_transaction,
    categorizations:,
    transfer_qualifying_names:
  )
    @wrapped_transaction = plaid_transaction
    @categorizations = categorizations
    @transfer_qualifying_names = transfer_qualifying_names
  end

  def date
    @wrapped_transaction.date
  end

  def amount
    (@wrapped_transaction.amount * 1000 * -1).to_i
  end

  def memo
    @wrapped_transaction.name
  end

  def is_transfer?
    @transfer_qualifying_names.any? do |name|
      @wrapped_transaction.name.include? name
    end
  end

  def category
    @category ||= find_category
  end

  def find_category
    categorization = @categorizations.find do |c|
      @wrapped_transaction.name.include? c["name"]
    end

    if categorization.nil?
      {}
    else
      {
        payee_id: categorization["payee_id"],
        category_id: categorization["category_id"]
      }.compact
    end
  end
end
