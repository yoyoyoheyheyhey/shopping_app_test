require "spec_helper"

RSpec.describe Customer do
  let(:customer) { build(:customer) }
  let(:seller) { build(:seller) }
  let(:item) { build(:item, owner: seller) }

  it "Userを継承していること" do
    expect(Customer.superclass).to eq User
  end

  describe "#initialize" do
    it "@nameを持つこと" do
      expect(customer.instance_variable_get(:@name)).to be_truthy
    end
    it "自身がownerとなっている@walletを持つこと" do
      expect(customer.instance_variable_get(:@wallet).owner).to eq customer
    end
    it "自身がownerとなっている@cartを持つこと" do
      expect(customer.instance_variable_get(:@cart).owner).to eq customer
    end
  end

  describe "#wallet" do
    it "自身がownerとなっているWalletオブジェクトを返すこと" do
      wallet = customer.wallet
      expect(wallet.class == Wallet).to eq true
      expect(wallet.owner == customer).to eq true
    end
    it "'#wallet='は定義されていないこと（attr_readerを使っていること）" do
      expect(customer.methods.include?(:wallet=)).to eq false
    end
  end

  describe "#cart" do
    it "自身がownerとなっているCartオブジェクトを返すこと" do
      cart = customer.cart
      expect(cart.class == Cart).to eq true
      expect(cart.owner == customer).to eq true
    end
    it "'#cart='は定義されていないこと（attr_readerを使っていること）" do
      expect(customer.methods.include?(:cart=)).to eq false
    end
  end

  describe "#check_out" do
    let(:balance) { 99999999999 }
    before do
      customer.wallet.deposit(balance)
      customer.cart
    end
    it "購入処理を行い、価値の移転がされること" do
      # check_out前
      expect(customer.wallet.balance == balance).to eq true
      expect(item.owner == seller).to eq true
      expect(seller.wallet.balance == 0).to eq true
      
      customer.cart.add(item)
      customer.check_out

      # check_out後
      expect(customer.wallet.balance == balance - item.price).to eq true 
      expect(item.owner == customer).to eq true 
      expect(seller.wallet.balance == item.price).to eq true 
    end
  end
  
end