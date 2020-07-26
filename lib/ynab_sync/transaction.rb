class YnabSync::Transaction
  def self.from_plaid(plaid_transaction)
    new(
      date: plaid_transaction.date,
      amount: (plaid_transaction.amount * 1000 * -1).to_i,
      memo: plaid_transaction.name
    )
  end

  attr_accessor :date,
                :amount,
                :memo

  def initialize(date:, amount:, memo:)
    @date = date
    @amount = amount
    @memo = memo
  end

  def id
    "(#{@amount}|#{@date}|#{@memo})"
  end
end
