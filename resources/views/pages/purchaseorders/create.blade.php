@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Purchase Order')

@section('content')
<form method="POST" action="{{ route('purchaseorders.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">New Purchase Order</h4></div>
      <div class="">
        <a href="{{ route('purchaseorders.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">
        <div class="row mb-3">
          <div class="row mb-3">
          <div class="col-md-12">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-2">
                <input type="text" 
                name="doc_dated"
                id="doc_dated"
                class="form-control" 
                value="{{ old('purchase_date') }}" required/>
                @if ($errors->has('purchase_date'))
                          <span class="text-danger text-left">{{ $errors->first('purchase_date') }}</span>
                      @endif
              </div>

              <label class="form-label col-form-label col-md-1">Shipto</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="branch_id" id="branch_id" required>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}">{{ $branch->remark }} </option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">Supplier</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="supplier_id" id="supplier_id" required>
                    <option value="">Select Suppliers</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}">{{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>

                <label class="form-label col-form-label col-md-1">@lang('general.lbl_remark')</label>
                <div class="col-md-2">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ old('remark') }}"/>
                  </div>
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
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
                value="{{ old('input_product_price') }}" required/>
              </div>

              <div class="col-md-1">
                <label class="form-label col-form-label">@lang('general.lbl_qty')</label>
                <input type="text" 
                name="input_product_qty"
                id="input_product_qty"
                class="form-control" 
                value="{{ old('input_product_qty') }}" required/>
              </div>

              <div class="col-md-1">
                <label class="form-label col-form-label">@lang('general.lbl_discountrp')</label>
                <input type="text" 
                name="input_product_disc"
                id="input_product_disc"
                class="form-control" 
                value="{{ old('input_product_disc') }}" required/>
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
            

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>Product Name</th>
                  <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                  <th scope="col" width="10%">@lang('general.lbl_price')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="10%">Disc</th>
                  <th scope="col" width="10%">Total</th>
                  <th scope="col" width="20%">@lang('general.lbl_action')</th> 
              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
        
            <br>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-9 text-end"><h2>Sub Total </h2></label>
              <div class="col-md-3">
                <h3 class="text-end"><label id="sub-total">0</label></h3>
              </div>

              <label class="form-label col-form-label col-md-9 text-end"><h2>@lang('general.lbl_tax') </h2></label>
              <div class="col-md-3">
                <h3 class="text-end"><label id="vat-total">0</label></h3>
              </div>

              <label class="form-label col-form-label col-md-9 text-end"><h1>Total</h1></label>
              <div class="col-md-3">
                <h1 class="display-5 text-end"><label id="result-total">Rp. 0</label></h1>
              </div>
            </div>
          </div>

          <div class="col-md-12">
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
          
          $('#doc_dated').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#doc_dated').val(formattedToday);
          $('#schedule_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#schedule_date').val(formattedToday);

          var url = "{{ route('purchaseorders.getproduct') }}";
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
                }else{
                  addProduct($('#input_product_id').val(),$('#input_product_id option:selected').text(), $('#input_product_price').val(), $('#input_product_total').val(), $('#input_product_qty').val(), $('#input_product_uom').val(), $('#input_product_vat_total').val(),$('#input_product_disc').val());
                }
              });
              

          });


      });

      
      var productList = [];
      var orderList = [];
      var order_total = 0;
      var _vat_total = 0;
      var sub_total = 0;
      var disc_total = 0;

        
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
          }else if(order_total<=0&&disc_total<=0){
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
                supplier_name : $('#supplier_id option:selected').text(),
                branch_name : $('#branch_id option:selected').text(),
                remark : $('#remark').val(),
                total_order : order_total,
                total_vat : _vat_total,
                total_discount : disc_total,
                dated : $('#doc_dated').val(),
              }
            );
            const res = axios.post("{{ route('purchaseorders.store') }}", json, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.href = "{{ route('purchaseorders.index') }}"; 
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

        var table = $('#order_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-lg"></i></div></a>'+
            '  <a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-yellow ml-1"><div class="fa-1x"><i class="fas fa-circle-minus fa-lg"></i></div></a>'+
            '  <a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-lg"></i></div></a>'
          }],
          columns: [
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price' },
            { data: 'qty' },
            { data: 'disc' },
            { data: 'total' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, total, qty, uom, vat_total,disc){
          table.clear().draw(false);
          order_total = 0;
          disc_total = 0;
          _vat_total = 0;
          sub_total = 0;
          var total_vat = parseFloat(total) * (parseFloat(vat_total)/100); 
          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "qty"       : qty,
                "price"     : price,
                "total"     : total,
                "total_vat"     : total_vat,
                "disc"      : disc,
                "vat_total"     : vat_total,
                "uom" : uom
          }

          var isExist = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if(id==obj["id"]){
              isExist = 1;
              orderList[i]["total"] = ((parseInt(orderList[i]["qty"])+parseInt(qty))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])+disc); 
              orderList[i]["total_vat"] = (((parseInt(orderList[i]["qty"])+parseInt(qty))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])+disc))*(1+(parseFloat(vat_total)/100)); 
              orderList[i]["qty"] = parseInt(orderList[i]["qty"])+parseInt(qty);
              orderList[i]["disc"] = parseFloat(orderList[i]["disc"])+parseFloat(disc);
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
                    "price"       : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "qty"       : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "disc"       : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "total"       : currency(obj["total"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "action"    : "",
              }).draw(false);            
              disc_total = disc_total + (parseFloat(orderList[i]["disc"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["disc"]));

          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        }

        $('#order_table tbody').on('click', 'a', function () {
            var data = table.row($(this).parents('tr')).data();
            order_total = 0;
            _vat_total = 0;
            sub_total = 0;
            disc_total = 0;
            table.clear().draw(false);
            
            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              var value = obj["id"];

              if($(this).attr("id")=="add_row"){
                if(data["id"]==obj["id"]){
                  orderList[i]["total"] = ((parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])); 
                  orderList[i]["total_vat"] = (((parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])))*(1+(parseFloat(orderList[i]["vat_total"])/100)); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])>1){
                  orderList[i]["total"] = ((parseInt(orderList[i]["qty"])-1)*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])); 
                  orderList[i]["total_vat"] = (((parseInt(orderList[i]["qty"])-1)*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])))*(1+(parseFloat(orderList[i]["vat_total"])/100)); 
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

            }

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              table.row.add( {
                    "id"        : obj["id"],
                    "abbr"      : obj["abbr"],
                    "uom"       : obj["uom"],
                    "price"       : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "qty"       : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "disc"       : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "total"       : currency(obj["total"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "action"    : "",
                }).draw(false);
                disc_total = disc_total + (parseFloat(orderList[i]["disc"]));
                sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])));
                _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])))*(parseFloat(orderList[i]["vat_total"])/100));
                order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["disc"]));

            }

            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        });
 
    </script>
@endpush
