@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Invoice')

@section('content')
<form method="POST" action="{{ route('invoices.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_invoice') </h4></div>
      <div class="">
        <a href="{{ route('invoices.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-2">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated')   </label>
              <div class="col-md-8">
                <input type="hidden" 
                name="invoice_no"
                id="invoice_no"
                class="form-control" 
                value="{{ $invoice->invoice_no }}"/>
                <input type="text" 
                name="invoice_date"
                id="invoice_date"
                class="form-control" 
                value="{{ substr(explode(" ",$invoice->dated)[0],8,2) }}-{{ substr(explode(" ",$invoice->dated)[0],5,2) }}-{{ substr(explode(" ",$invoice->dated)[0],0,4) }}" required/>
                @if ($errors->has('invoice_date'))
                          <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                      @endif
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_remark')</label>
              <div class="col-md-8">
                <input type="text" 
                name="remark"
                id="remark"
                class="form-control" 
                value="{{ $invoice->remark }}"/>
                </div>
            </div>
          </div>

          <div class="col-md-10">
            <div class="row mb-3">

              <label class="form-label col-form-label col-md-2  d-none">@lang('general.lbl_spk')</label>
              <div class="col-md-3 d-none">
                <input type="text" class="form-control" id="ref_no" name="ref_no" value="{{ $invoice->ref_no }}" id="scheduled" disabled>
              </div>

              <label class="form-label col-form-label col-md-2">@lang('general.lbl_customer')</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="customer_id" id="customer_id" required>
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}" {{ ($customer->id == $invoice->customers_id) 
                          ? 'selected'
                          : ''}}>{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-2">@lang('general.lbl_nominal_payment')</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="{{ $invoice->payment_nominal }}" required/>
                  </div>

                 

             
              
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_type_payment')</label>
              <div class="col-md-3">
                <select class="form-control" 
                      name="payment_type" id ="payment_type" required>
                      <option value="">@lang('general.lbl_type_paymentselect')</option>
                      @foreach($payment_type as $value)
                          <option value="{{ $value }}" {{ ($invoice->payment_type == $value) 
                            ? 'selected'
                            : ''}}>{{ $value }}</option>
                      @endforeach
                  </select>
              </div>

              <label class="form-label col-form-label col-md-1">@lang('general.lbl_charge')</label>
              <div class="col-md-3">
                <h2 class="text-end"><label id="order_charge"> @if($invoice->payment_nominal-$invoice->total>0)
                  {{ number_format(($invoice->payment_nominal-$invoice->total), 0, ',', '.') }}
                  @else {{ 0 }}
                @endif</label></h2> 
              </div>

                
                
            </div>
            

            


          </div>
        </div>



        <div class=" bg-teal-600 text-white">
          <div class="row ps-2 pe-2 py-2">
            <div class="col-md-3 fw-bold pt-2">@lang('general.lbl_order_list')</div>
            <div class="col-md-9 d-flex justify-content-end">
              <input type="button" class="btn btn-sm btn-default me-2" id="btn_import" name="btn_import" value="@lang('general.lbl_import_order')">
            </div>
          </div>
        </div>
        <br>


        <div class="row mb-3">
          <div class="col-md-3">
            <label class="form-label col-form-label">@lang('general.product')</label>
            <select class="form-control" 
                  name="input_product_id" id="input_product_id" required>
                  <option value="">@lang('general.lbl_productselect')</option>
              </select>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_uom')</label>
            <input type="text" 
            name="input_product_uom"
            id="input_product_uom"
            class="form-control" 
            value="{{ old('input_product_uom') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <label class="form-label col-form-label">@lang('general.lbl_price')</label>
            <input type="text" 
            name="input_product_price"
            id="input_product_price"
            class="form-control" 
            value="{{ old('input_product_price') }}" required disabled/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_discountrp')</label>
            <input type="text" 
            name="input_product_disc"
            id="input_product_disc"
            class="form-control" 
            value="{{ old('input_product_disc') }}" required/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_qty')</label>
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
            <a href="#" id="input_product_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>@lang('general.lbl_add_product')</div></a>
          </div>

        </div>

         <table class="table table-striped" id="order_product_table">
          <thead>
          <tr>
              <th scope="col"  width="5%">No</th>
              <th scope="col">@lang('general.product')</th>
              <th scope="col" width="10%">@lang('general.lbl_uom')</th>
              <th scope="col" width="10%">@lang('general.lbl_price')</th>
              <th scope="col" width="5%">@lang('general.lbl_discount')</th>
              <th scope="col" width="5%">@lang('general.lbl_qty')</th>
              <th scope="col" width="10%">Total</th>  
              <th scope="col" width="20%">@lang('general.lbl_action')</th> 
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table> 
        
        
        <div class="row mb-3">
          <div class="col-md-6">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-3">@lang('sidebar.MataUang')</label>
              <div class="col-md-2">
                <input type="hidden" name="curr_def" id="curr_def" value="{{ $branchs[0]->currency }}">
                <select class="form-select" name="currency" id="currency">
                    @php
                    $selected = "";
                    $curr = "";

                    for ($i=0; $i < count($currency); $i++) { 
                       if($currency[$i]->remark == $invoice->currency){
                         $selected = "selected";
                       }else{
                        $selected = "";
                       }
                        echo '<option value="'.$currency[$i]->remark.'" '.$selected.'>'.$currency[$i]->remark.'</option>';
                    }   
                    @endphp
                </select>
              </div>

              <label class="form-label col-form-label col-md-2 kurs d-none" id="label-kurs">Kurs</label>
              <br>
              <div class="col-md-3 kurs  d-none">
                <input type="number" class="form-control kurs  d-none" id="kurs" value="{{ $invoice->kurs }}" name="kurs">
              </div>
              <label class="form-label col-form-label col-md-2 kurs d-none">{{ $branchs[0]->currency }}</label>
              

              @if ($errors->has('currency'))
                  <span class="text-danger text-left">{{ $errors->first('currency') }}</span>
              @endif
            </div>

            <div class="row mb-3">
                <label class="form-label col-form-label col-md-3" id="label-voucher">Voucher</label>
                <br>
                <div class="col-md-5">
                  <input type="text" class="form-control" id="input-apply-voucher" value="{{ $invoice->voucher_code==null?"":$invoice->voucher_code }}">
                </div>
                <div class="col-md-4">
                  <button type="button" id="apply-voucher-btn" class="btn btn-warning">@lang('general.lbl_apply_voucher')</button>
                </div>
            </div>
          </div>


          <div class="col-md-6">
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label class="col-md-4">Sub Total</label>
                <label class="col-md-4" id="sub-total">{{ number_format(($invoice->total-$invoice->tax), 0, ',', '.') }}</label>
              </div>
            </div>
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label class="col-md-4">@lang('general.lbl_tax')</label>
                <label class="col-md-4" id="vat-total">{{ number_format(($invoice->tax), 0, ',', '.') }}</label>
              </div>
            </div>
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label id="lbl_total"  class="col-md-4 h3">Total</label>
                <label class="col-md-4 h3" id="result-total">{{ number_format($invoice->total, 0, ',', '.') }}</label>
              </div>
            </div>
          </div>

        </div>

        <div class="modal fade" id="modal-order" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
              <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_order_list')</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                
                <div class="container mt-4">
                        <div class="mb-3">
                            <div class="col-md-12">
                              <select class="form-control" name="order_orderno_list" id="order_orderno_list">
                              </select>
                            </div>
                          </div>
                </div>
    
              </div>
              <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
              <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_choose_order">@lang('general.lbl_save')</button>
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
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          $('#btn_import').on('click', function(){
        if($('#customer_id').val()==''){
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
            }else{
                const json = JSON.stringify({
                      customer_id : $('#customer_id').val(),
                    }
                );

                const res = axios.post("{{ route('orders.getorderlist') }}", json, {
                    headers: {
                      // Overwrite Axios's automatically set Content-Type
                      'Content-Type': 'application/json'
                    }
                  }).then(resp => {
                        if(resp.data.status=="success"){
                          $('#order_orderno_list').find('option').remove().end();
                          list_order_get = resp.data.data;
                          
                          if(list_order_get.length>0){
                            $('#modal-order').modal('show');
                            for (let index = 0; index < list_order_get.length; index++) {
                              const element = list_order_get[index];
                              $('#order_orderno_list').append('<option value="'+element.order_no+'">'+element.order_no+' ('+element.dated+') </option>');
                              
                            }
                            $('#order_orderno_list').val(list_order_get[0].order_no).trigger('change');
                          }

                        }else{
                          Swal.fire(
                            {
                              position: 'top-end',
                              icon: 'warning',
                              text: "@lang('general.lbl_msg_failed')"+resp.data.message,
                              showConfirmButton: false,
                              imageHeight: 30, 
                              imageWidth: 30,   
                              timer: 1500
                            }
                          );
                        }
                  });
            }
          });

          $('#btn_choose_order').on('click', function(){
          const json = JSON.stringify({
                order_no : $('#order_orderno_list').find(':selected').val(),
          });

          const res = axios.post("{{ route('orders.getorder') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      console.log(resp.data.data);
                      var list = resp.data.data;
                      for (let index = 0; index < list.length; index++) {
                        const element = list[index];
                        addProduct(
                          element.product_id,
                          element.remark,
                          element.price,
                          element.discount,
                          element.qty,
                          element.uom,
                          0,
                          element.total,
                          "Good"
                        );
                        
                      }

                    }else{
                      Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "@lang('general.lbl_msg_failed')"+resp.data.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                        }
                      );
                    }
              });
        });



          $('#currency').on('change', function(){
            if($('#currency').find(':selected').val() == $('#curr_def').val()){
              $('.kurs').addClass('d-none');
              $('#kurs').val("1");
            }else{
              $('.kurs').removeClass('d-none');
              $('#label-kurs').text("Kurs 1 "+$('#currency').find(':selected').val()+" = ");
            }
            $('#lbl_total').text("Total ("+$('#currency').find(':selected').val()+")");

          });

          $('#lbl_total').text("Total ("+$('#currency').find(':selected').val()+")");


          if($('#currency').find(':selected').val() == $('#curr_def').val()){
              $('.kurs').addClass('d-none');
              $('#kurs').val("1");
            }else{
              $('.kurs').removeClass('d-none');
              $('#label-kurs').text("Kurs 1 "+$('#currency').find(':selected').val()+" = ");
            }

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          $('#invoice_date').datepicker({
            dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
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

              order_total = 0;
              disc_total = 0;
              _vat_total = 0;
              sub_total = 0;
              orderList = [];
              $('#order_charge').text(" 0");
            
              $('#result-total').text(" 0");
              $('#vat-total').text(" 0");
              $('#sub-total').text(" 0");


              }else{
                url = url.replace(lastvalurl, $(this).val())
                lastvalurl = $(this).val();
                const res = axios.get(url, {
                  headers: {
                      'Content-Type': 'application/json'
                    }
                }).then(resp => {
                      table_product.clear().draw(false);
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
                                "total_vat"     : resp.data[i]["vat_total"],
                                "vat_total"     : resp.data[i]["vat"],  
                          }

                          orderList.push(product);
                      }

                      counterno = 0;
                      counterno_service = 0;  
                      orderList.sort(function(a, b) {
                          return parseFloat(a.seq) - parseFloat(b.seq);
                      });

                      for (var i = 0; i < orderList.length; i++){
                      var obj = orderList[i];
                      var value = obj["abbr"];
                      if(obj["type"]!="Goods"){
                        
                        }else{
                          counterno = counterno + 1;
                          table_product.row.add( {
                              "seq" : counterno,
                              "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "action"    : "",
                          }).draw(false);
                        }
                        disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
                        if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').css('color', 'black');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text(" 0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                        } 


                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());

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
                  invoice_no : $('#invoice_no').val(),
                  product : orderList,
                  customer_id : $('#customer_id').val(),
                  remark : $('#remark').val(),
                  payment_type : $('#payment_type').val(),
                  payment_nominal : $('#payment_nominal').val(),
                  kurs : $('#kurs').val(),
                  currency : $('#currency').find(':selected').val(),
                  total_order : order_total,
                  ref_no : $('#ref_no').val(),
                  customer_type : $('#customer_type').val(),
                  tax : _vat_total,
                }
              );
              const res = axios.patch("{{ route('invoices.update',$invoice->id) }}", json, {
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
                          text: "@lang('general.lbl_msg_failed')"+resp.data.message,
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
            { data: 'remark' },
            { data: 'remark' },
            { data: 'type' },
            { data: 'action', name: 'action', orderable: false, searchable: false}
        ],
        }); 



        var table_product = $('#order_product_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-sm btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'+
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-sm btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'+
            '<a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-sm btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>',
          }],
          columns: [
            { data: 'seq' },
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'discount',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'qty' },
            { data: 'total',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, discount, qty, uom,vat_total,total,type){
          table_product.clear().draw(false);
          order_total = 0;
          disc_total = 0;
          _vat_total = 0;
          sub_total = 0;
          entry_time = Date.now();

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
                "type"     : type, 
                "entry_time" : entry_time,
                "seq" : 999,
          }

          var isExist = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if(id==obj["id"]){
              isExist = 1;
              orderList[i]["total"] = (parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]); 
              orderList[i]["qty"] = parseInt(orderList[i]["qty"])+qty;
            }
          }

          if(isExist==0){
            orderList.push(product);
          }

          
          orderList.sort(function(a, b) {
              return parseFloat(a.entry_time) - parseFloat(b.entry_time);
          });


          counterno = 0;
          counterno_service = 0;


          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];
            if(obj["type"]!="Goods"){
              
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "action"    : "",
                }).draw(false);
              }
              disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
              }else{
                $('#order_charge').text(" 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
              }
          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());

        }

        $('#order_table tbody').on('click', 'a', function () {
            var data = table.row($(this).parents('tr')).data();
            order_total = 0;
            disc_total = 0;
            _vat_total = 0;
            sub_total = 0;
            table_product.clear().draw(false);
            
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

            orderList.sort(function(a, b) {
                return parseFloat(a.entry_time) - parseFloat(b.entry_time);
            });

            counterno = 0;
            counterno_service = 0;

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type"]!="Goods"){
              
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "action"    : "",
                }).draw(false);
              }
                disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
              }else{
                $('#order_charge').text(" 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
              }


            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());

        });

            $("#payment_nominal").on("input", function(){
              order_total = 0;
              for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];
                  order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                  if(($('#payment_nominal').val())>order_total){
                    $('#order_charge').css('color', 'black');
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                  }else{
                    $('#order_charge').text(" 0");
                    $('#order_charge').css('color', 'red');
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
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
              $('#input_service_id').select2();
              
                for(var i=0;i<resp.data.length;i++){
                    var product = {
                          "id"        : resp.data[i]["id"],
                          "abbr"      : resp.data[i]["abbr"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"      : resp.data[i]["uom"],
                          "price"     : resp.data[i]["price"],
                          "vat_total"     : resp.data[i]["vat_total"],
                          "type"     : resp.data[i]["type"]
                    }

                    productList.push(product);
                }

                for (var i = 0; i < productList.length; i++){
                  var obj = productList[i];
                  var newOption = new Option(obj["remark"], obj["id"], false, false);
                  if(obj["type"]!="Goods"){
                    $('#input_service_id').append(newOption).trigger('change');  
                  }else{
                    $('#input_product_id').append(newOption).trigger('change');  
                  }
                }

                // Service
            $('#input_service_id').on('change.select2', function(e){
                $.each(productList, function(i, v) {
                    if (v.id == $('#input_service_id').find(':selected').val()) {
                        $('#input_service_uom').val(v.uom);
                        $('#input_service_price').val(v.price);
                        $('#input_service_qty').val(1);
                        $('#input_service_disc').val(0);
                        $('#input_service_total').val(v.price);
                        $('#input_service_vat_total').val(v.vat_total);
                        return;
                    }
                });
              });

              $('#input_service_price').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_qty').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_disc').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_submit').on('click', function(){
                if($('#input_service_id').val()==''){
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
                }else if($('#input_service_qty').val()==''){
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
                }else if($('#input_service_price').val()==''){
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
                }else if($('#input_service_disc').val()==''){
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
                }else if($('#input_service_total').val()<0){
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
                    $('#input_service_id').val(),
                    $('#input_service_id option:selected').text(), 
                    $('#input_service_price').val(), 
                    $('#input_service_disc').val(), 
                    $('#input_service_qty').val(),
                    $('#input_service_uom').val(),
                    $('#input_service_vat_total').val(),
                    $('#input_service_total').val(),
                    "Services"
                  )
                }
              });

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
                    $('#input_product_total').val(),"Goods"
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
                    table_product.clear().draw(false);
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

                      orderList.sort(function(a, b) {
                          return parseFloat(a.entry_time) - parseFloat(b.entry_time);
                      });
                      counterno = 0;
                      counterno_service = 0;

                      var obj = orderList[i];
                      var value = obj["abbr"];
                      if(obj["type"]!="Goods"){
                        
                        }else{
                          counterno = counterno + 1;
                          table_product.row.add( {
                              "seq" : counterno,
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
                        }
                        disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                        if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').css('color', 'black');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text(" 0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                        }
                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());


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


            //Get Invoice 
            const resInvoice = axios.get("{{ route('invoices.getinvoice',$invoice->invoice_no) }}", {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  console.log(resp.data);
                  table_product.clear().draw(false);
                  order_total = 0;
                  disc_total = 0;
                  _vat_total = 0;
                  sub_total = 0;

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
                            "referralby" : resp.data[i]["referral_by_name"],
                            "referralbyid" : resp.data[i]["referral_by"],
                            "uom" : resp.data[i]["uom"],
                            "vat_total"     : resp.data[i]["vat"], 
                            "type"     : resp.data[i]["type"], 
                      }

                      orderList.push(product);
                  }

                  counterno = 0;
                  counterno_service = 0;  
                  orderList.sort(function(a, b) {
                      return parseFloat(a.seq) - parseFloat(b.seq);
                  });

                  for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];
                  var value = obj["abbr"];
                  if(obj["type"]!="Goods"){
                        
                        }else{
                          counterno = counterno + 1;
                          table_product.row.add( {
                              "seq" : counterno,
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
                        }
                    disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                    sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                    _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                    order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                    if(($('#payment_nominal').val())>order_total){
                      $('#order_charge').css('color', 'black');
                      $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                    }else{
                      $('#order_charge').text(" 0");
                      $('#order_charge').css('color', 'red');
                      $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                    }
                }

                $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());              
            });

            $('#order_product_table tbody').on('click', 'a', function () {
            var data = table_product.row($(this).parents('tr')).data();
            order_total = 0;
            disc_total = 0;
            _vat_total = 0;
            sub_total = 0;
            table_product.clear().draw(false);
            
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
                  $('#product_id_selected_lbl').text("Pilih terapis untuk produk/perawatan "+data["abbr"]);
                }
              }

              if($(this).attr("id")=="referral_row"){
                if(data["id"]==obj["id"]){
                  $('#referral_selected').val(data["id"]);
                  $('#referral_selected_lbl').text("Pilih penjual produk/perawatan "+data["abbr"]);
                }
              }
            }

            counterno = 0;
            counterno_service = 0;  
            orderList.sort(function(a, b) {
                return parseFloat(a.seq) - parseFloat(b.seq);
            });

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type"]!="Goods"){
                
                }else{
                  counterno = counterno + 1;
                  table_product.row.add( {
                      "seq" : counterno,
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
                }
                disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
              }else{
                $('#order_charge').text(" 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
              }


            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());


            
        });


 
    </script>
@endpush
