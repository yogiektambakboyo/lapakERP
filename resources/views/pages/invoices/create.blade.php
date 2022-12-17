@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Invoice')

@section('content')
<form method="POST" action="{{ route('invoices.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Sales Invoice</h4></div>
      <div class="">
        <a href="{{ route('invoices.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-4">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">Date (mm/dd/YYYY)</label>
              <div class="col-md-8">
                <input type="text" 
                name="invoice_date"
                id="invoice_date"
                class="form-control" 
                value="{{ old('invoice_date') }}" required/>
                @if ($errors->has('invoice_date'))
                          <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                      @endif
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">Remark</label>
              <div class="col-md-8">
                <input type="text" 
                name="remark"
                id="remark"
                class="form-control" 
                value="{{ old('remark') }}"/>
                </div>
            </div>
          </div>

          <div class="col-md-8">
            <div class="row mb-3">

              <label class="form-label col-form-label col-md-2">SPK</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="ref_no" id="ref_no" required>
                    <option value="">Select SPK</option>
                    @foreach($orders as $order)
                        <option value="{{ $order->order_no }}">{{ $order->order_no }} </option>
                    @endforeach
                </select>
              </div>



              <label class="form-label col-form-label col-md-1">Customer</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="customer_id" id="customer_id" required>
                    <option value="">Select Customers</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}">{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>
              <label class="form-label col-form-label col-md-1">Schedule</label>
              <div class="col-md-3">
                  <div class="input-group">
                    <input type="text" class="form-control" id="scheduled" disabled>
                    <button type="button" class="btn btn-indigo" data-bs-toggle="modal" data-bs-target="#modal-scheduled" >
                      <span class="fas fa-calendar-days"></span>
                    </button>
                  </div>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Type Payment</label>
              <div class="col-md-2">
                <select class="form-control" 
                      name="payment_type" id ="payment_type" required>
                      <option value="">Select Payment</option>
                      @foreach($payment_type as $value)
                          <option value="{{ $value }}">{{ $value }}</option>
                      @endforeach
                  </select>
              </div>

                <label class="form-label col-form-label col-md-2">Nominal Payment</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="{{ old('payment_nominal') }}" required/>
                  </div>

                  <label class="form-label col-form-label col-md-1">Charge</label>
                  <div class="col-md-3">
                    <h2 class="text-end"><label id="order_charge">Rp. 0</label></h2>
                  </div>
                
            </div>
            <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">Assign Task</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <label class="form-label col-form-label col-md-8" id="product_id_selected_lbl">Choose Terapist </label>
                    <input type="hidden" id="product_id_selected" value="">
                    <div class="col-md-8">
                      <select class="form-control" 
                          name="assign_id" id="assign_id" required>
                          <option value="">Select Staff</option>
                          @foreach($users as $user)
                              <option value="{{ $user->id }}">{{ $user->name }}</option>
                          @endforeach
                      </select>
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_assigned">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>

            <div class="modal fade" id="modal-referral" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">Referral By</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <label class="form-label col-form-label col-md-8" id="referral_selected_lbl">Choose User </label>
                    <input type="hidden" id="referral_selected" value="">
                    <div class="col-md-8">
                      <select class="form-control" 
                          name="referral_by" id="referral_by">
                          <option value="">Select Staff</option>
                          @foreach($usersall as $userall)
                              <option value="{{ $userall->id }}">{{ $userall->name }}</option>
                          @endforeach
                      </select>
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_referred">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>

            <div class="modal fade" id="modal-scheduled" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">Choose Schedule</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">

                    <div class="row mb-3">
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-8">Room </label>
                      </div>
                      <div class="col-md-2">
                          <select class="form-control" 
                              name="room_id" id="room_id" required>
                              <option value="">Select Rooms</option>
                              @foreach($rooms as $room)
                                  <option value="{{ $room->id }}">{{ $room->remark }}</option>
                              @endforeach
                          </select>
                      </div>
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-4">Date</label>
                      </div>
                      <div class="col-md-2">
                        <input type="text" 
                        name="schedule_date"
                        id="schedule_date"
                        class="form-control" 
                        value="{{ old('invoice_date') }}" required/>
                        @if ($errors->has('invoice_date'))
                                  <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                              @endif
                      </div>
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-8">Time </label>
                      </div>
                      <div class="col-md-2">
                        <div class="input-group bootstrap-timepicker timepicker">
                            <input id="timepicker1" type="text" class="form-control input-small">
                            <span class="btn btn-indigo input-group-addon"><i class="fas fa-clock"></i></span>
                        </div>    
                      </div>
                    </div>
                   
                    <div class="panel-heading bg-teal-600 text-white"><strong>Time Table</strong></div>
                    </br>
      
                    <div class="col-md-12">
                      <table class="table table-striped" id="order_time_table" style="width:100%">
                        <thead>
                        <tr>
                            <th>Room</th>
                            <th scope="col" width="25%">Order No</th>
                            <th scope="col" width="15%">@lang('general.lbl_total_customer')</th>
                            <th scope="col" width="15%">Schedule At</th>
                            <th scope="col" width="5%">Duration</th>  
                            <th scope="col" width="15%">End Estimate</th>   
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                      </table> 
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_scheduled">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>


          </div>
        </div>



        <div class="panel-heading bg-teal-600 text-white"><strong>Order List</strong></div>
        <br>

        <div class="row mb-3">
          <div class="col-md-3">
            <label class="form-label col-form-label">Product</label>
            <select class="form-control" 
                  name="input_product_id" id="input_product_id" required>
                  <option value="">@lang('general.lbl_productselect')</option>
              </select>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">UOM</label>
            <input type="text" 
            name="input_product_uom"
            id="input_product_uom"
            class="form-control" 
            value="{{ old('input_product_uom') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <label class="form-label col-form-label">Price</label>
            <input type="text" 
            name="input_product_price"
            id="input_product_price"
            class="form-control" 
            value="{{ old('input_product_price') }}" required disabled/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">Disc (Rp.)</label>
            <input type="text" 
            name="input_product_disc"
            id="input_product_disc"
            class="form-control" 
            value="{{ old('input_product_disc') }}" required/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">Qty</label>
            <input type="text" 
            name="input_product_qty"
            id="input_product_qty"
            class="form-control" 
            value="{{ old('input_product_qty') }}" required/>
          </div>

          <div class="col-md-2">
            <label class="form-label col-form-label">Total</label>
            <input type="hidden" 
            name="input_product_vat_total"
            id="input_product_vat_total"
            class="form-control" 
            value="{{ old('input_product_vat_total') }}" required disabled/>
            <input type="text" 
            name="input_product_total"
            id="input_product_total"
            class="form-control" 
            value="{{ old('input_product_total') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
            <a href="#" id="input_product_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>Add Product</div></a>
          </div>

        </div>

        <table class="table table-striped" id="order_table">
          <thead>
          <tr>
              <th scope="col" width="20%">Product</th>
              <th scope="col" width="10%">UOM</th>
              <th scope="col" width="10%">Price</th>
              <th scope="col" width="5%">Discount</th>
              <th scope="col" width="5%">Qty</th>
              <th scope="col" width="10%">Total</th>  
              <th scope="col" width="10%">Assigned to</th>  
              <th scope="col" width="10%">Referral to</th>  
              <th scope="col" width="20%">@lang('general.lbl_action')</th> 
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table> 
        
        
        <div class="row mb-3">
          <div class="col-md-6">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-3" id="label-voucher">Voucher</label>
                <br>
                <div class="col-md-5">
                  <input type="text" class="form-control" id="input-apply-voucher">
                </div>
                <div class="col-md-3">
                  <button type="button" id="apply-voucher-btn" class="btn btn-warning">Apply Voucher</button>
                </div>
            </div>
          </div>


          <div class="col-md-6">
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label class="col-md-2"><h2>Sub Total </h2></label>
                <label class="col-md-8" id="sub-total"> <h3>0</h3></label>
              </div>
            </div>
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label class="col-md-2"><h2>Tax </h2></label>
                <label class="col-md-8" id="vat-total"> <h3>0</h3></label>
              </div>
            </div>
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label class="col-md-2"><h1>Total </h1></label>
                <label class="col-md-8 display-5" id="result-total"> <h1>0</h1></label>
              </div>
            </div>
          </div>
        </div>

    </div>
  </div>
