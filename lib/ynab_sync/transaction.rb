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
    puts @wrapped_transaction.transfer_account_id
    false
  end
end

class YnabSync::PlaidTransaction < YnabSync::Transaction
  def initialize(plaid_transaction)
    @wrapped_transaction = plaid_transaction
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
    false
  end
end
