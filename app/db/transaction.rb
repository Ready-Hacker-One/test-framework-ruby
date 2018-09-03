module DB
  class Transaction < ActiveRecord::Base
    has_one :transaction_status, :primary_key => :current_status_id, :foreign_key => :id

    attr_accessor :client_transaction_id, :server_transaction_id, :transaction_code, :server_time_created_at,
                  :amount, :currency, :vat_amount, :tip_amount, :total_fee, :merchant_id, :tx_result
  end
end