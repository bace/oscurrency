require 'spec_helper'
require 'cancan/matchers'

describe Group do
  fixtures :people, :groups

  before(:each) do
    @p = people(:quentin)
    @p2 = people(:aaron)
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :mode => Group::PUBLIC,
      :unit => "value for unit",
      :asset => "infinities",
      :adhoc_currency => true
    }
    @g = Group.new(@valid_attributes)
    @g.owner = @p
    @g.save!
  end

  describe 'attributes' do
    it "should not be able to update someone else's group" do
      ability = Ability.new(@p2)
      expect(ability).to_not be_able_to(:update,@g)
    end

    it "should be able to update own group" do
      ability = Ability.new(@p)
      expect(ability).to be_able_to(:update,@g)
    end
  end

  describe 'roles' do
    before(:each) do
      Membership.request(@p2,@g,false)
      @membership = Membership.mem(@p2,@g)
      @ability = Ability.new(@p2)
    end

    describe 'attributes accessed by members' do
      it "should not allow an unauthorized member to update a group" do
        @membership.roles = ['individual']
        @membership.save
        expect(@ability).to_not be_able_to(:update,@g)
      end

      it "should allow an admin member to update a group" do
        @membership.roles = ['individual','admin']
        @membership.save
        expect(@ability).to be_able_to(:update,@g)
      end

      it "should not allow an admin member to update another admin membership" do
        @membership.roles = ['individual','admin']
        @membership.save

        @p3 = people(:buzzard)
        Membership.request(@p3,@g,false)
        @membership_sneaky_admin = Membership.mem(@p3,@g)
        @ability_sneaky_admin = Ability.new(@p3)
        @membership_sneaky_admin.roles = ['individual','admin']
        @membership_sneaky_admin.save
        expect(@ability_sneaky_admin).to_not be_able_to(:update,@membership)
      end

      it "should allow an admin to update her own membership" do
        @membership.roles = ['individual','admin']
        @membership.save
        expect(@ability).to be_able_to(:update,@membership)
      end
    end

    describe 'forum posts made by non-members' do
      before(:each) do
        @forum = @g.forum
        @topic = @forum.topics.new(:name => 'test topic')
        @topic.person = @p
        @topic.save!
      end

      it "should allow a member to make a forum post" do
        @forum_post = @topic.posts.build(:body => "Should we talk about the weather?")
        @forum_post.person = @p2
        expect(@ability).to be_able_to(:create,@forum_post)
      end

      it "should not allow a non-member to make a forum post if forum is not world writable" do
        @forum.worldwritable = false
        @forum.save!

        @p3 = people(:buzzard)
        @ability_nonmember = Ability.new(@p3)
        @forum_post = @topic.posts.build(:body => "Should we talk about the weather?")
        @forum_post.person = @p3

        expect(@ability_nonmember).to_not be_able_to(:create,@forum_post)
      end

      it "should allow a non-member to make a forum post if forum is world writable" do
        @forum.worldwritable = true
        @forum.save!

        @p3 = people(:buzzard)
        @ability_nonmember = Ability.new(@p3)
        @forum_post = @topic.posts.build(:body => "We have to do it in part as a matter of social responsibility to other people who are going to live in the world that we make.")
        @forum_post.person = @p3

        expect(@ability_nonmember).to be_able_to(:create,@forum_post)
      end
    end

    describe 'offers made by people' do
      it "should not allow a non-member of a group to create an offer" do
        @p3 = people(:buzzard)
        @ability_nonmember = Ability.new(@p3)
        @offer = Offer.new(:name => "Pizza", :group => @g, :price => 5, :expiration_date => Date.today,:available_count => 1, :person => @p3)
        expect(@ability_nonmember).to_not be_able_to(:create,@offer)
      end

      it "should allow a member of a group to create an offer" do
        @offer = Offer.new(:name => "Pizza", :group => @g, :price => 5, :expiration_date => Date.today,:available_count => 1, :person => @p2)
        expect(@ability).to be_able_to(:create,@offer)
      end

    end

    describe 'reqs made by people' do
      before(:each) do
        @p = people(:quentin)
        @p2 = people(:aaron)
        @nocurrency_valid_attributes = {
          :name => "group name",
          :description => "value for description",
          :mode => Group::PUBLIC,
          :adhoc_currency => false
        }
        @g_nocurrency = Group.new(@nocurrency_valid_attributes)
        @g_nocurrency.owner = @p
        @g_nocurrency.save!

        Membership.request(@p2,@g_nocurrency,false)
        @membership = Membership.mem(@p2,@g_nocurrency)
        @ability = Ability.new(@p2)
      end

      it "should allow a member of a group without a currency to create a request" do
        @req = Req.new(person: @p2, group: @g_nocurrency, name:'test req', description:'test req description', estimated_hours:3, due_date:1.day.from_now, biddable:true, active:true)
        @req.save!
        expect(@req).to be_valid
      end

      it "should allow a member of a group without a currency to approve a bid" do
        @pref = Account.global_prefs
        @pref.default_group_id = @g.id
        @pref.save!

        @req = Req.new(person: @p2, group: @g_nocurrency, name:'test req', description:'test req description', estimated_hours:3, due_date:1.day.from_now, biddable:true, active:true)
        @req.save!
       
        @bid_valid_attributes = {
          estimated_hours: 3
        }
        @bid = @req.bids.new(@bid_valid_attributes)
        @bid.person = @p
        @bid.save!
        @bid.accept!
        @bid.req.ability = @ability
        @bid.pay!
        expect(@bid).to be_valid
      end
    end

    describe 'exchanges made by members' do
      before(:each) do
        @e = @g.exchange_and_fees.build(amount: 1.0)
        @e.worker = @p
        @e.notes = 'Generic'
      end

      it "should not allow a non-member of a group to make an exchange" do
        @p3 = people(:buzzard)
        @e.customer = @p3
        @ability_nonmember = Ability.new(@p3)
        expect(@ability_nonmember).to_not be_able_to(:create,@e)
      end

      it "should allow a regular member of a group to make an exchange" do
        # if the customer is not specified, the current_person is the payer
        expect(@ability).to be_able_to(:create,@e)
      end

      it "should not allow an individual member to make an unauthorized payment" do
        @e.customer = @p2
        @membership.roles = ['individual']
        @membership.save
        account = @p2.account(@g)
        account.balance = 0.0
        account.credit_limit = 0.5
        account.save!
        expect(@ability).to_not be_able_to(:create,@e)
      end

      it "should not allow an individual member to make a worker initiated payment" do
        # @p2 is worker/seller
        @membership.roles = ['individual']
        @membership.save
        @e_seller_initiated = Exchange.new(customer_id: @p.id, group_id: @g.id, amount: 1.0)
        @e_seller_initiated.metadata = @req
        @e_seller_initiated.worker = @p2
        expect(@ability).to_not be_able_to(:create,@e_seller_initiated)
      end

      it "should allow a point of sale operator to make a worker initiated payment" do
        # @p2 is worker/seller
        @membership.roles = ['point_of_sale_operator']
        @membership.save
        @e_seller_initiated = Exchange.new(customer_id: @p.id, group_id: @g.id, amount: 1.0)
        @e_seller_initiated.metadata = @req
        @e_seller_initiated.worker = @p2
        expect(@ability).to be_able_to(:create,@e_seller_initiated)
      end

      describe 'account balances' do
        before(:each) do
          @membership.roles = ['individual']
          @membership.save
          account = @p2.account(@g)
          account.balance = 10.0
          account.earned = 100.0
          account.paid = 90.0
          account.save!
          @e.customer = @p2
        end

        it "should update account balance when a payment is created" do
          @e.save!
          account_after_payment = @p2.account(@g)
          expect(account_after_payment.balance).to eq(9.0)
        end

        it "should update account balance when a payment is deleted" do
          @e.save!
          @e.destroy
          account_after_payment_deletion = @p2.account(@g)
          expect(account_after_payment_deletion.balance).to eq(10.0)
        end

        it "should update account paid when a payment is created" do
          @e.save!
          payer_account_after_payment = @p2.account(@g)
          expect(payer_account_after_payment.paid).to eq(91.0)
        end

        it "should update account paid when a payment is deleted" do
          @e.save!
          @e.destroy
          payer_account_after_payment_deletion = @p2.account(@g)
          expect(payer_account_after_payment_deletion.paid).to eq(90.0)
        end

        it "should allow a transaction fee to be sent to a reserve account" do
          @p3 = people(:buzzard)
          Membership.request(@p3,@g,false)
          @membership_buzzard = Membership.mem(@p3,@g)
          @membership_buzzard.save!
          @account_buzzard = @membership_buzzard.account
          @account_buzzard.balance = 10.0
          @account_buzzard.reserve_percent = 0.1
          @account_buzzard.reserve = true
          @account_buzzard.save!

          @membership_quentin = Membership.mem(@p,@g)
          @account_quentin = @membership_quentin.account
          @account_quentin.balance = 10.0
          @account_quentin.save!

          @e.customer = @p2
          @e.amount = 2.00
          @e.save!

          account_buzzard_after_payment = @p3.account(@g)
          expect(account_buzzard_after_payment.balance).to eq(10.2)

          account_quentin_after_payment = @p.account(@g)
          expect(account_quentin_after_payment.balance).to eq(11.8)
        end

        it "should not allow the sum of reserve percentages to exceed 1" do
          @membership.roles = ['individual','admin']
          @membership.save

          @p3 = people(:buzzard)
          Membership.request(@p3,@g,false)
          @membership_buzzard = Membership.mem(@p3,@g)
          @membership_buzzard.save!

          @account_buzzard = @membership_buzzard.account
          @account_buzzard.balance = 10.0
          @account_buzzard.reserve_percent = 1.01
          @account_buzzard.reserve = true

          expect(@ability).to_not be_able_to(:update,@account_buzzard)
        end

      end
    end
  end

  describe 'group default credit limit' do
    before(:each) do
      @g.default_credit_limit = 40.0
    end

    it "should set the account balance of a new member" do
      Membership.request(@p2,@g,false)
      account = @p2.account(@g)
      expect(account.credit_limit).to eq(40.0)
    end

    it "should update the account balance of an existing member when update" do
      Membership.request(@p2,@g,false)
      @g.default_credit_limit = 50.0
      @g.save
      account = @p2.account(@g)
      expect(account.credit_limit).to eq(50.0)
    end
  end
end
