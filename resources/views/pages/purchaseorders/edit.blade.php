@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Purchase Order')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Purchase Order {{ $purchase->purchase_no }}</h4></div>
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
                <input id="purchase_no" name="purchase_no" type="hidden" value="{{ $purchase->purchase_no }}">
                <input type="text" 
                name="doc_dated"
                id="doc_dated"
                class="form-control" 
                value="{{ substr(explode(" ",$purchase->dated)[0],8,2) }}-{{ substr(explode(" ",$purchase->dated)[0],5,2) }}-{{ substr(explode(" ",$purchase->dated)[0],0,4) }}"
                required/>
                @if ($errors->has('doc_dated'))
                          <span class="text-danger text-left">{{ $errors->first('doc_dated') }}</span>
                      @endif
              </div>

              <label class="form-label col-form-label col-md-1">Shipto</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="branch_id" id="branch_id" required>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"  {{ $purchase->branch_id == $branch->id ? 'selected' : '' }}>{{ $branch->remark }} </option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">Supplier</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="supplier_id" id="supplier_id" required>
                    <option value="">Select Suppliers</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}" {{ $purchase->supplier_id == $supplier->id ? 'selected' : '' }} >{{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>

                <label class="form-label col-form-label col-md-1">@lang('general.lbl_remark')</label>
                <div class="col-md-2">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ $purchase->remark }}"/>
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
                <th>@lang('general.lbl_product_name')</th> 
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
            
            
            <div class="row mb-3">
              <div class="col-md-6">
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-3">@lang('sidebar.MataUang')</label>
                  <div class="col-md-2">
                    <input type="hidden" name="curr_def" id="curr_def" value="{{ $branchs[0]->currency }}">
                    <select class="form-select" name="currency" id="currency">
                        @php
                        $selected = "";
                        $curr = $purchase->currency;

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
                  <label class="form-label col-form-label col-md-3">@lang('general.lbl_remark')</label>
                  <div class="col-md-7">
                    <input type="text" 
                    name="remark"
                    id="remark"
                    class="form-control" 
                    value="{{ $purchase->remark }}"/>
                    </div>
                </div>
              </div>


              <div class="col-md-6">
                  <div class="col-md-12">
                    <div class="col-auto text-end">
                      <label class="col-md-4">Sub Total</label>
                      <label class="col-md-4" id="sub-total"> {{ number_format(($purchase->total-$purchase->total_vat),0,',','.') }}</label>
                    </div>
                  </div>
                  <div class="col-md-12">
                    <div class="col-auto text-end">
                      <label class="col-md-4">@lang('general.lbl_tax')</label>
                      <label class="col-md-4" id="vat-total">{{ number_format($purchase->total_vat,0,',','.') }}</label>
                    </div>
                  </div>
                  <div class="col-md-12">
                    <div class="col-auto text-end">
                      <label id="lbl_total"  class="col-md-4 h3">Total ({{ $purchase->currency }})</label>
                      <label class="col-md-4  h3" name="result-total" id="result-total">{{ number_format($purchase->total,0,',','.') }}</label>
                    </div>
                  </div>
                </div>
              </div>

          <div class="col-md-12">
          </div>
        </div>
    </div>
  </div>
@endsection

@push('scripts')
    <script type="text/javascript">
      var productList = [];
      var orderList = [];
      var order_total = 0;
         
      $(function () {
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = dd + '-' + mm + '-' + yyyy;

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
          
          $('#doc_dated').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });

          var url = "{{ route('purchaseorders.getproduct') }}";
          var lastvalurl = "XX";
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
                        console.log($('#input_product_vat_total').val());
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
                  //addProduct($('#input_product_id').val(),$('#input_product_id option:selected').text(), $('#input_product_price').val(), $('#input_product_total').val(), $('#input_product_qty').val(), $('#input_product_uom').val(),$('#input_product_id option:selected').text());
                }
              });
              

          });


          var url = "{{ route('purchaseorders.getdocdata',$purchase->purchase_no) }}";
          const resGetPO = axios.get(url, {
            headers: {
                'Content-Type': 'application/json'
              }
          }).then(resp => {
                for(var i=0;i<resp.data.length;i++){
                  var product = {
                          "id"          : resp.data[i]["product_id"],
                          "abbr"        : resp.data[i]["remark"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"         : resp.data[i]["uom"],
                          "qty"         : resp.data[i]["qty"],
                          "disc"         : resp.data[i]["discount"],
                          "total"       : resp.data[i]["subtotal"],
                          "total_vat"       : resp.data[i]["subtotal_vat"],
                          "vat_total"       : resp.data[i]["vat"],
                          "price"       : resp.data[i]["price"]
                    }

                    orderList.push(product);
                }

                for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];

                  table.row.add( {
                   "id"           : obj["id"],
                    "abbr"      : obj["remark"],
                    "uom"         : obj["uom"],
                    "price"       : obj["price"],
                    "qty"         : obj["qty"],
                    "disc"         : obj["disc"],
                    "total"       : obj["total"],
                  }).draw(false);
                  order_total = order_total + (parseFloat(orderList[i]["total_vat"]));
                }

                $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());

          });
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
            var _vat_total = 0;
            var disc_total = 0;
              const json = JSON.stringify({
                branch_id : $('#branch_id').val(),
                product : orderList,
                supplier_id : $('#supplier_id').val(),
                supplier_name : $('#supplier_id option:selected').text(),
                branch_name : $('#branch_id option:selected').text(),
                remark : $('#remark').val(),
                total_order : order_total,
                dated : $('#doc_dated').val(),
                purchase_no : $('#purchase_no').val(),
                total_vat : _vat_total,
                total_discount : disc_total
              }
            );
            const res = axios.patch("{{ route('purchaseorders.update',$purchase->id) }}", json, {
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
            '  <a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-sm btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-lg"></i></div></a>'+
            '  <a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-sm btn-yellow ml-1"><div class="fa-1x"><i class="fas fa-circle-minus fa-lg"></i></div></a>'+
            '  <a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-sm btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-lg"></i></div></a>'
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

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());

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

            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
        });

    </script>
@endpush
