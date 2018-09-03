module DB
  class Activation < ActiveRecord::Base
    self.primary_key = 'merchant_id'
  end
end
