@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Sales Order')

@section('content')
<form method="POST" action="{{ route('orders.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Sales Order</h4></div>
      <div class="">
        <a href="{{ route('orders.index') }}" class="btn btn-default">Cancel</a>
        <button type="button" id="save-btn" class="btn btn-info">Save</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-4">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">Date (mm/dd/YYYY)</label>
              <div class="col-md-8">
                <input type="text" 
                name="order_date"
                id="order_date"
                class="form-control" 
                value="{{ old('order_date') }}" required/>
                @if ($errors->has('order_date'))
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


            <div class="panel-heading bg-teal-600 text-white"><strong>Product List</strong></div>
            </br>
            <div class="row mb-3">
              <table class="table table-striped" id="product-table">
                <thead>
                <tr>
                    <th scope="col" width="20%">Code</th>
                    <th>Product</th>
                    <th scope="col" width="5%">Type</th>
                    <th scope="col" width="5%">Action</th>  
                </tr>
                </thead>
                <tbody>
                </tbody>
              </table>    
            </div>
          </div>

          <div class="col-md-8">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Customer</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="customer_id" id="customer_id" required>
                    <option value="">Select Customers</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}">{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>
              <div class="col-md-1">
                <a type="button" id="add-customer-btn" class="btn btn-green"  href="#modal-add-customer" data-bs-toggle="modal" data-bs-target="#modal-add-customer"><span class="fas fa-user-plus"></span></a>
              </div>
              <label class="form-label col-form-label col-md-2">Schedule</label>
              <div class="col-md-4">

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
                  value="{{ old('remark') }}" required/>
                  </div>

                  <label class="form-label col-form-label col-md-1">Charge</label>
                  <div class="col-md-3">
                    <h2 class="text-end"><label id="order_charge">Rp. 0</label></h2>
                  </div>
                
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>Order List</strong></div>
            </br>

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>Product Code</th>
                  <th scope="col" width="10%">UOM</th>
                  <th scope="col" width="10%">Price</th>
                  <th scope="col" width="5%">Discount</th>
                  <th scope="col" width="5%">Qty</th>
                  <th scope="col" width="15%">Total</th>  
                  <th scope="col" width="15%">Assigned to</th>  
                  <th scope="col" width="15%">Action</th>  
              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2"><h1>Total</h1></label>
              <div class="col-md-10">
                <h1 class="display-5 text-end"><label id="order-total">Rp. 0</label></h1>
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
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_assigned">Apply</button>
                  </div>
              </div>
              </div>
            </div>

            <div class="modal fade" id="modal-add-customer" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">Add Customer</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    
                    <div class="container mt-4">
                            <div class="mb-3">
                                <label for="cust_name" class="form-label">Name</label>
                                <input value="{{ old('cust_name') }}" 
                                    type="text" 
                                    class="form-control" 
                                    name="cust_name" 
                                    id="cust_name" 
                                    placeholder="Name" required>
            
                                @if ($errors->has('cust_name'))
                                    <span class="text-danger text-left">{{ $errors->first('cust_name') }}</span>
                                @endif
                            </div>
            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <input value="{{ old('cust_address') }}" 
                                    type="text" 
                                    class="form-control" 
                                    name="cust_address" id="cust_address" 
                                    placeholder="Address" required>
            
                                @if ($errors->has('cust_address'))
                                    <span class="text-danger text-left">{{ $errors->first('cust_address') }}</span>
                                @endif
                            </div>
            
                            <div class="mb-3">
                                <label for="cust_phone_no" class="form-label">Phone No</label>
                                <input value="{{ old('cust_phone_no') }}" 
                                    type="text" 
                                    class="form-control" 
                                    name="cust_phone_no" id="cust_phone_no" 
                                    placeholder="Phone No" required>
            
                                @if ($errors->has('cust_phone_no'))
                                    <span class="text-danger text-left">{{ $errors->first('cust_phone_no') }}</span>
                                @endif
                            </div>
            
                            <div class="mb-3">
                                <label class="form-label">Branch</label>
                                <div class="col-md-12">
                                  <select class="form-control" 
                                        name="cust_branch_id" id="cust_branch_id">
                                        <option value="">Select Branch</option>
                                        @foreach($branchs as $branch)
                                            <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                                        @endforeach
                                    </select>
                                </div>
                              </div>
                    </div>

                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_save_customer">Save Customer</button>
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
                        value="{{ old('order_date') }}" required/>
                        @if ($errors->has('order_date'))
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
                            <th scope="col" width="15%">Customer</th>
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
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_scheduled">Apply</button>
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

          $('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          $('#order_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#order_date').val(formattedToday);
          $('#schedule_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#schedule_date').val(formattedToday);

          $('#customer_id').select2({});
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
                scheduled_at : $('#schedule_date').val()+" "+$('#timepicker1').val(),
                branch_room_id : $('#room_id').val()
              }
            );
            const res = axios.post("{{ route('orders.store') }}", json, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.href = "{{ route('orders.index') }}"; 
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
            { data: 'order_no' },
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
            '<a href="#" id="add_row" class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'+
            '<a href="#" id="minus_row" class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'+
            '<a href="#" id="delete_row" class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>'+
            '<a href="#" href="#modal-filter" data-bs-toggle="modal" data-bs-target="#modal-filter" id="assign_row" class="btn btn-xs btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></a>',}],
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

        function addProduct(id,abbr, price, discount, qty, uom){
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
 
    </script>
@endpush
