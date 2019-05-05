require 'rails_helper'

RSpec.describe OrderMailer, type: :mailer do

    @user_data = read_fixture_file('user.json')
    @supplier_data = read_fixture_file('supplier.json')
    @category_data = read_fixture_file('category.json')
    @product_data = read_fixture_file('product.json')
    @order_data = read_fixture_file('order.json')

    let(:user) { User.create( name: @user_data["mailer_user"]["name"],
                              email: @user_data["mailer_user"]["email"],
                              password: @user_data["mailer_user"]["password"],
                              password_confirmation: @user_data["mailer_user"]["password_confirmation"],
                              role: @user_data["mailer_user"]["role"] )}
    binding.pry
    let(:supplier) { Supplier.create(name: @supplier_data["supplier_mailer"]["name"],
                                     email: @supplier_data["supplier_mailer"]["email"],
                                     phone: @supplier_data["supplier_mailer"]["phone"],
                                     status: @supplier_data["supplier_mailer"]["status"] )}

    let(:category) { Category.create(name: @category_data["name"])}

    let(:product) { Product.create(name: @product_data["product_for_mailer"]["name"],
                                   quantity: @product_data["product_for_mailer"]["quantity"],
                                   category_id: Category.last.id,
                                   code: @product_data["product_for_mailer"]["code"])}

    let(:order) { Order.create( quantity: '234',
                                product_id: Product.last.id,
                                supplier_id: Supplier.last.id ) }

  describe 'order_mailer' do

    let(:mail) { OrderMailer.create_order(order, user) }

    context 'create order' do
      it 'renders the subject' do
        expect(mail.subject).to eq(order.supplier.name + " ordered " + order.quantity + " x " + order.product.name + " from " + user.name)
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([order.supplier.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['ein.paul@gmail.com'])
      end

      it 'assigns @name' do
        expect(mail.body.encoded).to match(user.name)
      end
    end
  end

  describe 'cancel order' do
    let(:mail) { OrderMailer.cancel_order(order, user) }

    it 'renders the subject' do
      expect(mail.subject).to eq("An order regarding " + order.quantity + " product(s) ordered by " + order.supplier.name + " has been canceled from " + user.name)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([order.supplier.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['ein.paul@gmail.com'])
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(user.name)
    end
  end

  describe 'cancel order' do
    let(:mail) { OrderMailer.return_order(order, user) }

    it 'renders the subject' do
      expect(mail.subject).to eq(order.quantity + " product(s) ordered by " + order.supplier.name + " have been marked as returned from " + user.name)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([order.supplier.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['ein.paul@gmail.com'])
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(user.name)
    end
  end
end