</form>
@endsection

@push('scripts')
    <script type="text/javascript">
      $(function () {
          $('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          $('#invoice_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#invoice_date').val(formattedToday);
          $('#schedule_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#schedule_date').val(formattedToday);

          var url = "{{ route('orders.getorder','XX') }}";
          var lastvalurl = "XX";
          console.log(url);
          $('#ref_no').change(function(){
              if($(this).val()==""){

              table.clear().draw(false);
              order_total = 0;
              disc_total = 0;
              _vat_total = 0;
              sub_total = 0;
              orderList = [];
              $('#order_charge').text("Rp. 0");
            
              $('#result-total').text("Rp. 0");
              $('#vat-total').text("Rp. 0");
              $('#sub-total').text("Rp. 0");


              }else{
                url = url.replace(lastvalurl, $(this).val())
                lastvalurl = $(this).val();
                const res = axios.get(url, {
                  headers: {
                      'Content-Type': 'application/json'
                    }
                }).then(resp => {
                      table.clear().draw(false);
                      order_total = 0;

                      for(var i=0;i<resp.data.length;i++){
                          var product = {
                                "id"        : resp.data[i]["product_id"],
                                "abbr"      : resp.data[i]["remark"],
                                "uom"      : resp.data[i]["uom"],
                                "price"     : resp.data[i]["price"],
                                "discount"  : resp.data[i]["discount"],
                                "qty"       : resp.data[i]["qty"],
                                "total"     : resp.data[i]["total"],
                                "assignedto"     : resp.data[i]["assignedto"],
                                "assignedtoid"     : resp.data[i]["assignedtoid"],
                                "referralby"     : resp.data[i]["referralby"],
                                "referralbyid"     : resp.data[i]["referralbyid"],
                                "total_vat"     : resp.data[i]["vat_total"],
                                "vat_total"     : resp.data[i]["vat"],  
                          }

                          orderList.push(product);
                      }

                      for (var i = 0; i < orderList.length; i++){
                      var obj = orderList[i];
                      var value = obj["abbr"];
                      table.row.add( {
                          "id"        : obj["id"],
                          "abbr"      : obj["abbr"],
                          "uom"       : obj["uom"],
                          "price"     : obj["price"],
                          "discount"  : obj["discount"],
                          "qty"       : obj["qty"],
                          "total"     : obj["total"],
                          "assignedto" : obj["assignedto"],
                          "referralby" : obj["referralby"],
                          "action"    : "",
                        }).draw(false);
                        disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
                    if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("Rp. 0");
                        }
                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

                    $('#invoice_date').val(resp.data[0]["dated"]);
                    $('#customer_id').val(resp.data[0]["customers_id"]);
                    $('#remark').val(resp.data[0]["order_remark"]);
                    $('#payment_type').val(resp.data[0]["payment_type"]);
                    $('#payment_nominal').val(resp.data[0]["payment_nominal"]);
                    $('#schedule_date').val(resp.data[0]["scheduled_date"]);
                    $('#timepicker1').val(resp.data[0]["scheduled_time"]);
                    $('#room_id').val(resp.data[0]["branch_room_id"]);
                    $('#scheduled').val($('#room_id option:selected').text()+" - "+$('#schedule_date').val()+" "+$('#timepicker1').val());


                });

              }

              

          });

          $('#btn_scheduled').on('click',function(){
            if($('#room_id').val()==""){
              Swal.fire(
                  {
                    position: 'top-end',
                    icon: 'warning',
                    text: 'Please choose room',
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                  }
                );
            }else{
            $('#scheduled').val($('#room_id option:selected').text()+" - "+$('#schedule_date').val()+" "+$('#timepicker1').val());
            }
          });

      });

      $('#btn_assigned').on('click',function(){
        if($('#assign_id').val()==""){
          Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose staff',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
        }else{
          table.clear().draw(false);
          order_total = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if($('#product_id_selected').val()==obj["id"]){
              orderList[i]["assignedto"] = $('#assign_id option:selected').text();
              orderList[i]["assignedtoid"] = $('#assign_id').val();
            }
          }


          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];
            table.row.add( {
                   "id"        : obj["id"],
                    "abbr"      : obj["abbr"],
                    "uom"       : obj["uom"],
                    "price"     : obj["price"],
                    "discount"  : obj["discount"],
                    "qty"       : obj["qty"],
                    "total"     : obj["total"],
                    "assignedto": obj["assignedto"],
                    "assignedtoid": obj["assignedtoid"],
                    "referralby" : obj["referralby"],
                    "referralbyid" : obj["referralbyid"],
                    "action"    : "",
              }).draw(false);
              disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
              
              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
              }
          }
          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        }
      });

      $('#btn_referred').on('click',function(){
        if($('#referral_by').val()==""){
          Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose staff',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
        }else{
          table.clear().draw(false);
          order_total = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if($('#referral_selected').val()==obj["id"]){
              orderList[i]["referralby"] = $('#referral_by option:selected').text();
              orderList[i]["referralbyid"] = $('#referral_by').val();
            }
          }


          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];
            table.row.add( {
                   "id"        : obj["id"],
                    "abbr"      : obj["abbr"],
                    "uom"       : obj["uom"],
                    "price"     : obj["price"],
                    "discount"  : obj["discount"],
                    "qty"       : obj["qty"],
                    "total"     : obj["total"],
                    "assignedto": obj["assignedto"],
                    "assignedtoid": obj["assignedtoid"],
                    "referralby" : obj["referralby"],
                    "referralbyid" : obj["referralbyid"],
                    "action"    : "",
              }).draw(false);
              disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
              }
          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());


        }
      });

      var productList = [];
      var orderList = [];
      var order_total = 0;
      var disc_total = 0;
      var _vat_total = 0;
      var sub_total = 0;
        
        $('#save-btn').on('click',function(){
          if($('#invoice_date').val()==''){
            $('#invoice_date').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose date',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#customer_id').val()==''){
            $('#customer_id').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose customer',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#payment_type').val()==''){
            $('#payment_type').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose payment type',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#payment_nominal').val()==''){
            $('#payment_nominal').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose payment nominal',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#scheduled').val()==''){
            $('#scheduled').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose schedule',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if(order_total<=0){
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose at least 1 product',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{

            counterBlank = 0;
            for (var i=0;i<orderList.length;i++){
                if(orderList[i]["assignedto"]==""){
                  counterBlank++;
                }
            }

            if(counterBlank>0){
              Swal.fire(
              {
                  position: 'top-end',
                  icon: 'warning',
                  text: 'Please choose terapist for service',
                  showConfirmButton: false,
                  imageHeight: 30, 
                  imageWidth: 30,   
                  timer: 1500
                }
              );
            }else{
              const json = JSON.stringify({
                  invoice_date : $('#invoice_date').val(),
                  product : orderList,
                  customer_id : $('#customer_id').val(),
                  remark : $('#remark').val(),
                  payment_type : $('#payment_type').val(),
                  payment_nominal : $('#payment_nominal').val(),
                  total_order : order_total,
                  scheduled_at : $('#schedule_date').val()+" "+$('#timepicker1').val(),
                  branch_room_id : $('#room_id').val(),
                  ref_no : $('#ref_no').val(),
                  tax : _vat_total,
                }
              );
              const res = axios.post("{{ route('invoices.store') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      window.location.href = "{{ route('invoices.index') }}"; 
                    }else{
                      Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: 'Something went wrong - '+resp.data.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                        }
                      );
                    }
              });
            }
          }
        });
        
        $('#product-table').DataTable({
          "bInfo" : false,
          pagingType: 'numbers',
          ajax: "{{ route('invoices.getproduct') }}",
          columns: [
            { data: 'abbr' },
            { data: 'remark' },
            { data: 'type' },
            { data: 'action', name: 'action', orderable: false, searchable: false}
        ],
        }); 

        $('#order_time_table').DataTable({
          "bInfo" : false,
          pagingType: 'numbers',
          ajax: "{{ route('invoices.gettimetable') }}",
          columns: [
            { data: 'branch_room_name' },
            { data: 'invoice_no' },
            { data: 'customer_name' },
            { data: 'scheduled_at' },
            { data: 'duration' },
            { data: 'est_end' },
        ],
        }); 

        $('#modal-scheduled').on('shown.bs.modal', function () {
            var table = $('#order_time_table').DataTable();
            table.columns.adjust();
        });

        var table = $('#order_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<a href="#" id="add_row" class="btn btn-sm btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'+
            '<a href="#" id="minus_row" class="btn btn-sm btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'+
            '<a href="#" id="delete_row" class="btn btn-sm btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>'+
            '<a href="#" href="#modal-filter" data-bs-toggle="modal" data-bs-target="#modal-filter" id="assign_row" class="btn btn-sm btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></a>'+
            '<a href="#" href="#modal-referral" data-bs-toggle="modal" data-bs-target="#modal-referral" id="referral_row" class="btn btn-sm btn-purple"><div class="fa-1x"><i class="fas fa-users fa-fw"></i></div></a>',
          }],
          columns: [
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'discount',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'qty' },
            { data: 'total',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'assignedto' },
            { data: 'referralby' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, discount, qty, uom,vat_total,total){
          table.clear().draw(false);
          order_total = 0;
          disc_total = 0;
          _vat_total = 0;
          sub_total = 0;
          console.log(vat_total);
          console.log(total);
          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "price"     : price,
                "discount"  : discount,
                "qty"       : qty,
                "total"     : total,
                "assignedto" : "",
                "assignedtoid" : "",
                "referralby" : "",
                "referralbyid" : "",
                "uom" : uom,
                "vat_total"     : vat_total, 
          }

          var isExist = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if(id==obj["id"]){
              isExist = 1;
              orderList[i]["total"] = (parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]); 
              orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
            }
          }

          if(isExist==0){
            orderList.push(product);
          }


          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];
            table.row.add( {
                   "id"        : obj["id"],
                    "abbr"      : obj["abbr"],
                    "uom"       : obj["uom"],
                    "price"     : obj["price"],
                    "discount"  : obj["discount"],
                    "qty"       : obj["qty"],
                    "total"     : obj["total"],
                    "assignedto": obj["assignedto"],
                    "referralby" : obj["referralby"],
                    "action"    : "",
              }).draw(false);
              disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
              }
          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        }

        $('#order_table tbody').on('click', 'a', function () {
            var data = table.row($(this).parents('tr')).data();
            order_total = 0;
            disc_total = 0;
            _vat_total = 0;
            sub_total = 0;
            table.clear().draw(false);
            
            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              var value = obj["id"];

              if($(this).attr("id")=="add_row"){
                if(data["id"]==obj["id"]){
                  orderList[i]["total"] = (parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])>1){
                  orderList[i]["total"] = (parseInt(orderList[i]["qty"])-1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])-1;
                } else if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])==1) {
                  orderList.splice(i,1);
                }
              }

              if($(this).attr("id")=="delete_row"){
                if(data["id"]==obj["id"]){
                  orderList.splice(i,1);
                }
              }

              if($(this).attr("id")=="assign_row"){
                if(data["id"]==obj["id"]){
                  $('#product_id_selected').val(data["id"]);
                  $('#product_id_selected_lbl').text("Choose terapist for product "+data["abbr"]);
                }
              }

              if($(this).attr("id")=="referral_row"){
                if(data["id"]==obj["id"]){
                  $('#referral_selected').val(data["id"]);
                  $('#referral_selected_lbl').text("Choose referral for product "+data["abbr"]);
                }
              }
            }

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              table.row.add( {
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto" : obj["assignedto"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
                disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
              }
            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        });

            $("#payment_nominal").on("input", function(){
              order_total = 0;
              for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];
                  order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                  if(($('#payment_nominal').val())>order_total){
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                  }else{
                    $('#order_charge').text("Rp. 0");
                  }
                }
              });


              var url = "{{ route('orders.getproduct') }}";
            var lastvalurl = "XX";
            console.log(url);
            const res = axios.get(url, {
              headers: {
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                $('#input_product_id').select2();
              
                for(var i=0;i<resp.data.length;i++){
                    var product = {
                          "id"        : resp.data[i]["id"],
                          "abbr"      : resp.data[i]["abbr"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"      : resp.data[i]["uom"],
                          "price"     : resp.data[i]["price"],
                          "vat_total"     : resp.data[i]["vat_total"]
                    }

                    productList.push(product);
                }

                for (var i = 0; i < productList.length; i++){
                  var obj = productList[i];
                  var newOption = new Option(obj["remark"], obj["id"], false, false);
                  $('#input_product_id').append(newOption).trigger('change');  
                }

              $('#input_product_id').on('change.select2', function(e){
                $.each(productList, function(i, v) {
                    if (v.id == $('#input_product_id').find(':selected').val()) {
                        $('#input_product_uom').val(v.uom);
                        $('#input_product_price').val(v.price);
                        $('#input_product_qty').val(1);
                        $('#input_product_disc').val(0);
                        $('#input_product_total').val(v.price);
                        $('#input_product_vat_total').val(v.vat_total);
                        return;
                    }
                });
              });

              $('#input_product_price').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val())-$('#input_product_disc').val());
              });

              $('#input_product_qty').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val())-$('#input_product_disc').val());
              });

              $('#input_product_disc').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val())-$('#input_product_disc').val());
              });

              $('#input_product_submit').on('click', function(){
                if($('#input_product_id').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please choose product',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_qty').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input qty',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_price').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input price',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_disc').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input disc',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_total').val()<0){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input disc less than total',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else{
                  addProduct(
                    $('#input_product_id').val(),
                    $('#input_product_id option:selected').text(), 
                    $('#input_product_price').val(), 
                    $('#input_product_disc').val(), 
                    $('#input_product_qty').val(),
                    $('#input_product_uom').val(),
                    $('#input_product_vat_total').val(),
                    $('#input_product_total').val()
                  )
                }
              });
              

          });



          $("#apply-voucher-btn").on('click',function(){
              if($("#input-apply-voucher").val()==""){
                  Swal.fire(
                  {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Silahkan inputkan nomor voucher dahulu',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                  });
              }else{
                var url = "{{ route('orders.checkvoucher') }}";
                const res = axios.get(url,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    params : {
                        voucher_code : $("#input-apply-voucher").val()
                    }
                  }
                ).then(resp => {
                  if(orderList.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Masukkan dahulu sku yang dipesan pelanggan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });
                    $("#input-apply-voucher").val("");

                  }else if(resp.data.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Nomor voucher '+$("#input-apply-voucher").val()+' tidak ditemukan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });

                  }else{
                    table.clear().draw(false);
                    order_total = 0;
                    disc_total = 0;
                    _vat_total = 0;
                    sub_total = 0;

                    counterVoucherHit = 0;

                    for (var i = 0; i < orderList.length; i++){
                      for (var j = 0; j < resp.data.length;j++){
                        if(resp.data[j].product_id == orderList[i]["id"]){
                          orderList[i]["discount"] = ( ((parseFloat(resp.data[j].value)) * (parseFloat(orderList[i]["price"])) * (parseFloat(orderList[i]["qty"])) )/100 );
                          orderList[i]["total"] = ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
                          $("#remark").val($("#remark").val()+"["+resp.data[j].remark+"]");
                          counterVoucherHit++;
                          voucherNo = $("#input-apply-voucher").val();
                          $("#voucher_code").val(voucherNo);
                          voucherNoPID = resp.data[j].product_id;
                        }
                      }

                      console.log(orderList[i]["vat_total"]);

                      var obj = orderList[i];
                      var value = obj["abbr"];
                      table.row.add( {
                              "id"        : obj["id"],
                              "abbr"      : obj["abbr"],
                              "uom"       : obj["uom"],
                              "price"     : obj["price"],
                              "discount"  : obj["discount"],
                              "qty"       : obj["qty"],
                              "total"     : obj["total"],
                              "assignedto" : obj["assignedto"],
                              "referralby" : obj["referralby"],
                              "action"    : "",
                        }).draw(false);
                        disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                        if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("Rp. 0");
                        }
                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());


                    if(counterVoucherHit>0){
                      Swal.fire(
                      {
                          position: 'top-end',
                          icon: 'success',
                          text: 'Nomor voucher '+$("#input-apply-voucher").val()+' berhasil dipakai',
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                      });
                    }else{
                      Swal.fire(
                      {
                          position: 'top-end',
                          icon: 'warning',
                          text: 'Nomor voucher '+$("#input-apply-voucher").val()+' tidak ada yang cocok dengan SKU yang dipesan',
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                      });
                    }
                  }

                });

              }
            });

 
    </script>
@endpush
