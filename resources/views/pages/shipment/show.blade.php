@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Shipment')

@section('content')
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Pengiriman Barang #{{ $doc_data->doc_no }}</h4></div>
      <div class="">
        <a href="{{ route('shipment.print', $doc_data->id) }}" target="_blank" class="btn btn-warning"><i class="fas fa-print"></i> @lang('general.lbl_print')</a>
        <a href="{{ route('shipment.index') }}" class="btn btn-default">@lang('general.lbl_back')</a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

      <div class="row mb-1">
          <div class="col-md-3">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated')   </label>
              <div class="col-md-8">
                <input type="hidden" 
                name="doc_no"
                id="doc_no"
                class="form-control" 
                value="{{ $doc_data->doc_no }}"/>

                <input type="text" readonly
                  name="dated"
                  id="dated"
                  class="form-control" 
                  value="{{ substr(explode(" ",$doc_data->dated)[0],8,2) }}-{{ substr(explode(" ",$doc_data->dated)[0],5,2) }}-{{ substr(explode(" ",$doc_data->dated)[0],0,4) }}" required/>
                  @if ($errors->has('dated'))
                            <span class="text-danger text-left">{{ $errors->first('dated') }}</span>
                        @endif
              </div>

              <label class="form-label col-form-label col-md-4 mt-1">Via</label>
              <div class="col-md-8 mt-1">
                <select class="form-control" name="shipping_method" id="shipping_method" disabled>
                  <option value=""></option>
                  <option value="Internal" {{ ("Internal" == $doc_data->shipping_method) ? 'selected': ''}}>Internal</option>
                  <option value="Kurir"  {{ ("Kurir" == $doc_data->shipping_method) ? 'selected': ''}}>Kurir</option>
                </select>
              </div>
              <label class="form-label col-form-label col-md-5 mt-1">Resi/ No Mobil</label>
              <div class="col-md-7 mt-1">
                <input type="text" class="form-control" id="awb" name="awb" value="{{ $doc_data->awb }}" readonly>
              </div>
              
            </div>

          


          </div>

          <div class="col-md-9">
            <div class="row mb-1">

              <label class="form-label col-form-label col-md-2  d-none">@lang('general.lbl_spk')</label>
              <div class="col-md-3 d-none">
                <input type="text" class="form-control" id="ref_no" name="ref_no" value="{{ $doc_data->ref_no }}" id="scheduled" disabled>
              </div>

              <label class="form-label col-form-label col-md-1">@lang('general.lbl_customer')</label>
              <div class="col-md-4">
                <select class="form-control" 
                    name="customer_id" id="customer_id" disabled>
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}" {{ ($customer->id == $doc_data->customer_id) 
                          ? 'selected'
                          : ''}}>{{ $customer->id }} - {{ $customer->name }} ({{ $customer->remark }})</option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-2">@lang('general.lbl_remark')</label>
              <div class="col-md-5">
                <input type="text" 
                name="remark"
                id="remark"
                class="form-control"  readonly
                value="{{ $doc_data->remark }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Nama Kurir</label>
              <div class="col-md-3 mt-1">
                  <input type="text" 
                  name="shipper_name"
                  id="shipper_name"  readonly
                  class="form-control" 
                  value="{{ $doc_data->shipper_name }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Alamat Tujuan</label>
              <div class="col-md-5 mt-1">
                  <input type="text" 
                  name="address"
                  id="address"  readonly
                  class="form-control" 
                  value="{{ $doc_data->address }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Tgl Kirim</label>
              <div class="col-md-2 mt-1">
                  <input type="date" 
                  name="etd"
                  id="etd" readonly
                  class="form-control" 
                  value="{{ $doc_data->etd }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Est. Tgl Terima</label>
              <div class="col-md-2 mt-1">
                  <input type="date" 
                  name="eta"
                  id="eta" readonly
                  class="form-control" 
                  value="{{ $doc_data->eta }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Status</label>
              <div class="col-md-2 mt-1">
                <select class="form-control" name="status" id="status" disabled>
                  <option value="Pending" {{ $doc_data->eta=="Pending"?"selected":"" }}>Pending</option>
                  <option value="Terkirim" {{ $doc_data->eta=="Terkirim"?"selected":"" }}>Terkirim</option>
                </select>
              </div>
            
            </div>
          </div>
        </div>



        <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
        <br>
      
         <table class="table table-striped" id="order_product_table">
          <thead>
            <tr>
              <th scope="col" width="5%">#</th>
              <th scope="col" width="15%">PO No</th>
              <th scope="col">@lang('general.product')</th>
              <th scope="col" width="5%">@lang('general.lbl_qty') Order</th>
              <th scope="col" width="5%">@lang('general.lbl_qty') Packing</th>
              <th scope="col" width="5%">@lang('general.lbl_uom')</th>
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table> 
        
        
        <div class="row mb-3">
          <div class="col-md-6">
          </div>

          <div class="col-md-6">
            <div class="col-md-12  d-none">
              <div class="col-auto text-end">
                <label class="col-md-2"><h2>Sub Total </h2></label>
                <label class="col-md-8" id="sub-total"> <h3>0</h3></label>
              </div>
            </div>
            <div class="col-md-12 d-none">
              <div class="col-auto text-end">
                <label class="col-md-2"><h2>@lang('general.lbl_tax') </h2></label>
                <label class="col-md-8" id="vat-total"> <h3>0</h3></label>
              </div>
            </div>
            <div class="col-md-12 d-none">
              <div class="col-auto text-end">
                <label class="col-md-2"><h1>Total </h1></label>
                <label class="col-md-8 display-5" id="result-total"> <h1>0</h1></label>
              </div>
            </div>
          </div>
        </div>

    </div>
  </div>
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

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          $('#doc_date').datepicker({
              dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });
      });

      var productList = [];
      var orderList = [];
      var order_total = 0;
      var disc_total = 0;
      var _vat_total = 0;
      var sub_total = 0;
      
        
        var table_product = $('#order_product_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: ''
          }],
          columns: [
            { data: 'no' },
            { data: 'po_no' },
            { data: 'abbr' },
            { data: 'qty' },
            { data: 'qty_pack' },
            { data: 'uom' },
        ],
        });

        function addProduct(id,abbr, qty,uom,po_no){
          table_product.clear().draw(false);
          entry_time = Date.now();

          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "uom"      : uom,
                "qty"       : qty,
                "uom" : uom,
                "po_no" : "-",
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
              orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
            }
          }

          if(isExist==0){
            orderList.push(product);
          }

          
          orderList.sort(function(a, b) {
              return parseFloat(a.entry_time) - parseFloat(b.entry_time);
          });


          counterno = 0;

          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];
            counterno = counterno + 1;
                table_product.row.add( {
                    "no" : counterno,
                    "id"        : obj["id"],
                     "po_no"      : obj["po_no"],
                     "uom"       : obj["uom"],
                      "abbr"      : obj["abbr"],
                      "qty"       : obj["qty"],
                      "action"    : "",
                }).draw(false);
              
          }

          $("html, body").animate({ scrollTop: $(document).height()-$(window).height() });


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
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])>1){
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

            orderList.sort(function(a, b) {
                return parseFloat(a.entry_time) - parseFloat(b.entry_time);
            });

            counterno = 0;
            counterno_service = 0;

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              counterno = counterno + 1;
              table_product.row.add( {
                    "no" : counterno,
                    "id"        : obj["id"],
                     "po_no"      : obj["po_no"],
                     "uom"       : obj["uom"],
                      "abbr"      : obj["abbr"],
                      "qty"       : obj["qty"],
                      "action"    : "",
                }).draw(false);


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
                  if(obj["type"]=="Services"){
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
                    $('#input_product_qty').val(),
                    $('#input_product_uom').val(),"-"
                  )
                }
              });
              

          });

            //Get Invoice 
            const resInvoice = axios.get("{{ route('shipment.getdoc_data',$doc_data->doc_no) }}", {
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
                            "no"        : i+1,
                            "po_no"        : resp.data[i]["po_no"],
                            "ref_no"        : resp.data[i]["ref_no"],
                            "id"        : resp.data[i]["product_id"],
                            "uom"        : resp.data[i]["uom"],
                            "qty_pack"        : resp.data[i]["qty_pack"],
                            "abbr"      : resp.data[i]["product_name"],
                            "qty"       : resp.data[i]["qty"],
                      }

                      orderList.push(product);
                  }

                  counterno = 0;
                  counterno_service = 0;  
                  orderList.sort(function(a, b) {
                      return parseFloat(a.seq) - parseFloat(b.seq);
                  });

                  for (var i = 0; i < orderList.length; i++){
                    counterno = counterno+1;
                    var obj = orderList[i];
                    var value = obj["abbr"];
                    table_product.row.add( {
                          "no"        : counterno,
                          "po_no"        : obj["po_no"],
                          "ref_no"        : obj["ref_no"],
                          "id"        : obj["id"],
                          "uom"        : obj["uom"],
                          "qty_pack"       : obj["qty_pack"],
                          "abbr"      : obj["abbr"],
                          "qty"       : obj["qty"],
                          "action"    : "",
                    }).draw(false);

                  
                  }

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

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              table_product.row.add( {
                    "no"        : i+1,
                    "id"        : obj["id"],
                    "uom"        : obj["uom"],
                    "po_no"        : obj["po_no"],
                    "abbr"      : obj["abbr"],
                    "qty"       : obj["qty"],
                    "action"    : "",
              }).draw(false);


            }

            $("html, body").animate({ scrollTop: $(document).height()-$(window).height() });
            
        });


 
    </script>
@endpush
