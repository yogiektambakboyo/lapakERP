@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Picking')

@section('content')
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">@lang('general.lbl_picking')</h4></div>
      <div class="">
        <a href="{{ route('picking.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-3">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-6">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-6">
                <input type="text" 
                name="doc_date"
                id="doc_date"
                class="form-control" 
                value="{{ old('doc_date') }}" required/>
                @if ($errors->has('doc_date'))
                          <span class="text-danger text-left">{{ $errors->first('doc_date') }}</span>
                      @endif
              </div>
            </div>
          </div>

          <div class="col-md-9">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_branch')</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="customer_id" id="customer_id" required>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}">{{ $customer->remark }}</option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-2">@lang('general.lbl_remark')</label>
              <div class="col-md-4">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ old('remark') }}"/>
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
          </div>
        </div>



        <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
        <div class="row mb-3 mt-2">
          <div class="row mb-1">
            <div class="col-md-4">
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

            <div class="col-md-1">
            </div>

            <div class="col-md-2">
              <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
              <button class="btn btn-primary" href="#modal-filter" data-bs-toggle="modal" data-bs-target="#modal-filter">@lang('general.lbl_add') dari PO</button>
            </div>
  
          </div>
          
        </div>

        <table class="table table-striped" id="order_product_table">
          <thead>
          <tr>
              <th scope="col"  width="3%">No</th>
              <th scope="col" >PO No</th>
              <th scope="col" >@lang('general.product')</th>
              <th scope="col" width="10%">@lang('general.lbl_uom')</th>
              <th scope="col" width="5%">@lang('general.lbl_qty')</th>
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
            <div class="col-md-12 d-none">
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
    let list_po;
      $(function () {
        $('#customer_id').select2();
        var xurl = "{{ route('purchaseordersinternal.getdocdatanotpicked','16') }}";
        var xlastvalurl = "16";
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
                    $('#input_product_uom').val(),
                    "-"
                  )
                }
              });
              

          });

          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          $('#doc_date').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#doc_date').val(formattedToday);
          $('#schedule_date').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#schedule_date').val(formattedToday);
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
                  addProduct(element.product_id,element.remark, element.qty, element.uom,element.purchase_no)
                }
                
            });
      });
        
        $('#save-btn').on('click',function(){
          if($('#doc_date').val()==''){
            $('#doc_date').focus();
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
            // call Loading
            let swal = Swal.fire({
                  title: 'Loading...',
                  html: 'Please wait, Request under processing',
                  allowEscapeKey: false,
                  allowOutsideClick: false,
                  didOpen: () => {
                    Swal.showLoading()
                  }
              });    

            const json = JSON.stringify({
                  doc_date : $('#doc_date').val(),
                  product : orderList,
                  customer_id : $('#customer_id').val(),
                  remark : $('#remark').val(),
                  total_order : order_total,
                  ref_no : $('#ref_no').val(),
                  payment_nominal : 0,
                  tax : _vat_total,
                }
              );
              const res = axios.post("{{ route('picking.store') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      Swal.fire({
                        text: "Dokumen berhasil dibaut dengan no : "+resp.data.message,
                        title : "@lang('general.lbl_success')",
                        icon: 'success',
                        showCancelButton: true,
                        cancelButtonColor: '#d33',
                        denyButtonColor: '#0072b3',
                        cancelButtonText: "@lang('general.lbl_close')",
                        confirmButtonText: "@lang('general.lbl_print')",
                      }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                          burl ="{{ route('picking.print', 'WWWW') }}";
                          burl = burl.replace('WWWW', resp.data.data)
                          //window.location.href = burl; 
                          window.open(
                            burl,
                            '_blank' // <- This is what makes it open in a new window.
                          );
                          window.location.href = "{{ route('picking.index') }}"; 
                        } else{
                          window.location.href = "{{ route('picking.index') }}"; 
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
              }).catch(function (error) {
                Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "@lang('general.lbl_msg_failed')"+error.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 2500
                        }
                      );
                console.log(error.toJSON());
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
            { data: 'seq' },
            { data: 'po_no' },
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'qty' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, qty,uom,po_no){
          console.log(id,abbr,qty,uom,po_no);
          table_product.clear().draw(false);
          order_total = 0;
          disc_total = 0;
          _vat_total = 0;
          sub_total = 0;
          entry_time = Date.now();
          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "uom"      : uom,
                "qty"       : qty,
                "entry_time" : entry_time,
                "po_no" : po_no,
                "seq" : 999,
          }

          var isExist = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            if("-"==obj["po_no"] && id==obj["id"]){
              isExist = 1;
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
          counterno_service = 0;
          order_total = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];

            counterno = counterno + 1;
            table_product.row.add( {
                  "seq" : counterno,
                  "id"        : obj["id"],
                  "abbr"      : obj["abbr"],
                  "uom"       : obj["uom"],
                  "po_no"      : obj["po_no"],
                  "qty"       : obj["qty"],
                  "action"    : "",
            }).draw(false);

              order_total = order_total + (parseFloat(obj["total"]));



          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        }

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

            orderList.sort(function(a, b) {
                return parseFloat(a.entry_time) - parseFloat(b.entry_time);
            });

            counterno = 0;
             counterno_service = 0;
            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type_id"]=="Services"){
              counterno_service  = counterno_service + 1;
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "qty"       : obj["qty"],
                      "assignedto": obj["assignedto"],
                      "po_no"      : obj["po_no"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }
                disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

            }
        });

    </script>
@endpush
