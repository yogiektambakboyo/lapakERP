@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Invoice')

@section('content')
<form method="POST" action="{{ route('pettyproduct.store') }}"  enctype="multipart/form-data">
  @csrf
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Produk Terpakai #{{ $invoice->doc_no }}</h4></div>
      <div class="">
        <a href="{{ route('pettyproduct.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-2">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated')   </label>
              <div class="col-md-8">
                <input type="hidden" value="{{ count($close_trans)>=1?$close_trans[0]->close_trans:0; }}" id="close_trans">
                <input type="hidden" 
                name="doc_no"
                id="doc_no"
                class="form-control" 
                value="{{ $invoice->doc_no }}"/>
                <input type="text" 
                name="dated"
                id="dated"
                class="form-control" 
                value="{{ substr(explode(" ",$invoice->dated)[0],8,2) }}-{{ substr(explode(" ",$invoice->dated)[0],5,2) }}-{{ substr(explode(" ",$invoice->dated)[0],0,4) }}" required/>
                @if ($errors->has('dated'))
                          <span class="text-danger text-left">{{ $errors->first('dated') }}</span>
                      @endif
              </div>
            </div>
          </div>

          <div class="col-md-3">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="branch_id" id="branch_id">
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}" {{ ($branch->id == $invoice->branch_id) 
                          ? 'selected'
                          : ''}}>{{  $branch->remark }}</option>
                    @endforeach
                </select>
              </div>
            </div>
          </div>

          <div class="col-md-3">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.tipe')</label>
              <div class="col-md-8">
                <select class="form-control" 
                  name="type" id="type" required>
                  <option value="">@lang('general.lbl_tipeselect')</label>
                  @foreach($doc_type as $doc)
                      <option value="{{ $doc }}" {{ ($doc == $invoice->type) 
                        ? 'selected'
                        : ''}}>{{ $doc }} </option>
                  @endforeach
              </select>
                </div>
            </div>
          </div>


          <div class="col-md-3">
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
          </div>

         

        </div>



        <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
        <div class="card text-center font-weight-bold my-3 p-1"><h3><i class="fas fa-fw fa-box"></i> @lang('general.product')</h3></div>

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
            <input type="hidden" 
            name="input_product_vat_total"
            id="input_product_vat_total"
            class="form-control" 
            value="{{ old('input_product_vat_total') }}" required disabled/>
            <input type="hidden" 
            name="input_product_total"
            id="input_product_total"
            class="form-control" 
            value="{{ old('input_product_total') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <input type="hidden" 
            name="input_product_price"
            id="input_product_price"
            class="form-control" 
            value="{{ old('input_product_price') }}" required disabled/>
          </div>

        </div>

         <table class="table table-striped" id="order_product_table">
          <thead>
          <tr>
              <th scope="col" width="5%">No</th>
              <th scope="col">@lang('general.product')</th>
              <th scope="col" width="10%">@lang('general.lbl_uom')</th>
              <th scope="col" width="5%">@lang('general.lbl_qty')</th>
              <th scope="col" width="20%" class="nex">@lang('general.lbl_action')</th> 
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
            <div class="col-md-12">
              <div class="col-auto text-end d-none">
                <label class="col-md-2"><h1>Total </h1></label>
                <label class="col-md-8 display-5" id="result-total"> <h1>0</h1></label>
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
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday =  dd + '-' + mm + '-' + yyyy;
          $('#dated').datepicker({
              dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });

          var url = "{{ route('orders.getorder','XX') }}";
          var lastvalurl = "XX";
          console.log(url);
      

      });


      $('#dated').on("change", function () {
          var invoice_date = $('#dated').val(); 
          var url = "{{ route('period.get_period_status') }}";
          $('#save-btn').removeClass("d-none");
        const res = axios.get(url,
        {
            headers: {
              'Content-Type': 'application/json'
            },
            params : {
                invoice_date : moment(invoice_date, 'DD-MM-YYYY').format('YYYY-MM-DD')
            }
          }
        ).then(resp => {
          var respon = resp.data;
          if(respon[0].close_trans == "1"){
            $('#save-btn').addClass("d-none");
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Status periode '+respon[0].remark+' tertutup, anda tidak diperbolehkan membuat transaksi di periode tsb',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{
            $('#save-btn').removeClass("d-none");
          }
        });
      });

      if($('#close_trans').val()=="1"){
        $('#save-btn').addClass("d-none");
        Swal.fire(
          {
            position: 'top-end',
            icon: 'warning',
            text: 'Status periode {{ count($close_trans)>=1?$close_trans[0]->remark:0;  }} tertutup, anda tidak diperbolehkan mengubah data',
            showConfirmButton: false,
            imageHeight: 30, 
            imageWidth: 30,   
            timer: 5000
          }
        );
      }

  

      var productList = [];
      var orderList = [];
      var order_total = 0;
      var disc_total = 0;
      var _vat_total = 0;
      var sub_total = 0;
        
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
          }else{

            counterBlank = 0;
            for (var i=0;i<orderList.length;i++){
              if(orderList[i]["assignedto"]=="" && orderList[i]["type"] == "Services"){
                  counterBlank++;
                }
            }

            if(counterBlank>0){
              Swal.fire(
              {
                  position: 'top-end',
                  icon: 'warning',
                  text: 'Please choose terapist for service',
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
                  product : orderList,
                  branch_id : $('#branch_id').val(),
                  type : $('#type').val(),
                  remark : $('#remark').val(),
                  total_order : order_total,
                }
              );
              const res = axios.patch("{{ route('pettyproduct.update',$invoice->id) }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      window.location.href = "{{ route('pettyproduct.index') }}"; 
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
          }
        });
        
        $('#product-table').DataTable({
          "bInfo" : false,
          pagingType: 'numbers',
          ajax: "{{ route('pettyproduct.getproduct') }}",
          columns: [
            { data: 'remark' },
            { data: 'remark' },
            { data: 'type' },
            { data: 'action', name: 'action', orderable: false, searchable: false}
        ],
        }); 


        var table_product = $('#order_product_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-sm btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></a>'+
            '<a href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-sm btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></a>'+
            '<a href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-sm btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></a>'
          }],
          columns: [
            { data: 'seq' },
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'qty' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, qty, uom,vat_total,total,type){
          table_product.clear().draw(false);
          order_total = 0;
          disc_total = 0;
          _vat_total = 0;
          sub_total = 0;
          entry_time = Date.now();

          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "price"     : price,
                "discount"  : 0,
                "qty"       : qty,
                "total"     : total,
                "assignedto" : "",
                "assignedtoid" : "",
                "referralby" : "",
                "referralbyid" : "",
                "uom" : uom,
                "vat_total"     : vat_total, 
                "type"     : type, 
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
          counterno_service = 0;


          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];
            if(obj["type"]!="Goods"){
              
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }
              disc_total = disc_total + 0;
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0);
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100)))-0;

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }
          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        }

       

           

            var url = "{{ route('orders.getproduct_nostock') }}";
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
                  if(obj["type"]!="Goods"){
                    $('#input_service_id').append(newOption).trigger('change');  
                  }else{
                    $('#input_product_id').append(newOption).trigger('change');  
                  }
                }

                // Service
            $('#input_service_id').on('change.select2', function(e){
                $.each(productList, function(i, v) {
                    if (v.id == $('#input_service_id').find(':selected').val()) {
                        $('#input_service_uom').val(v.uom);
                        $('#input_service_price').val(v.price);
                        $('#input_service_qty').val(1);
                        $('#input_service_disc').val(0);
                        $('#input_service_total').val(v.price);
                        $('#input_service_vat_total').val(v.vat_total);
                        return;
                    }
                });
              });

              $('#input_service_price').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_qty').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_disc').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_submit').on('click', function(){
                if($('#input_service_id').val()==''){
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
                }else if($('#input_service_qty').val()==''){
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
                }else if($('#input_service_price').val()==''){
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
                }else if($('#input_service_disc').val()==''){
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
                }else if($('#input_service_total').val()<0){
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
                    $('#input_service_id').val(),
                    $('#input_service_id option:selected').text(), 
                    $('#input_service_price').val(), 
                    $('#input_service_qty').val(),
                    $('#input_service_uom').val(),
                    $('#input_service_vat_total').val(),
                    $('#input_service_total').val(),
                    "Services"
                  )
                }
              });

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
                    $('#input_product_price').val(), 
                    $('#input_product_qty').val(),
                    $('#input_product_uom').val(),
                    $('#input_product_vat_total').val(),
                    $('#input_product_total').val(),"Goods"
                  )
                }
              });
              

          });



          $("#apply-voucher-btn").on('click',function(){
              if($("#input-apply-voucher").val()==""){
                  Swal.fire(
                  {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Silahkan inputkan nomor voucher dahulu',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                  });
              }else{
                var url = "{{ route('orders.checkvoucher') }}";
                const res = axios.get(url,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    params : {
                        voucher_code : $("#input-apply-voucher").val()
                    }
                  }
                ).then(resp => {
                  if(orderList.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Masukkan dahulu sku yang dipesan pelanggan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });
                    $("#input-apply-voucher").val("");

                  }else if(resp.data.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Nomor voucher '+$("#input-apply-voucher").val()+' tidak ditemukan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });

                  }else{
                    table_product.clear().draw(false);
                    order_total = 0;
                    disc_total = 0;
                    _vat_total = 0;
                    sub_total = 0;

                    counterVoucherHit = 0;

                    for (var i = 0; i < orderList.length; i++){
                      for (var j = 0; j < resp.data.length;j++){
                        if(resp.data[j].product_id == orderList[i]["id"]){
                          orderList[i]["discount"] = ( ((parseFloat(resp.data[j].value)) * (parseFloat(orderList[i]["price"])) * (parseFloat(orderList[i]["qty"])) )/100 );
                          orderList[i]["total"] = ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100)))-0;
                          $("#remark").val($("#remark").val()+"["+resp.data[j].remark+"]");
                          counterVoucherHit++;
                          voucherNo = $("#input-apply-voucher").val();
                          $("#voucher_code").val(voucherNo);
                          voucherNoPID = resp.data[j].product_id;
                        }
                      }

                      orderList.sort(function(a, b) {
                          return parseFloat(a.entry_time) - parseFloat(b.entry_time);
                      });
                      counterno = 0;
                      counterno_service = 0;

                      var obj = orderList[i];
                      var value = obj["abbr"];
                      if(obj["type"]!="Goods"){
                        counterno_service  = counterno_service + 1;
                        table.row.add( {
                                "seq" : counterno_service,
                                "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"],
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }else{
                          counterno = counterno + 1;
                          table_product.row.add( {
                              "seq" : counterno,
                              "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"],
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }
                        disc_total = disc_total + 0;
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0);
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100)))-0;

                        if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').css('color', 'black');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("Rp. 0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }
                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());


                    if(counterVoucherHit>0){
                      Swal.fire(
                      {
                          position: 'top-end',
                          icon: 'success',
                          text: 'Nomor voucher '+$("#input-apply-voucher").val()+' berhasil dipakai',
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                      });
                    }else{
                      Swal.fire(
                      {
                          position: 'top-end',
                          icon: 'warning',
                          text: 'Nomor voucher '+$("#input-apply-voucher").val()+' tidak ada yang cocok dengan SKU yang dipesan',
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                      });
                    }
                  }

                });

              }
            });


            //Get Invoice 
            const resInvoice = axios.get("{{ route('pettyproduct.getinvoice',$invoice->doc_no) }}", {
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
                            "id"        : resp.data[i]["product_id"],
                            "abbr"      : resp.data[i]["remark"],
                            "uom"      : resp.data[i]["uom"],
                            "price"     : resp.data[i]["price"],
                            "discount"  : resp.data[i]["discount"],
                            "qty"       : resp.data[i]["qty"],
                            "total"     : resp.data[i]["total"],
                            "assignedto"     : resp.data[i]["assignedto"],
                            "assignedtoid"     : resp.data[i]["assignedtoid"],
                            "referralby" : resp.data[i]["referral_by_name"],
                            "referralbyid" : resp.data[i]["referral_by"],
                            "uom" : resp.data[i]["uom"],
                            "vat_total"     : resp.data[i]["vat"], 
                            "type"     : resp.data[i]["type"], 
                      }

                      orderList.push(product);
                  }

                  counterno = 0;
                  counterno_service = 0;  

                  for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];
                  var value = obj["abbr"];
                  if(obj["type"]!="Goods"){
                  }else{
                    counterno = counterno + 1;
                    table_product.row.add( {
                        "seq" : counterno,
                        "id"        : obj["id"],
                          "abbr"      : obj["abbr"],
                          "uom"       : obj["uom"],
                          "price"     : obj["price"],
                          "discount"  : obj["discount"],
                          "qty"       : obj["qty"],
                          "total"     : obj["total"],
                          "assignedto": obj["assignedto"],
                          "referralby" : obj["referralby"],
                          "action"    : "",
                    }).draw(false);
                  }
                    disc_total = disc_total + 0;
                    sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0);
                    _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100));
                    order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100)))-0;

                    if(($('#payment_nominal').val())>order_total){
                      $('#order_charge').css('color', 'black');
                      $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    }else{
                      $('#order_charge').text("Rp. 0");
                      $('#order_charge').css('color', 'red');
                      $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    }
                }

                $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());              
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

            counterno = 0;
            counterno_service = 0;  
            orderList.sort(function(a, b) {
                return parseFloat(a.seq) - parseFloat(b.seq);
            });

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type"]!="Goods"){
                counterno_service  = counterno_service + 1;
                table.row.add( {
                        "seq" : counterno_service,
                        "id"        : obj["id"],
                        "abbr"      : obj["abbr"],
                        "uom"       : obj["uom"],
                        "price"     : obj["price"],
                        "discount"  : obj["discount"],
                        "qty"       : obj["qty"],
                        "total"     : obj["total"],
                        "assignedto": obj["assignedto"],
                        "referralby" : obj["referralby"],
                        "action"    : "",
                  }).draw(false);
                }else{
                  counterno = counterno + 1;
                  table_product.row.add( {
                      "seq" : counterno,
                      "id"        : obj["id"],
                        "abbr"      : obj["abbr"],
                        "uom"       : obj["uom"],
                        "price"     : obj["price"],
                        "discount"  : obj["discount"],
                        "qty"       : obj["qty"],
                        "total"     : obj["total"],
                        "assignedto": obj["assignedto"],
                        "referralby" : obj["referralby"],
                        "action"    : "",
                  }).draw(false);
                }
                disc_total = disc_total + 0;
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0);
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-0)*(parseFloat(orderList[i]["vat_total"])/100)))-0;

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }


            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());


            
        });


 
    </script>
@endpush
