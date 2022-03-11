class CancelMyOrderController < ApplicationController

  def find_user_order
    @orders = Order.find_by(order_code: params[:order_code])
    if @orders&.patient&.mobile_phone == params[:mobile_phone]
      render partial: 'step1'
    else
      render partial: 'missing'
    end
  end

  def send_user_verification
    find_current_order
    sms = Web::VerifySmsService.new(@current_order, @booking_id).call
    SendVerifySmsWorker.perform_async(sms.id)
  end

  def verify_user_code
    find_current_order
    current_sms = VerifySmsMessage.where(booking_id: @booking_id).last
    if current_sms.code == params[:code_input]
      redirect_to root_path if @current_order.update(finished: false)
    else
      render partial: 'missing'
    end
  end

  private

  def find_current_order
    @current_order = Order.find(params[:current_order_id])
    @booking_id = Booking.find_by(order: @current_order).id
  end
end