@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Sales Order')

@section('content')
<form method="POST" action="{{ route('invoices.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_invoice')  {{ $invoice->invoice_no }}</h4></div>
      <div class="">
        <a href="{{ route('invoices.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-4">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-8">
                <input type="hidden" id="invoice_no" name="invoice_no" value="{{ $invoice->invoice_no }}">
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ substr(explode(" ",$invoice->dated)[0],5,2) }}/{{ substr(explode(" ",$invoice->dated)[0],8,2) }}/{{ substr(explode(" ",$invoice->dated)[0],0,4) }}" required/>
                @if ($errors->has('order_date'))
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

            <div class="panel-heading bg-teal-600 text-white"><strong>Product List</strong></div>
            </br>
            <div class="row mb-3">
              <table class="table table-striped" id="product-table">
                <thead>
                <tr>
                    <th scope="col" width="20%">Code</th>
                    <th>@lang('general.product')</th>
                    <th scope="col" width="5%">Type</th>
                    <th scope="col" width="5%" class="nex">@lang('general.lbl_action')</th> 
                </tr>
                </thead>
                <tbody>
                </tbody>
              </table>    
            </div>

          </div>

          <div class="col-md-8">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">Ref No.</label>
              <div class="col-md-3">
                <input type="text" class="form-control" id="ref_no" name="ref_no" value="{{ $invoice->ref_no }}" id="scheduled" disabled>
              </div>
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_customer')</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="customer_id" id="customer_id">
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}" {{ ($customer->id == $invoice->customers_id) 
                          ? 'selected'
                          : ''}}>{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_schedule')</label>
              <div class="col-md-3">

                  <div class="input-group">
                    <input type="text" class="form-control" id="scheduled" value="{{ $room->remark }} - {{ $invoice->scheduled_at }}">
                    <button type="button" class="btn btn-indigo" data-bs-toggle="modal" data-bs-target="#modal-scheduled" >
                      <span class="fas fa-calendar-days"></span>
                    </button>
                  </div>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_type_payment')</label>
              <div class="col-md-2">
                <select class="form-control" 
                      name="payment_type" id ="payment_type" >
                      <option value="">@lang('general.lbl_type_paymentselect')</option>
                      @foreach($payment_type as $value)
                          <option value="{{ $value }}" {{ ($invoice->payment_type == $value) 
                            ? 'selected'
                            : ''}}>{{ $value }}</option>
                      @endforeach
                  </select>
              </div>

                <label class="form-label col-form-label col-md-2">@lang('general.lbl_nominal_payment')</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="{{ $invoice->payment_nominal }}" />
                  </div>

                  <label class="form-label col-form-label col-md-1">@lang('general.lbl_charge')</label>
                  <div class="col-md-3">
                    <h2 class="text-end"><label id="order_charge">Rp. {{ number_format(($invoice->payment_nominal-$invoice->total), 2, ',', '.') }}</label></h2>
                  </div>
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>Invoice List</strong></div>
              </br>
            <div class="row mb-3">
            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                <th>@lang('general.product')</th>
                <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                <th scope="col" width="10%">@lang('general.lbl_price')</th>
                <th scope="col" width="5%">@lang('general.lbl_discount')</th>
                <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                <th scope="col" width="15%">Total</th>  
                <th scope="col" width="15%">@lang('general.lbl_terapist')</th>  
                <th scope="col" width="15%" class="nex">@lang('general.lbl_action')</th> 
              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2"><h1>Total</h1></label>
              <div class="col-md-10">
                <h1 class="display-5 text-end"><label id="order-total">Rp. {{ number_format($invoice->total, 2, ',', '.') }}</label></h1>
              </div>
            </div>

            <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_assign')</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <label class="form-label col-form-label col-md-8" id="product_id_selected_lbl">@lang('general.lbl_assignselect') </label>
                    <input type="hidden" id="product_id_selected" value="">
                    <div class="col-md-8">
                      <select class="form-control" 
                          name="assign_id" id="assign_id" required>
                          <option value="">@lang('general.lbl_assignselect') </option>
                          @foreach($users as $user)
                              <option value="{{ $user->id }}">{{ $user->name }}</option>
                          @endforeach
                      </select>
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_assigned">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>

            <div class="modal fade" id="modal-scheduled" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_scheduleselect')  </h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">

                    <div class="row mb-3">
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-8">@lang('general.lbl_room')   </label>
                      </div>
                      <div class="col-md-2">
                          <select class="form-control" 
                              name="room_id" id="room_id" required>
                              <option value="">@lang('general.lbl_roomselect')   </option>
                              @foreach($rooms as $roomx)
                                  <option value="{{ $roomx->id }}"  {{ $roomx->remark==$room->remark?"selected":"" }}>{{ $roomx->remark }}</option>
                              @endforeach
                          </select>
                      </div>
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated')   </label>
                      </div>
                      <div class="col-md-2">
                        <input type="text" 
                        name="schedule_date"
                        id="schedule_date"
                        class="form-control" 
                        value="{{ substr(explode(" ",$invoice->scheduled_at)[0],5,2) }}/{{ substr(explode(" ",$invoice->scheduled_at)[0],8,2) }}/{{ substr(explode(" ",$invoice->scheduled_at)[0],0,4) }}" required/>
                        @if ($errors->has('order_date'))
                                  <span class="text-danger text-left">{{ $errors->first('schedule_date') }}</span>
                              @endif
                      </div>
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-8">@lang('general.lbl_time')   </label>
                      </div>
                      <div class="col-md-2">
                        <div class="input-group bootstrap-timepicker timepicker">
                            <input id="timepicker1" type="text" class="form-control input-small" value="{{ explode(" ",$invoice->scheduled_at)[1] }}">
                            <span class="btn btn-indigo input-group-addon"><i class="fas fa-clock"></i></span>
                        </div>    
                      </div>
                    </div>
                   
                    <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_schedule_list')   </strong></div>
                    </br>
      
                    <div class="col-md-12">
                      <table class="table table-striped" id="order_time_table" style="width:100%">
                        <thead>
                        <tr>
                            <th>@lang('general.lbl_room')   </th>
                            <th scope="col" width="25%">@lang('general.lbl_invoice_no')   </th>
                            <th scope="col" width="15%">@lang('general.lbl_total_customer')</th>
                            <th scope="col" width="15%">@lang('general.lbl_schedule_at')   </th>
                            <th scope="col" width="5%">@lang('general.lbl_duration')   </th>
                            <th scope="col" width="15%">@lang('general.lbl_end_estimation') </th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                      </table> 
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_scheduled">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>



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
          $('#order_date').datepicker({
              format : 'yyyy-mm-dd'
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
          for (var i = 0; i < productList.length; i++){
            var obj = productList[i];
            var value = obj["id"];
            if($('#product_id_selected').val()==obj["id"]){
              productList[i]["assignedto"] = $('#assign_id option:selected').text();
              productList[i]["assignedtoid"] = $('#assign_id').val();
            }
          }


          for (var i = 0; i < productList.length; i++){
            var obj = productList[i];
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
                    "action"    : "",
              }).draw(false);
              order_total = order_total + ((parseInt(productList[i]["qty"]))*parseFloat(productList[i]["price"]));
              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
              }
          }

          $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        }
      });

      var productList = [];
      var order_total = 0;

      

        $('#save-btn').on('click',function(){
          if($('#order_date').val()==''){
            $('#order_date').focus();
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
              const json = JSON.stringify({
                order_date : $('#order_date').val(),
                product : productList,
                customer_id : $('#customer_id').val(),
                remark : $('#remark').val(),
                payment_type : $('#payment_type').val(),
                payment_nominal : $('#payment_nominal').val(),
                total_order : order_total,
                invoice_no :  $('#invoice_no').val(),
                scheduled_at : $('#schedule_date').val()+" "+$('#timepicker1').val(),
                branch_room_id : $('#room_id').val(),
                ref_no : $('#ref_no').val(),
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
        });
        
        $('#product-table').DataTable({
          "bInfo" : false,
          pagingType: 'numbers',
          ajax: "{{ route('orders.getproduct') }}",
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
          ajax: "{{ route('orders.gettimetable') }}",
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
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'+
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'+
            '<a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>'+
            '<a href="#" href="#modal-filter" data-bs-toggle="modal" data-bs-target="#modal-filter"  data-toggle="tooltip" data-placement="top" title="Terapis" id="assign_row" class="btn btn-xs btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></a>',}],
          columns: [
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'discount' },
            { data: 'qty' },
            { data: 'total',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'assignedto' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, discount, qty,uom){
          table.clear().draw(false);
          order_total = 0;
          var product = {
            "id"        : id,
                "abbr"      : abbr,
                "price"     : price,
                "discount"  : discount,
                "qty"       : "1",
                "total"     : price,
                "assignedto" : "",
                "assignedtoid" : "",
                "uom" : uom,
          }

          var isExist = 0;
          for (var i = 0; i < productList.length; i++){
            var obj = productList[i];
            var value = obj["id"];
            if(id==obj["id"]){
              isExist = 1;
              productList[i]["total"] = (parseInt(productList[i]["qty"])+1)*parseFloat(productList[i]["price"]); 
              productList[i]["qty"] = parseInt(productList[i]["qty"])+1;
            }
          }

          if(isExist==0){
            productList.push(product);
          }


          for (var i = 0; i < productList.length; i++){
            var obj = productList[i];
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
                    "action"    : "",
              }).draw(false);
              order_total = order_total + ((parseInt(productList[i]["qty"]))*parseFloat(productList[i]["price"]));
              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
              }
          }

          $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        }

        $('#order_table tbody').on('click', 'a', function () {
            var data = table.row($(this).parents('tr')).data();
            order_total = 0;
            table.clear().draw(false);
            
            for (var i = 0; i < productList.length; i++){
              var obj = productList[i];
              var value = obj["id"];

              if($(this).attr("id")=="add_row"){
                if(data["id"]==obj["id"]){
                  productList[i]["total"] = (parseInt(productList[i]["qty"])+1)*parseFloat(productList[i]["price"]); 
                  productList[i]["qty"] = parseInt(productList[i]["qty"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(productList[i]["qty"])>1){
                  productList[i]["total"] = (parseInt(productList[i]["qty"])-1)*parseFloat(productList[i]["price"]); 
                  productList[i]["qty"] = parseInt(productList[i]["qty"])-1;
                } else if(data["id"]==obj["id"]&&parseInt(productList[i]["qty"])==1) {
                  productList.splice(i,1);
                }
              }

              if($(this).attr("id")=="delete_row"){
                if(data["id"]==obj["id"]){
                  productList.splice(i,1);
                }
              }

              if($(this).attr("id")=="assign_row"){
                if(data["id"]==obj["id"]){
                  $('#product_id_selected').val(data["id"]);
                  $('#product_id_selected_lbl').text("Choose terapist for product "+data["abbr"]);
                }
              }
            }

            for (var i = 0; i < productList.length; i++){
              var obj = productList[i];
              table.row.add( {
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto" : obj["assignedto"],
                      "action"    : "",
                }).draw(false);
              order_total = order_total + ((parseInt(productList[i]["qty"]))*parseFloat(productList[i]["price"]));
              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
              }
            }

            $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        });

            $("#payment_nominal").on("input", function(){
              order_total = 0;
              for (var i = 0; i < productList.length; i++){
                  var obj = productList[i];
                  order_total = order_total + ((parseInt(productList[i]["qty"]))*parseFloat(productList[i]["price"]));
                  if(($('#payment_nominal').val())>order_total){
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                  }else{
                    $('#order_charge').text("Rp. 0");
                  }
                }
              });


              const res = axios.get("{{ route('invoices.getinvoice',$invoice->invoice_no) }}", {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  console.log(resp.data);
                  table.clear().draw(false);
                  order_total = 0;

                  for(var i=0;i<resp.data.length;i++){
                      var product = {
                            "id"        : resp.data[i]["product_id"],
                            "abbr"      : resp.data[i]["abbr"],
                            "uom"      : resp.data[i]["uom"],
                            "price"     : resp.data[i]["price"],
                            "discount"  : resp.data[i]["discount"],
                            "qty"       : resp.data[i]["qty"],
                            "total"     : resp.data[i]["total"],
                            "assignedto"     : resp.data[i]["assignedto"],
                            "assignedtoid"     : resp.data[i]["assignedtoid"],
                      }

                      productList.push(product);
                  }

                  for (var i = 0; i < productList.length; i++){
                  var obj = productList[i];
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
                      "action"    : "",
                    }).draw(false);
                    order_total = order_total + ((parseInt(productList[i]["qty"]))*parseFloat(productList[i]["price"]));
                    if(($('#payment_nominal').val())>order_total){
                      $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    }else{
                      $('#order_charge').text("Rp. 0");
                    }
                }

                $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            });

 
    </script>
@endpush
