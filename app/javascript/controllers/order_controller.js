import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [
    'order_code',
    'mobile_phone',
    'find',
    'user_order_info',
    'verify_form',
    'verify_sms_code',
    'current_order'
  ]

  findOrder(){
    Rails.ajax({
      type: "GET",
      url: "/cancel_my_order/find_user_order",
      data: "order_code=" + this.order_codeTarget.value + "&mobile_phone=" + this.mobile_phoneTarget.value,
        success: (data) => {
          this.user_order_infoTarget.innerHTML = data.body.innerHTML
        }
    });
  }

  button(){
    this.verify_formTarget.hidden = false;
    Rails.ajax({
      type: "POST",
      url: "/cancel_my_order/send_user_verification",
      data: "current_order_id=" + this.current_orderTarget.innerHTML,
    });
  }

  message(){
    Rails.ajax({
      type: "POST",
      url: "/cancel_my_order/verify_user_code",
      data: "current_order_id=" + this.current_orderTarget.innerHTML + "&code_input=" + this.verify_sms_codeTarget.value,
      success: (data) => {
        if(data){
          this.missingTarget.innerHTML = data.body.innerHTML
        }
      }
    });
  }
}