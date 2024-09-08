@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Receive Order')

@section('content')
<form method="POST" action="{{ route('receiveorders.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_receive') #{{ $purchases[0]->purchase_no }}</h4></div>
      <div class="">
        <a href="{{ route('receiveorders.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
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
                value="{{ old('doc_dated') }}" required/>
                @if ($errors->has('doc_dated'))
                          <span class="text-danger text-left">{{ $errors->first('doc_dated') }}</span>
                      @endif
              </div>


              <label class="form-label col-form-label col-md-1 d-none">PO</label>
              <div class="col-md-2 d-none">
                <input type="hidden" id="po_no_ref" name="po_no_ref" value="{{ $purchases[0]->purchase_no }}">
                <input type="hidden" id="currency" name="currency" value="IDR">
                <input type="hidden" id="kurs" name="kurs" value="1">
                <select class="form-control d-none" 
                    name="ref_no" id="ref_no" required>
                    <option value="">Select Purchase Order</option>
                    @foreach($purchases as $purchase)
                      <option value="{{ $purchase->purchase_no }}" @if($purchases[0]->purchase_no==$purchase->purchase_no) {{ "selected" }}@endif>{{ $purchase->purchase_no }} </option>
                    @endforeach
                </select>
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
                        <option value="{{ $supplier->id }}">{{ $supplier->id }} - {{ $supplier->name }} </option>
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

            <div class="panel-heading bg-teal-600 text-white mb-1"><strong>Receive List</strong></div>
            <div class="row mb-3 d-none">
              <div class="col-md-2">
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

              <div class="col-md-1">
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

              <div class="col-md-2">
                <label class="form-label col-form-label">Expired @lang('general.lbl_dated_mmddYYYY')</label>
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
                <label class="form-label col-form-label">@lang('general.lbl_discountrp')</label>
                <input type="text" 
                name="input_product_disc"
                id="input_product_disc"
                class="form-control" 
                value="{{ old('input_product_disc') }}" required/>
                <input type="hidden" 
                name="input_product_vat_total"
                id="input_product_vat_total"
                class="form-control" 
                value="{{ old('input_product_vat_total') }}" required disabled/>
              </div>

              <div class="col-md-1">
                <label class="form-label col-form-label">Total</label>
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
            

            <table class="table table-striped mt-1" id="data_table">
              <thead>
              <tr>
                  <th>@lang('general.product')</th>
                  <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                  <th scope="col" width="10%">@lang('general.lbl_price')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="10%">Disc</th>
                  <th scope="col" width="10%">Expired</th>
                  <th scope="col" width="10%">Total</th>
                  <th scope="col" width="20%">@lang('general.lbl_action')</th> 
              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            
            <div class="col-md-12">
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

          <div class="col-md-12">
          </div>

          <div class="modal fade" id="modal-exp" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">Expired Date</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <label class="form-label col-form-label col-md-12">Expired @lang('general.lbl_dated')   </label>
                  <input type="hidden" id="product_id_selected" value="">
                  <div class="col-md-12">
                    <input id="input_expired_at_list" class="form-control" name="input_expired_at_list" type="text">
                  </div>
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_apply_exp">@lang('general.lbl_apply')</button>
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

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          const formattedNextYear = dd + '-' + mm + '-' + yyyy1;
        $(function () {
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
            
          
          $('#doc_dated').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#doc_dated').val(formattedToday);
          
          $('#input_expired_at').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#input_expired_at').val(formattedNextYear);


          $('#input_expired_at_list').datepicker({
              dateFormat : 'dd-mm-yy',
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
                        $('#input_product_total').val(v.price);
                        $('#input_product_disc').val(0);
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
                  addProduct($('#input_product_id').val(),$('#input_product_id option:selected').text(), $('#input_product_price').val(), $('#input_product_total').val(), $('#input_product_qty').val(), $('#input_product_uom').val(),$('#input_expired_at').val(),'', $('#input_product_vat_total').val(),$('#input_product_disc').val());
                }
              });
              

          });


      });

      var url = "{{ route('purchaseorders.getdocdata','XX') }}";
      var lastvalurl = "XX";
      orderList = [];
      url = url.replace(lastvalurl, $('#po_no_ref').val())
      lastvalurl = $('#po_no_ref').val();
      const res = axios.get(url, {
        headers: {
            'Content-Type': 'application/json'
          }
      }).then(resp => {
            table.clear().draw(false);
            order_total = 0;
            disc_total = 0;
            _vat_total = 0;
            sub_total = 0;
            //var total_vat = parseFloat(total) * (parseFloat(vat_total)/100); 

            for(var i=0;i<resp.data.length;i++){
                var product = {
                      "id"        : resp.data[i]["product_id"],
                      "abbr"      : resp.data[i]["remark"],
                      "uom"      : resp.data[i]["uom"],
                      "price"     : resp.data[i]["price"],
                      "disc"  : resp.data[i]["discount"],
                      "qty"       : resp.data[i]["qty"],
                      "exp"       : formattedNextYear,
                      "total"     : resp.data[i]["subtotal"],
                      "total_vat"     : resp.data[i]["total_vat"],
                      "vat_total"     : resp.data[i]["vat"],
                }
                $('#lbl_total').text("Total ("+resp.data[i]["currency"]+")");
                $('#currency').val(resp.data[i]["currency"]);
                $('#kurs').val(resp.data[i]["kurs"]);


                orderList.push(product);
            }

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              var value = obj["abbr"];

              
              table.row.add( {
                "id"         : obj["id"],
                  "abbr"      : obj["abbr"],
                  "uom"       : obj["uom"],
                  "price"     : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                  "qty"       : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                  "disc"       : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                  "exp"       : formattedNextYear,
                  "total"     : currency(obj["total"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
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

          $('#supplier_id').val(resp.data[0]["supplier_id"]);
          $('#remark').val(resp.data[0]["d_remark"]);
          $('#branch_id').val(resp.data[0]["branch_id"]);
          $('#branch_id').trigger('change');

      });

      console.log(url);
          $('#ref_no').change(function(){
              orderList = [];
              if($(this).val()==""){
                      table.clear().draw(false);
                      order_total = 0;
                      $('#order_charge').text(" 0");
                      $('#result-total').text(" 0");

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
                      disc_total = 0;
                      _vat_total = 0;
                      sub_total = 0;
                      //var total_vat = parseFloat(total) * (parseFloat(vat_total)/100); 

                      for(var i=0;i<resp.data.length;i++){
                          var product = {
                                "id"        : resp.data[i]["product_id"],
                                "abbr"      : resp.data[i]["remark"],
                                "uom"      : resp.data[i]["uom"],
                                "price"     : resp.data[i]["price"],
                                "disc"  : resp.data[i]["discount"],
                                "qty"       : resp.data[i]["qty"],
                                "exp"       : formattedNextYear,
                                "total"     : resp.data[i]["subtotal"],
                                "total_vat"     : resp.data[i]["total_vat"],
                                "vat_total"     : resp.data[i]["vat"],
                          }

                          orderList.push(product);
                      }

                      for (var i = 0; i < orderList.length; i++){
                        var obj = orderList[i];
                        var value = obj["abbr"];
                        
                        table.row.add( {
                          "id"         : obj["id"],
                            "abbr"      : obj["abbr"],
                            "uom"       : obj["uom"],
                            "price"     : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                            "qty"       : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                            "disc"       : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                            "exp"       : formattedNextYear,
                            "total"     : currency(obj["total"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
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
        disc_total = 0;
        _vat_total = 0;
        sub_total = 0;
          
        for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if($('#product_id_selected').val()==obj["id"]){
              orderList[i]["exp"] = $('#input_expired_at_list').val();
            }
          }

          for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              table.row.add( {
                "id"         : obj["id"],
                "abbr"      : obj["abbr"],
                "uom"       : obj["uom"],
                "price"     : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                "qty"       : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                "disc"       : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                "exp"       : formattedNextYear,
                "total"     : currency(obj["total"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
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
                branch_name : $('#branch_id option:selected').text(),
                product : orderList,
                supplier_id : $('#supplier_id').val(),
                supplier_name : $('#supplier_id option:selected').text(),
                remark : $('#remark').val(),
                ref_no : $('#ref_no').val(),
                kurs : $('#kurs').val(),
                currency : $('#currency').val(),
                total_order : order_total,
                dated : $('#doc_dated').val(),
                total_vat : _vat_total,
                total_discount : disc_total,
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

        var table = $('#data_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-sm btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-lg"></i></div></a>'+
            '  <a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-sm btn-yellow ml-1"><div class="fa-1x"><i class="fas fa-circle-minus fa-lg"></i></div></a>'+
            '  <a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-sm btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-lg"></i></div></a>'+
            '  <a href="#" href="#modal-exp" data-bs-toggle="modal" data-bs-target="#modal-exp" id="exp_row" class="btn btn-sm btn-indigo"><div class="fa-1x"><i class="fas fa-calendar-days fa-fw"></i></div></a>'
          }],
          columns: [
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price' },
            { data: 'qty' },
            { data: 'disc' },
            { data: 'exp' },
            { data: 'total' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, total, qty, uom,exp, bno, vat_total,disc){
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
                "exp"       : exp,
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
            if(id==obj["id"]&&exp==obj["exp"]){
              isExist = 1;
              orderList[i]["total"] = (parseInt(orderList[i]["qty"])+parseInt(qty))*parseFloat(orderList[i]["price"]); 
              orderList[i]["qty"] = parseInt(orderList[i]["qty"])+parseInt(qty);
              orderList[i]["total_vat"] = (((parseInt(orderList[i]["qty"])+parseInt(qty))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])+disc))*(1+(parseFloat(vat_total)/100)); 
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
                   "id"         : obj["id"],
                    "abbr"      : obj["abbr"],
                    "uom"       : obj["uom"],
                    "price"     : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "qty"       : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "disc"       : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "exp"       : obj["exp"],
                    "total"     : currency(obj["total"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
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

        $('#data_table tbody').on('click', 'a', function () {
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
                  orderList[i]["total"] = (parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
                  orderList[i]["total_vat"] = (((parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])))*(1+(parseFloat(orderList[i]["vat_total"])/100)); 
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

              if($(this).attr("id")=="exp_row"){
                if(data["id"]==obj["id"]){
                  $('#product_id_selected').val(data["id"]);
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
                      "price"      : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                      "qty"       : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                      "disc"       : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                      "exp"       : obj["exp"],
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
