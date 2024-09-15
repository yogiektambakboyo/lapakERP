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

              <label class="form-label col-form-label col-md-1">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-2">
                <input type="text" 
                name="invoice_date"
                id="invoice_date"
                class="form-control" 
                value="{{ old('invoice_date') }}" required/>
                @if ($errors->has('invoice_date'))
                          <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                      @endif
              </div>

            <label class="form-label col-form-label col-md-1">@lang('general.lbl_customer')</label>
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


              <label class="form-label col-form-label col-md-1">@lang('general.lbl_remark')</label>
              <div class="col-md-3">
                <input type="text" 
                name="remark"
                id="remark"
                class="form-control" 
                value="{{ old('remark') }}"/>
                </div>


            
        </div>


        <div class="row mb-3">
          <div class="col-md-9">
            <div class="row mb-2">
              <div class="p-1 bg-teal-600 text-white">
                <div class="row ps-2">
                  <div class="col-md-8 fw-bold pt-0">@lang('general.lbl_product_list')</div>
                  <div class="col-md-4 fw-bold pt-0"><input placeholder="@lang('general.lbl_search_product')" class="form form-control" type="text" name="search_product" id="search_product"></div>
                </div>
              </div>
            </div>

            <div class="row" id="content-product"></div>

          </div>
          <div class="col-md-3"></div>

        </div>
        
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

    </div>
  </div>
</form>
@endsection

@push('scripts')
    <script type="text/javascript">
      $(function () {
        $('#customer_id').select2();
        $('#lbl_total').text("Total ("+$('#curr_def').val()+")");

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


          $('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
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
                $('#content-product').html("");
                $content = "";
              
                for(var i=0;i<resp.data.length;i++){
                    var product = {
                          "id"        : resp.data[i]["id"],
                          "abbr"      : resp.data[i]["abbr"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"      : resp.data[i]["uom"],
                          "price"     : resp.data[i]["price"],
                          "type"     : resp.data[i]["type"],
                          "photo"     : resp.data[i]["photo"],
                          "vat_total"     : resp.data[i]["vat_total"]
                    }

                    productList.push(product);

                    // Generate Product Card
                    $content = $content + '<div class="border rounded ms-1 mt-1" style="height: 250px;width : 157px;"><img src="../images/user-files/'+resp.data[i]["photo"]+'" style="height: 135px;width : 135px;" class="mt-2" alt="..."><div class="mt-1" style="height:34px;">'+resp.data[i]["remark"]+'</div><div class="fw-bold">'+currency((resp.data[i]["price"]), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format()+'</div><div class="d-grid gap-2 mt-1"><button class="btn btn-primary" id="btn_add_c_'+resp.data[i]["id"]+'" type="button">@lang('general.lbl_add')</button></div></div>';
                  }

                  $('#content-product').html($content);


          });

          $('#search_product').on('change keyup',function(){
            var keyword = $('#search_product').val().toUpperCase();
            $('#content-product').html("");
            $content = "";

            for (let index = 0; index < productList.length; index++) {
              const element = productList[index];
              if(element.remark.toUpperCase().indexOf(keyword) != -1){
                $content = $content + '<div class="border rounded ms-1 mt-1" style="height: 250px;width : 157px;"><img src="../images/user-files/'+element.photo+'" style="height: 135px;width : 135px;" class="mt-2" alt="..."><div class="mt-1" style="height:34px;">'+element.remark+'</div><div class="fw-bold">'+currency((element.price), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format()+'</div><div class="d-grid gap-2 mt-1"><button class="btn btn-primary" id="btn_add_c_'+element.id+'" type="button">@lang('general.lbl_add')</button></div></div>';
              }
            }
            
            $('#content-product').html($content);
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
