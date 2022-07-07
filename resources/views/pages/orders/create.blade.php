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
              <div class="col-md-10">
                <select class="form-control" 
                    name="customer_id" id="customer_id" required>
                    <option value="">Select Customers</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}">{{ $customer->id }} - {{ $customer->name }} </option>
                    @endforeach
                </select>
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
                  <th scope="col" width="10%">Price</th>
                  <th scope="col" width="5%">Discount</th>
                  <th scope="col" width="5%">Qty</th>
                  <th scope="col" width="15%">Total</th>  
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

        //sitePersonel.employees[0].manager = manager;

        var table = $('#order_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<a href="#" id="add_row" class="btn btn-xs btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'+
            '<a href="#" id="minus_row" class="btn btn-xs btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'+
            '<a href="#" id="delete_row" class="btn btn-xs btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>',}],
          columns: [
            { data: 'abbr' },
            { data: 'price',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'discount' },
            { data: 'qty' },
            { data: 'total',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, discount, qty){
          table.clear().draw(false);
          order_total = 0;
          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "price"     : price,
                "discount"  : discount,
                "qty"       : "1",
                "total"     : price,
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
                    "price"     : obj["price"],
                    "discount"  : obj["discount"],
                    "qty"       : obj["qty"],
                    "total"     : obj["total"],
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
            }

            for (var i = 0; i < productList.length; i++){
              var obj = productList[i];
              table.row.add( {
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
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
