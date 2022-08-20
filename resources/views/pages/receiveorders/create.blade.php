@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Receive Order')

@section('content')
<form method="POST" action="{{ route('receiveorders.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Receive Order</h4></div>
      <div class="">
        <a href="{{ route('receiveorders.index') }}" class="btn btn-default">Cancel</a>
        <button type="button" id="save-btn" class="btn btn-info">Save</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="row mb-3">
          <div class="col-md-12">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">Date (mm/dd/YYYY)</label>
              <div class="col-md-1">
                <input type="text" 
                name="receive_date"
                id="receive_date"
                class="form-control" 
                value="{{ old('purchase_date') }}" required/>
                @if ($errors->has('purchase_date'))
                          <span class="text-danger text-left">{{ $errors->first('purchase_date') }}</span>
                      @endif
              </div>


              <label class="form-label col-form-label col-md-1">PO</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="ref_no" id="ref_no" required>
                    <option value="">Select Purchase Order</option>
                    @foreach($purchases as $purchase)
                    <option value="{{ $purchase->purchase_no }}">{{ $purchase->purchase_no }} </option>
                    @endforeach
                </select>
              </div>


              <label class="form-label col-form-label col-md-1">Shipto</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="branch_id" id="branch_id" required>
                    <option value="">Select Branch</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}">{{ $branch->remark }} </option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">Supplier</label>
              <div class="col-md-1">
                <select class="form-control" 
                    name="supplier_id" id="supplier_id" required>
                    <option value="">Select Suppliers</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}">{{ $supplier->id }} - {{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>

                <label class="form-label col-form-label col-md-1">Remark</label>
                <div class="col-md-1">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ old('remark') }}"/>
                  </div>
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>Receive List</strong></div>
            <div class="row mb-3">
              <div class="col-md-2">
                <label class="form-label col-form-label">Product</label>
                <select class="form-control" 
                      name="input_product_id" id="input_product_id" required>
                      <option value="">Select Product</option>
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
                value="{{ old('input_product_price') }}" required/>
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
                <label class="form-label col-form-label">Expired Date (mm/dd/YYYY)</label>
                <input type="text" 
                name="input_expired_at"
                id="input_expired_at"
                class="form-control" 
                value="{{ old('input_expired_at') }}" required/>
                @if ($errors->has('input_expired_at'))
                          <span class="text-danger text-left">{{ $errors->first('input_expired_at') }}</span>
                      @endif
              </div>


              <div class="col-md-1">
                <label class="form-label col-form-label">Batch No</label>
                <input type="text" 
                name="input_batch_no"
                id="input_batch_no"
                class="form-control" 
                value="{{ old('input_batch_no') }}"/>
              </div>

              <div class="col-md-2">
                <label class="form-label col-form-label">Total</label>
                <input type="text" 
                name="input_product_total"
                id="input_product_total"
                class="form-control" 
                value="{{ old('input_product_total') }}" required disabled/>
              </div>

              <div class="col-md-1">
                <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
                <a href="#" id="input_product_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>Add Product</div></a>
              </div>

            </div>
            

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>Product Code</th>
                  <th scope="col" width="10%">UOM</th>
                  <th scope="col" width="10%">Price</th>
                  <th scope="col" width="5%">Qty</th>
                  <th scope="col" width="10%">Expired</th>
                  <th scope="col" width="10%">Batch No</th>
                  <th scope="col" width="10%">Total</th>
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
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_referred">Apply</button>
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
                        value="{{ old('receive_date') }}" required/>
                        @if ($errors->has('receive_date'))
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

          <div class="col-md-12">
          </div>

          <div class="modal fade" id="modal-exp" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">Expired Date & Batch Number</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <label class="form-label col-form-label col-md-12">Expired Date</label>
                  <input type="hidden" id="product_id_selected" value="">
                  <div class="col-md-12">
                    <input id="input_expired_at_list" class="form-control" name="input_expired_at_list" type="text">
                  </div>
                  <label class="form-label col-form-label col-md-12">Batch Number  </label>
                  <div class="col-md-12">
                    <input id="input_bno_list" class="form-control" name="input_bno_list" type="text">
                  </div>
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_apply_exp">Apply</button>
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
    const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;
        $(function () {
          $('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          
          
          $('#receive_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#receive_date').val(formattedToday);
          $('#input_expired_at').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#input_expired_at').val(formattedNextYear);


          $('#input_expired_at_list').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#input_expired_at_list').val(formattedNextYear);


          var url = "{{ route('receiveorders.getproduct') }}";
          var lastvalurl = "XX";
          console.log(url);
          url = url.replace(lastvalurl, $(this).val())
          lastvalurl = $(this).val();
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
                          "price"     : resp.data[i]["price"]
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
                        $('#input_product_total').val(v.price);
                        return;
                    }
                });
              });

              $('#input_product_price').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val()))
              });

              $('#input_product_qty').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val()))
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
                }else{
                  addProduct($('#input_product_id').val(),$('#input_product_id option:selected').text(), $('#input_product_price').val(), $('#input_product_total').val(), $('#input_product_qty').val(), $('#input_product_uom').val(),$('#input_expired_at').val(),$('#input_batch_no').val());
                }
              });
              

          });


      });

      var url = "{{ route('purchaseorders.getdocdata','XX') }}";
          var lastvalurl = "XX";
          console.log(url);
          $('#ref_no').change(function(){
              if($(this).val()==""){
                      table.clear().draw(false);
                      order_total = 0;
                      orderList = [];
                      $('#order_charge').text("Rp. 0");
                      $('#order-total').text("Rp. 0");

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
                                "exp"       : formattedNextYear,
                                "bno"       : "",
                                "total"     : resp.data[i]["total"],
                          }

                          orderList.push(product);
                      }

                      for (var i = 0; i < orderList.length; i++){
                      var obj = orderList[i];
                      var value = obj["abbr"];
                      table.row.add( {
                          "abbr"      : obj["abbr"],
                          "uom"       : obj["uom"],
                          "price"     : obj["price"],
                          "qty"       : obj["qty"],
                          "exp"       : formattedNextYear,
                          "bno"       : '',
                          "total"     : obj["total"],
                          "action"    : "",
                        }).draw(false);
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]));                        
                    }

                    $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

                    $('#supplier_id').val(resp.data[0]["supplier_id"]);
                    $('#remark').val(resp.data[0]["d_remark"]);
                    $('#branch_id').val(resp.data[0]["branch_id"]);
                    $('#branch_id').trigger('change');

                });

              }
          });

      
      var productList = [];
      var orderList = [];
      var order_total = 0;

      $('#btn_apply_exp').on('click', function(){
        table.clear().draw(false);
        order_total = 0;
          
        for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if($('#product_id_selected').val()==obj["id"]){
              orderList[i]["exp"] = $('#input_expired_at_list').val();
              orderList[i]["bno"] = $('#input_bno_list').val();
            }
          }

          for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              table.row.add( {
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"      : obj["price"],
                      "qty"       : obj["qty"],
                      "exp"       : obj["exp"],
                      "bno"       : obj["bno"],
                      "total"       : obj["total"],
                      "action"    : "",
                }).draw(false);
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]));
            }

            $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

      });
        
        $('#save-btn').on('click',function(){
          if($('#branch_id').val()==''){
            $('#branch_id').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose shipto',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#supplier_id').val()==''){
            $('#supplier_id').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose supplier',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#purchase_date').val()==''){
            $('#purchase_date').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose purchase date',
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
                branch_id : $('#branch_id').val(),
                product : orderList,
                supplier_id : $('#supplier_id').val(),
                remark : $('#remark').val(),
                ref_no : $('#ref_no').val(),
                total_order : order_total,
                dated : $('#receive_date').val(),
              }
            );
            const res = axios.post("{{ route('receiveorders.store') }}", json, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.href = "{{ route('receiveorders.index') }}"; 
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

        var table = $('#order_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<a href="#" id="add_row" class="btn btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-lg"></i></div></a>'+
            '  <a href="#" id="minus_row" class="btn btn-yellow ml-1"><div class="fa-1x"><i class="fas fa-circle-minus fa-lg"></i></div></a>'+
            '  <a href="#" id="delete_row" class="btn btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-lg"></i></div></a>'+
            '  <a href="#" href="#modal-exp" data-bs-toggle="modal" data-bs-target="#modal-exp" id="exp_row" class="btn btn-indigo"><div class="fa-1x"><i class="fas fa-calendar-days fa-fw"></i></div></a>'
          }],
          columns: [
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price' },
            { data: 'qty' },
            { data: 'exp' },
            { data: 'bno' },
            { data: 'total' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, total, qty, uom,exp, bno){
          table.clear().draw(false);
          order_total = 0;
          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "qty"       : qty,
                "exp"       : exp,
                "bno"       : bno,
                "price"     : price,
                "total"     : total,
                "uom" : uom
          }

          var isExist = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if(id==obj["id"]&&exp==obj["exp"]){
              isExist = 1;
              orderList[i]["total"] = (parseInt(orderList[i]["qty"])+parseInt(qty))*parseFloat(orderList[i]["price"]); 
              orderList[i]["qty"] = parseInt(orderList[i]["qty"])+parseInt(qty);
            }
          }

          if(isExist==0){
            orderList.push(product);
          }


          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];
            table.row.add( {
                   "id"         : obj["id"],
                    "abbr"      : obj["abbr"],
                    "uom"       : obj["uom"],
                    "price"     : obj["price"],
                    "qty"       : obj["qty"],
                    "exp"       : obj["exp"],
                    "bno"       : obj["bno"],
                    "total"     : obj["total"],
                    "action"    : "",
              }).draw(false);
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]));
              
          }

          $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        }

        $('#order_table tbody').on('click', 'a', function () {
            var data = table.row($(this).parents('tr')).data();
            order_total = 0;
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

              if($(this).attr("id")=="exp_row"){
                if(data["id"]==obj["id"]){
                  $('#product_id_selected').val(data["id"]);
                  $('#input_bno_list').val(data["bno"]);
                  $('#input_expired_at_list').val(data["exp"]);
                  $('#input_expired_list_at_lbl').text("Product "+data["abbr"]);
                }
              }

            }

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              table.row.add( {
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"      : obj["price"],
                      "qty"       : obj["qty"],
                      "exp"       : obj["exp"],
                      "bno"       : obj["bno"],
                      "total"       : obj["total"],
                      "action"    : "",
                }).draw(false);
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]));
            }

            $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        });

    </script>
@endpush
