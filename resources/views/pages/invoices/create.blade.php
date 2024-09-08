@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Invoice')

@section('content')
<form method="POST" action="{{ route('invoices.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_invoice')</h4></div>
      <div class="">
        <a href="{{ route('invoices.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-2">

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated_mmddYYYY')</label>
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
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_remark')</label>
              <div class="col-md-8">
                <input type="text" 
                name="remark"
                id="remark"
                class="form-control" 
                value="{{ old('remark') }}"/>
                </div>
            </div>
          </div>

          <div class="col-md-9">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_customer')</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="customer_id" id="customer_id" required>
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}">{{ $customer->name }}</option>
                    @endforeach
                </select>
              </div>
              <div class="col-md-1">
                <a type="button" id="add-customer-btn" class="btn btn-green"  href="#modal-add-customer" data-bs-toggle="modal" data-bs-target="#modal-add-customer"><span class="fas fa-user-plus"></span></a>
              </div>

              <label class="form-label col-form-label col-md-3">@lang('general.lbl_nominal_payment')</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="{{ old('payment_nominal') }}" required/>
                  </div>

                 
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_type_payment')</label>
              <div class="col-md-4">
                <select class="form-control" 
                      name="payment_type" id ="payment_type" required>
                      <option value="">@lang('general.lbl_type_paymentselect')</option>
                      @foreach($payment_type as $value)
                          <option value="{{ $value }}">{{ $value }}</option>
                      @endforeach
                  </select>
              </div>

              <label class="form-label col-form-label col-md-2">@lang('general.lbl_charge')</label>
              <div class="col-md-3">
                <h2 class="text-end"><label id="order_charge">0</label></h2>
              </div>
          
            </div>
          </div>
        </div>



        <div class="p-1 bg-teal-600 text-white">
          <div class="row ps-2">
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
                  <option value="">@lang('general.productselect')</option>
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
              <th scope="col" width="5%">No</th>
              <th scope="col" width="25%">@lang('general.product')</th>
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

                    for ($i=0; $i < count($branchs); $i++) { 
                      $curr = $branchs[$i]->currency;
                    }
                    for ($i=0; $i < count($currency); $i++) { 
                       if($currency[$i]->remark == $curr){
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
                <input type="number" class="form-control kurs  d-none" id="kurs" value="1" name="kurs">
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
                  <input type="text" class="form-control" id="input-apply-voucher">
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
                <label class="col-md-4" id="sub-total"> 0</label>
              </div>
            </div>
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label class="col-md-4">@lang('general.lbl_tax')</label>
                <label class="col-md-4" id="vat-total">0</label>
              </div>
            </div>
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label id="lbl_total"  class="col-md-4 h3">Total</label>
                <label class="col-md-4  h3" id="result-total">0</label>
              </div>
            </div>
          </div>
        </div>



        <div class="modal fade" id="modal-add-customer" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
              <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_add_customer_new')</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                
                <div class="container mt-4">
                        <div class="mb-3">
                            <label for="cust_name" class="form-label">@lang('general.lbl_name')</label>
                            <input value="{{ old('cust_name') }}" 
                                type="text" 
                                class="form-control" 
                                name="cust_name" 
                                id="cust_name" 
                                placeholder="@lang('general.lbl_name')" required>
        
                            @if ($errors->has('cust_name'))
                                <span class="text-danger text-left">{{ $errors->first('cust_name') }}</span>
                            @endif
                        </div>
        
                        <div class="mb-3">
                            <label for="address" class="form-label">@lang('general.lbl_address')</label>
                            <input value="{{ old('cust_address') }}" 
                                type="text" 
                                class="form-control" 
                                name="cust_address" id="cust_address" 
                                placeholder="@lang('general.lbl_address')" required>
        
                            @if ($errors->has('cust_address'))
                                <span class="text-danger text-left">{{ $errors->first('cust_address') }}</span>
                            @endif
                        </div>
        
                        <div class="mb-3">
                            <label for="cust_phone_no" class="form-label">@lang('general.lbl_phoneno')</label>
                            <input value="{{ old('cust_phone_no') }}" 
                                type="text" 
                                class="form-control" 
                                name="cust_phone_no" id="cust_phone_no" 
                                placeholder="@lang('general.lbl_phoneno')" required>
        
                            @if ($errors->has('cust_phone_no'))
                                <span class="text-danger text-left">{{ $errors->first('cust_phone_no') }}</span>
                            @endif
                        </div>
        
                        <div class="mb-3">
                            <label class="form-label">@lang('general.lbl_branch')</label>
                            <div class="col-md-12">
                              <select class="form-control" 
                                    name="cust_branch_id" id="cust_branch_id">
                                    <option value="">@lang('general.lbl_branchselect')</option>
                                    @foreach($branchs as $branch)
                                        <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                                    @endforeach
                                </select>
                            </div>
                          </div>
                </div>
    
              </div>
              <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
              <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_save_customer">@lang('general.lbl_save')</button>
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
        $('#customer_id').select2();
        $('#lbl_total').text("Total ("+$('#curr_def').val()+")");

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

        $('#btn_save_customer').on('click', function(){
        if($('#cust_name').val()==''){
            $('#cust_name').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please fill name',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_address').val()==''){
            $('#cust_address').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please fill address',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_phone_no').val()==''){
            $('#cust_phone_no').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please fill phone no',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_branch_id').val()==''){
            $('#cust_branch_id').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose branch',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{
            const json = JSON.stringify({
                name : $('#cust_name').val(),
                address : $('#cust_address').val(),
                phone_no : $('#cust_phone_no').val(),
                branch_id : $('#cust_branch_id').val()
                }
              );
              const res = axios.post("{{ route('customers.storeapi') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                        var data = {
                            id: resp.data.data,
                            text: $('#cust_name').val() +" ("+ $('#cust_branch_id option:selected').text() +")"
                        };

                        var newOption = new Option(data.text, data.id, false, false);
                        $('#customer_id').append(newOption).trigger('change');
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





          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          $('#invoice_date').datepicker({
            dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#invoice_date').val(formattedToday);

          var url = "{{ route('orders.getorder','XX') }}";
          var lastvalurl = "XX";
          console.log(url);
          $('#ref_no').change(function(){
              if($(this).val()==""){

              table_product.clear().draw(false);
              order_total = 0;
              disc_total = 0;
              _vat_total = 0;
              sub_total = 0;
              orderList = [];
              $('#order_charge').text("0");
            
              $('#result-total').text("0");
              $('#vat-total').text("0");
              $('#sub-total').text("0");


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
                                "seq" : resp.data[i]["seq"],
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
                      if(obj["type_id"]=="Services"){
                        counterno_service  = counterno_service + 1;
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
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                        }

                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());

                    $('#invoice_date').val(resp.data[0]["dated"]);
                    $('#customer_id').val(resp.data[0]["customers_id"]);
                    $('#remark').val(resp.data[0]["order_remark"]);
                    $('#payment_type').val(resp.data[0]["payment_type"]);
                    $('#payment_nominal').val(resp.data[0]["payment_nominal"]);


                });

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
                  product : orderList,
                  customer_id : $('#customer_id').val(),
                  remark : $('#remark').val(),
                  payment_type : $('#payment_type').val(),
                  payment_nominal : $('#payment_nominal').val(),
                  total_order : order_total,
                  kurs : $('#kurs').val(),
                  currency : $('#currency').find(':selected').val(),
                  customer_type : $('#customer_type').val(),
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
                      Swal.fire({
                        text: "@lang('general.lbl_msg_success_invoice') "+resp.data.message,
                        title : "@lang('general.lbl_success')",
                        icon: 'success',
                        showDenyButton: false,
                        showCancelButton: true,
                        cancelButtonColor: '#d33',
                        denyButtonColor: '#0072b3',
                        cancelButtonText: "@lang('general.lbl_close')",
                        confirmButtonText: "@lang('general.lbl_print')",
                      }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                          burl ="{{ route('invoices.print', 'WWWW') }}";
                          burl = burl.replace('WWWW', resp.data.data)
                          //window.location.href = burl; 
                          window.open(
                            burl,
                            '_blank' // <- This is what makes it open in a new window.
                          );
                          window.location.href = "{{ route('invoices.index') }}"; 
                        } else if (result.isDenied) {
                          burl = "{{ route('invoices.printspk', 'WWWW') }}";
                          burl = burl.replace('WWWW', resp.data.data)
                          window.open(
                            burl,
                            '_blank' // <- This is what makes it open in a new window.
                          );
                          window.location.href = "{{ route('invoices.index') }}"; 
                        }else{
                          window.location.href = "{{ route('invoices.index') }}"; 
                        }
                      })
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
            { data: 'abbr' },
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

        function addProduct(id,abbr, price, discount, qty, uom,vat_total,total,type_id){
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
                "uom" : uom,
                "vat_total"     : vat_total, 
                "type_id"     : type_id, 
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

            if(obj["type_id"]=="Services"){
              
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
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
              }else{
                $('#order_charge').text("0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
              }


          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());

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

            orderList.sort(function(a, b) {
                return parseFloat(a.entry_time) - parseFloat(b.entry_time);
            });

            counterno = 0;
            counterno_service = 0;

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type_id"]=="Services"){
              
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
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
              }else{
                $('#order_charge').text("0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
              }


            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());

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

            orderList.sort(function(a, b) {
                return parseFloat(a.entry_time) - parseFloat(b.entry_time);
            });

            counterno = 0;
             counterno_service = 0;
            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type_id"]=="Services"){
              
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
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
              }else{
                $('#order_charge').text("0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
              }


            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());

        });




            $("#payment_nominal").on("input", function(){
              order_total = 0;
              for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];
                  order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                  if(($('#payment_nominal').val())>order_total){
                    $('#order_charge').css('color', 'black');
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                  }else{
                    $('#order_charge').text("0");
                    $('#order_charge').css('color', 'red');
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                  }


                }
              });


            var url = "{{ route('orders.getproduct') }}";
            var lastvalurl = "XX";
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
                          "type"     : resp.data[i]["type"],
                          "vat_total"     : resp.data[i]["vat_total"]
                    }

                    productList.push(product);
                }

                for (var i = 0; i < productList.length; i++){
                  var obj = productList[i];
                  var newOption = new Option(obj["remark"], obj["id"], false, false);
                  if((obj["type"]=="Services")||(obj["type"]=="Extra")){
                    $('#input_service_id').append(newOption).trigger('change');  
                  }else{
                    $('#input_product_id').append(newOption).trigger('change');  
                  }
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
                    $('#input_product_total').val(),"Good"
                  );
                }
              });

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

                    orderList.sort(function(a, b) {
                        return parseFloat(a.entry_time) - parseFloat(b.entry_time);
                    });


                    counterno = 0;
                    counterno_service = 0;

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


                      var obj = orderList[i];
                      var value = obj["abbr"];
                      if(obj["type_id"]=="Services"){
                        
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
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                        }


                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());


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
