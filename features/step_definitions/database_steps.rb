Then (/^transaction status in DB is (AUTH|CAPTURED|DECLINED_ACQUIRER|DECLINED_CARD|DECLINED_INTERNAL|REVERSED|SYSTEM_ERROR)$/) do |tx_status|
  tx = DB::Transaction.find_by(server_transaction_id: $sharedState.tx.server_transaction_id)
  assert_equal(tx_status, tx.transaction_status.name, 'Wrong TRANSACTIONS.CURRENT_STATUS_ID in DB')
end