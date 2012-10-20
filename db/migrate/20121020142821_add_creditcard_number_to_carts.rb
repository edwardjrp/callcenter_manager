class AddCreditcardNumberToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :creditcard_number, :string
    add_column :carts, :fiscal_company_name, :string
    add_column :tax_numbers, :company_name, :string
  end
end
