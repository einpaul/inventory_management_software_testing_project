class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = Transaction.all
  end

  def show
  end

  def new
    @transaction = Transaction.new
    @products = Product.all
    @suppliers = Supplier.all
  end

  def edit
  end


  def create
    if Product.find_by_id(params[:transaction][:product_id]).remaining_quantity >= params[:transaction][:quantity].to_i
      @transaction = Transaction.new(transaction_params)
      if @transaction.save
        @current_user = current_user
        @transacted_product = Product.find_by_id(params[:transaction][:product_id])
        @transacted_product.decrement!(:remaining_quantity, params[:transaction][:quantity].to_i)
        redirect_to transactions_path, notice: 'Transaction was successfully created.'
      else
        render :new
      end
    else
      flash[:alert] = 'The quantity you entered is not currently available'
      redirect_to :back
    end
  end

  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction.destroy
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:transaction_id, :product_id, :supplier_id, :quantity)
    end
end
