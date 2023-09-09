@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Shipment')

@section('content')
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Pengiriman Pesanan #{{ $doc_data->doc_no }} </h4></div>
      <div class="">
        <a href="{{ route('shipment.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
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

                <input type="text" 
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
                <select class="form-control" name="shipping_method" id="shipping_method">
                  <option value=""></option>
                  <option value="Internal" {{ ("Internal" == $doc_data->shipping_method) ? 'selected': ''}}>Internal</option>
                  <option value="Kurir"  {{ ("Kurir" == $doc_data->shipping_method) ? 'selected': ''}}>Kurir</option>
                </select>
              </div>
              <label class="form-label col-form-label col-md-5 mt-1">Resi/ No Mobil</label>
              <div class="col-md-7 mt-1">
                <input type="text" class="form-control" id="awb" name="awb" value="{{ $doc_data->awb }}">
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
                    name="customer_id" id="customer_id" required>
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
                class="form-control" 
                value="{{ $doc_data->remark }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Nama Kurir</label>
              <div class="col-md-3 mt-1">
                  <input type="text" 
                  name="shipper_name"
                  id="shipper_name"
                  class="form-control" 
                  value="{{ $doc_data->shipper_name }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Alamat Tujuan</label>
              <div class="col-md-5 mt-1">
                  <input type="text" 
                  name="address"
                  id="address"
                  class="form-control" 
                  value="{{ $doc_data->address }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Tgl Kirim</label>
              <div class="col-md-2 mt-1">
                  <input type="date" 
                  name="etd"
                  id="etd"
                  class="form-control" 
                  value="{{ $doc_data->etd }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Est. Tgl Terima</label>
              <div class="col-md-2 mt-1">
                  <input type="date" 
                  name="eta"
                  id="eta"
                  class="form-control" 
                  value="{{ $doc_data->eta }}"/>
              </div>

              <label class="form-label col-form-label col-md-2 mt-1">Status</label>
              <div class="col-md-2 mt-1">
                <select class="form-control" name="status" id="status">
                  <option value="Pending" {{ $doc_data->eta=="Pending"?"selected":"" }}>Pending</option>
                  <option value="Terkirim" {{ $doc_data->eta=="Terkirim"?"selected":"" }}>Terkirim</option>
                </select>
              </div>
             
            </div>
          </div>
        </div>



        <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
        <br>
        

        <div class="row mb-1">
          <div class="col-md-3">
            <label class="form-label col-form-label">@lang('general.product')</label>
            <select class="form-control" 
                  name="input_product_id" id="input_product_id" required>
                  <option value="">@lang('general.lbl_productselect')</option>
              </select>
          </div>


          <div class="col-md-2">
            <label class="form-label col-form-label">@lang('general.lbl_uom')</label>
            <input type="text" 
            name="input_product_uom"
            id="input_product_uom"
            class="form-control" 
            value="{{ old('input_product_uom') }}" required disabled/>
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
            <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
            <a href="#" id="input_product_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>@lang('general.lbl_add_product')</div></a>
          </div>

          <div class="col-md-2">
            <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
            <button class="btn btn-primary btn-sm" href="#modal-filter" data-bs-toggle="modal" data-bs-target="#modal-filter">@lang('general.lbl_add') dari PO</button>
          </div>

          <div class="col-md-2">
            <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
            <button class="btn btn-outline-warning btn-sm " id="btn-picking" href="#modal-picking" data-bs-toggle="modal" data-bs-target="#modal-picking">Apply Packing</button>
          </div>

        </div>

        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
              <h5 class="modal-title" id="staticBackdropLabel">Tambah PO Internal</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <label class="form-label col-form-label col-md-8" id="product_id_selected_lbl">Silahkan pilih PO internal </label>
                <input type="hidden" id="product_id_selected" value="">
                <div class="col-md-8">
                  <select class="form-control" 
                      name="po_list" id="po_list" required>
                      <option value=""> Pilih PO Internal </option>
                  </select>
                </div>
              </div>
              <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
              <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_add_po">@lang('general.lbl_apply')</button>
              </div>
          </div>
          </div>
        </div>

        <div class="modal fade" id="modal-picking" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
              <h5 class="modal-title" id="staticBackdropLabel">Apply Picking</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                <label class="form-label col-form-label col-md-8" id="product_id_selected_lbl">Silahkan pilih Dokumen Picking </label>
                <input type="hidden" id="product_id_selected" value="">
                <div class="col-md-8">
                  <select class="form-control" 
                      name="picking_list" id="picking_list" required>
                      <option value=""> Pilih No Picking </option>
                  </select>
                </div>
              </div>
              <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
              <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_add_picking">@lang('general.lbl_apply')</button>
              </div>
          </div>
          </div>
        </div>

         <table class="table table-striped" id="order_product_table">
          <thead>
          <tr>
              <th scope="col" width="5%">#</th>
              <th scope="col" width="15%">PO No</th>
              <th scope="col">@lang('general.product')</th>
              <th scope="col" width="5%">@lang('general.lbl_qty') Order</th>
              <th scope="col" width="5%">@lang('general.lbl_qty') Packing</th>
              <th scope="col" width="5%">@lang('general.lbl_uom')</th>
              <th scope="col" width="15%" class="nex">@lang('general.lbl_action')</th> 
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
    let list_po,list_picking;
      $(function () {
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          $('#customer_id').select2();

          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          $('#dated').datepicker({
              dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });

          var xurl = "{{ route('purchaseordersinternal.getdocdatapicked','16') }}";
          var xlastvalurl = "16";
          xurl = xurl.replace(xlastvalurl, $('#customer_id').find(':selected').val())
          xlastvalurl = $(this).val();
          const res = axios.get(xurl, {
            headers: {
                'Content-Type': 'application/json'
              }
          }).then(resp => {
              list_po = resp.data;


              $('#po_list').find('option').remove();

              for (let index = 0; index < list_po.length; index++) {
                const element = list_po[index];
                $('#po_list').append($('<option>', {
                    value: element.purchase_no,
                    text: element.purchase_no+' ('+element.dated+')'
                }));
              }
              
          });

          $('#customer_id').on('change',function(){
            // Begin Call API
            xurl = xurl.replace(xlastvalurl, $('#customer_id').find(':selected').val())
            xlastvalurl = $(this).val();
            const res = axios.get(xurl, {
              headers: {
                  'Content-Type': 'application/json'
                }
            }).then(resp => {
                list_po = resp.data;

                $('#po_list').find('option').remove();

                for (let index = 0; index < list_po.length; index++) {
                  const element = list_po[index];
                  $('#po_list').append($('<option>', {
                      value: element.purchase_no,
                      text: element.purchase_no+' ('+element.dated+')'
                  }));
                }
                
            });
            // End Call API
          });

          var xurlp = "{{ route('packing.getdocdatapackedlist','16') }}";
          var xlastvalurlp = "16";
          xurlp = xurlp.replace(xlastvalurlp, $('#customer_id').find(':selected').val())
            xlastvalurlp = $(this).val();
            const resc = axios.get(xurlp, {
              headers: {
                  'Content-Type': 'application/json'
                }
            }).then(resp => {
                list_picking = resp.data;

                $('#picking_list').find('option').remove();

                for (let index = 0; index < list_picking.length; index++) {
                  const element = list_picking[index];
                  $('#picking_list').append($('<option>', {
                      value: element.doc_no,
                      text: element.doc_no+' ('+element.dated+')'
                  }));
                }
                
            });

          $('#customer_id').on('change',function(){
            // Begin Call API
            xurlp = xurlp.replace(xlastvalurlp, $('#customer_id').find(':selected').val())
            xlastvalurlp = $(this).val();
            const res = axios.get(xurlp, {
              headers: {
                  'Content-Type': 'application/json'
                }
            }).then(resp => {
                list_picking = resp.data;

                $('#picking_list').find('option').remove();

                for (let index = 0; index < list_picking.length; index++) {
                  const element = list_picking[index];
                  $('#picking_list').append($('<option>', {
                      value: element.doc_no,
                      text: element.doc_no+' ('+element.dated+')'
                  }));
                }
                
            });
            // End Call API
          });
          
      });

      var productList = [];
      var orderList = [];
      var order_total = 0;
      var disc_total = 0;
      var _vat_total = 0;
      var sub_total = 0;

      $('#btn_add_po').on('click',function(){
          var url_ = "{{ route('purchaseordersinternal.getdocdata','16') }}";
            url_ = url_.replace('16', $('#po_list').find(':selected').val())
            lastvalurl_ = $(this).val();
            const res = axios.get(url_, {
              headers: {
                  'Content-Type': 'application/json'
                }
            }).then(resp => {
                console.log(resp.data);
                for (let index = 0; index < resp.data.length; index++) {
                  const element = resp.data[index];
                  addProduct(element.product_id,element.remark, element.qty, element.uom,element.purchase_no);
                }

                if(resp.data.length>0){
                  $('#btn-picking').removeClass("d-none");
                }else{
                  $('#btn-picking').addClass("d-none");
                }
                
            });
      });

      $('#btn_add_picking').on('click',function(){
          var url_ = "{{ route('packing.getdocdatapacked','16') }}";
            url_ = url_.replace('16', $('#picking_list').find(':selected').val())
            lastvalurl_ = $(this).val();
            const res = axios.get(url_, {
              headers: {
                  'Content-Type': 'application/json'
                }
            }).then(resp => {
                console.log(resp.data);
                table_product.clear().draw(false);

                for (var i = 0; i < orderList.length; i++){
                    orderList[i]["qty_pack"] = 0;
                    orderList[i]["ref_no"] = "-";
                }

                for (let index = 0; index < resp.data.length; index++) {
                  const element = resp.data[index];
                  console.log(element);

                    for (var i = 0; i < orderList.length; i++){
                      var obj = orderList[i];
                      if(element.product_id==obj["id"]){
                        orderList[i]["qty_pack"] = parseInt(element.qty);
                        orderList[i]["ref_no"] = element.doc_no;
                      }
                    }


                }  

                counterno = 0;
                for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];
                  var value = obj["abbr"];

                  counterno = counterno + 1;
                  table_product.row.add( {
                        "no" : counterno,
                        "id"        : obj["id"],
                        "abbr"      : obj["abbr"],
                        "uom"       : obj["uom"],
                        "qty_pack"       : obj["qty_pack"],
                        "po_no"      : obj["po_no"],
                        "qty"       : obj["qty"],
                        "action"    : "",
                  }).draw(false);
                }  
            });
      });
        
        $('#save-btn').on('click',function(){
          if($('#dated').val()==''){
            $('#dated').focus();
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
          }else if(orderList.length<=0){
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
                  dated : $('#dated').val(),
                  doc_no : $('#doc_no').val(),
                  remark : $('#remark').val(),
                  product : orderList,
                  customer_id : $('#customer_id').val(),
                  remark : $('#remark').val(),
                  shipping_method : $('#shipping_method').find(':selected').val(),
                  status : $('#status').find(':selected').val(),
                  shipper_name : $('#shipper_name').val(),
                  awb : $('#awb').val(),
                  address : $('#address').val(),
                  etd : $('#etd').val(),
                  eta : $('#eta').val(),
                }
              );
              const res = axios.patch("{{ route('shipment.update',$doc_data->id) }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      window.location.href = "{{ route('shipment.index') }}"; 
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
            { data: 'no' },
            { data: 'po_no' },
            { data: 'abbr' },
            { data: 'qty' },
            { data: 'qty_pack' },
            { data: 'uom' },
            { data: null},
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
                "po_no" : po_no,
                "qty_pack"       : 0,
                "entry_time" : entry_time,
                "seq" : 999,
          }

          var isExist = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if(id==obj["id"]){
              isExist = 1;
              orderList[i]["qty_pack"] = parseInt(orderList[i]["qty_pack"])+qty;
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
                      "qty_pack"       : obj["qty_pack"],
                      "abbr"      : obj["abbr"],
                      "qty"       : obj["qty"],
                      "ref_no"        : obj["ref_no"],

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
                  orderList[i]["qty_pack"] = parseInt(orderList[i]["qty_pack"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty_pack"])>1){
                  orderList[i]["qty_pack"] = parseInt(orderList[i]["qty_pack"])-1;
                } else if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty_pack"])==1) {
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
                  "qty_pack"       : obj["qty_pack"],
                     "uom"       : obj["uom"],
                      "abbr"      : obj["abbr"],
                      "qty"       : obj["qty"],
                    "ref_no"        : obj["ref_no"],

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
                  orderList[i]["total"] = (parseInt(orderList[i]["qty_pack"])+1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty_pack"] = parseInt(orderList[i]["qty_pack"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty_pack"])>1){
                  orderList[i]["total"] = (parseInt(orderList[i]["qty_pack"])-1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty_pack"] = parseInt(orderList[i]["qty_pack"])-1;
                } else if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty_pack"])==1) {
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
              table_product.row.add( {
                    "no"        : i+1,
                    "id"        : obj["id"],
                    "uom"        : obj["uom"],
                    "po_no"        : obj["po_no"],
                    "ref_no"        : obj["ref_no"],
                    "abbr"      : obj["abbr"],
                    "qty"       : obj["qty"],
                    "qty_pack"       : obj["qty_pack"], 
                    "action"    : "",
              }).draw(false);


            }

            $("html, body").animate({ scrollTop: $(document).height()-$(window).height() });
            
        });


 
    </script>
@endpush
