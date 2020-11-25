require "test_helper"

describe OrderItem do
    before do # a test case that will pass all validations
        @product = products(:product_one) #from fixtures
        @order = orders(:second_order)
        @order_item = OrderItem.create!(product_id: @product.id, order_id:@order.id, quantity: 4)
    end

    describe 'validations' do

        it 'should be a valid order_item when all fields are filled' do

          expect(@order_item.valid?).must_equal true

        end

        it 'fails validation quanity is less than 0' do

            @order_item.quantity = -1
            expect(@order_item.valid?).must_equal false

        end

        it 'fails validation when order_id is missing' do

            @order_item.order_id = nil
            expect(@order_item.valid?).must_equal false

        end

        it 'fails validation when product_id is missing' do

            @order_item.product_id = ''
            expect(@order_item.valid?).must_equal false

        end
    end

    describe 'relations' do

        it 'belongs to an Order' do

            expect(@order_item).must_respond_to :order
            expect(@order_item.order).must_be_kind_of Order

        end

        it 'belongs to a Product' do

            expect(@order_item).must_respond_to :product
            expect(@order_item.product).must_be_kind_of Product

        end

    end

    describe 'change_quantity' do

        it 'changes quantity when updates' do

        @order_item.add_quantity(7)
        expect( @order_item.quantity).must_equal 11

        end

        it 'changes quantity when updates' do

            @order_item.change_quantity(7)
            expect( @order_item.quantity).must_equal 7
    
            end
    end
  
end
