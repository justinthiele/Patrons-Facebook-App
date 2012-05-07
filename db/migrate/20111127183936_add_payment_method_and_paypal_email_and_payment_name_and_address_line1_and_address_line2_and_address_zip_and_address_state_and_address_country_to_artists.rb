class AddPaymentMethodAndPaypalEmailAndPaymentNameAndAddressLine1AndAddressLine2AndAddressZipAndAddressStateAndAddressCountryToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :payment_method, :string
    add_column :artists, :paypal_email, :string
    add_column :artists, :payment_name, :string
    add_column :artists, :address_line1, :string
    add_column :artists, :address_line2, :string
    add_column :artists, :address_zip, :string
    add_column :artists, :address_state, :string
    add_column :artists, :address_country, :string
  end

  def self.down
    remove_column :artists, :address_country
    remove_column :artists, :address_state
    remove_column :artists, :address_zip
    remove_column :artists, :address_line2
    remove_column :artists, :address_line1
    remove_column :artists, :payment_name
    remove_column :artists, :paypal_email
    remove_column :artists, :payment_method
  end
end
