@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Purchase Order')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Purchase Order {{ $purchase->purchase_no }}</h4></div>
      <div class="">
        <a target="_blank" href="{{ route('purchaseorders.print', $purchase->id) }}" class="btn btn-warning">@lang('general.lbl_print') </a>
        <a id="btn_list_rec" target="_blank" href="{{ route('receiveorders.search') }}/?filter_begin_date=2022-01-01&filter_end_date=2035-01-01&filter_branch_id=%25&search={{ $purchase->purchase_no }}&submit=Search" class="btn btn-danger">List @lang('general.lbl_receive') </a>
        <a id="btn_rec" target="_blank" href="{{ route('receiveorders.createfrompo', $purchase->purchase_no) }}" class="btn btn-primary">@lang('general.lbl_receive') </a>
        <a href="{{ route('purchaseorders.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="row mb-3">
          <div class="col-md-12">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-2">
                <input type="hidden" name="purchase_no"  id="purchase_no" value="{{ $purchase->purchase_no }}">
                <input type="text" 
                name="dated"
                id="dated"
                class="form-control" 
                value="{{ substr(explode(" ",$purchase->dated)[0],8,2) }}-{{ substr(explode(" ",$purchase->dated)[0],5,2) }}-{{ substr(explode(" ",$purchase->dated)[0],0,4) }}"
                required disabled/>
                @if ($errors->has('purchase_date'))
                          <span class="text-danger text-left">{{ $errors->first('purchase_date') }}</span>
                      @endif
              </div>

              <label class="form-label col-form-label col-md-1">Shipto</label>
              <div class="col-md-3">
                <select class="form-control" 
                    name="branch_id" id="branch_id" required disabled>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"  {{ $purchase->branch_id == $branch->id ? 'selected' : '' }}>{{ $branch->remark }} </option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">Supplier</label>
              <div class="col-md-4">
                <select class="form-control" 
                    name="supplier_id" id="supplier_id" required disabled>
                    <option value="">Select Suppliers</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}" {{ $purchase->supplier_id == $supplier->id ? 'selected' : '' }} >{{ $supplier->id }} - {{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
            <div class="row mb-3">
              
            </div>
            

            <table class="table table-striped" id="order_table">
              <thead>
              <tr>
                  <th>@lang('general.product')</th>
                  <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                  <th scope="col" width="10%">@lang('general.lbl_price')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="5%">Disc</th>
                  <th scope="col" width="10%">Total</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty') @lang('general.lbl_receive') </th>

              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            
            <br>
            <div class="row mb-3  bg-light">
              <div class="col-md-6 mt-1">
                
                <ul class="nav nav-tabs">
                  <li class="nav-item">
                    <a href="#default-tab-1" data-bs-toggle="tab" class="nav-link active">Note</a>
                  </li>
                  <li class="nav-item">
                    <a href="#default-tab-2" data-bs-toggle="tab" class="nav-link">@lang('general.lbl_payment')</a>
                  </li>
                </ul>
                <div class="tab-content panel p-3 rounded-0 rounded-bottom">
                  <div class="tab-pane fade active show" id="default-tab-1">
                    <div class="row mb-1">
                      <label class="form-label col-form-label col-md-3">@lang('sidebar.MataUang')</label>
                      <div class="col-md-2">
                        <input type="hidden" name="curr_def" id="curr_def" value="{{ $branchs[0]->currency }}">
                        <select class="form-select" name="currency" id="currency" disabled>
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
                        <input type="number" class="form-control kurs  d-none" id="kurs" value="1" name="kurs" readonly>
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
                        id="remark" readonly
                        class="form-control" 
                        value="{{ old('remark') }}"/>
                        </div>
                    </div>
                  </div>
                  <div class="tab-pane fade" id="default-tab-2">
                    <div class="row">
                      <div class="col-sm-10"><label id="total_payment"></label> </div>
                      <div class="col-sm-2"><input type="button" value="Add" class="btn btn-sm btn-primary"   href="#modal-add-payment" data-bs-toggle="modal" data-bs-target="#modal-add-payment" ></div>
                    </div>
                    <div class="row">
                      <div class="col-sm-12">
                        <table class="table table-sm table-striped" id="table_payment">
                          <thead>
                            <tr>
                              <td>Date</td>
                              <td>Payment</td>
                              <td>Value</td>
                              <td>Action</td>
                            </tr>
                            
                          </thead>
                          <tbody>
                            @php
                             for ($i=0; $i < count($po_payment); $i++) { 
                                echo '<tr>
                                        <td>'.$po_payment[$i]->dated.'</td>
                                        <td>'.$po_payment[$i]->payment_type.'</td>
                                        <td>'.number_format($po_payment[$i]->nominal,0,',','.').'</td>
                                        <td><input type="button" class="btn btn-sm btn-danger" onclick="deletePayment('.$po_payment[$i]->id.',\''.$po_payment[$i]->dated.'\');" value="Delete"></td>
                                      </tr>';
                             }
                            @endphp
                            
                          </tbody>
                        </table>
                      </div>
                    </div>
                  </div>
                </div>

                
              </div>


              <div class="col-md-6  mt-1">
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
                    <label class="col-md-4  h3" id="result-total">{{ number_format($purchase->total,0,',','.') }}</label>
                  </div>
                </div>
              </div>
            </div>

            
          <div class="col-md-12">
          </div>

          <!-- Begin Modal Add Payment -->
          <div class="modal fade" id="modal-add-payment" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_payment')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  
                  <div class="container mt-1">
                          <div class="mb-3">
                              <label for="lbl_dated" class="form-label">@lang('general.lbl_dated')</label>
                              <input type="text" class="form-control" name="payment_dated" id="payment_dated" required>
                              @if ($errors->has('payment_dated'))
                                  <span class="text-danger text-left">{{ $errors->first('payment_dated') }}</span>
                              @endif
                          </div>
                          <div class="mb-3">
                            <label for="payment_type" class="form-label">@lang('general.lbl_type_payment')</label>
                            <select name="payment_type" class="form-control" id="payment_type">
                              <option value="Cash">Cash</option>
                              <option value="Transfer">Transfer</option>
                              <option value="Debit Card">Debit Card</option>
                              <option value="Credit Card">Credit Card</option>
                            </select>
                            @if ($errors->has('payment_type'))
                                <span class="text-danger text-left">{{ $errors->first('payment_type') }}</span>
                            @endif
                        </div>
                          <div class="mb-3">
                              <label for="payment_nominal" class="form-label">@lang('general.lbl_payment')</label>
                              <input type="number" class="form-control" name="payment_nominal" id="payment_nominal" value="0" required>
                              @if ($errors->has('payment_nominal'))
                                  <span class="text-danger text-left">{{ $errors->first('payment_nominal') }}</span>
                              @endif
                          </div>

                         
                  </div>
      
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" onclick="addPayment()" id="btn_save_payment">@lang('general.lbl_save')</button>
                </div>
            </div>
            </div>
          </div>

        <!-- End Modal Add Payment -->
        
        </div>
    </div>
  </div>
@endsection

@push('scripts')
    <script type="text/javascript">
      var productList = [];
      var orderList = [];
      var order_total = 0;

      function deletePayment(id, data){
        Swal.fire({
            title: "@lang('general.lbl_sure')",
            text: "@lang('general.lbl_sure_title') "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
            confirmButtonText: "@lang('general.lbl_sure_delete')"
            }).then((result) => {
                if (result.isConfirmed) {
                  const json = JSON.stringify({
                        id : id,
                      }
                );

                const res = axios.post("{{ route('purchaseorders.payment_delete') }}", json, {
                      headers: {
                        'Content-Type': 'application/json'
                      }
                }).then(resp => {
                          if(resp.data.status=="success"){
                            refreshTable();
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
                })



        
      }

      function addPayment(){
                const json = JSON.stringify({
                        payment_type : $('#payment_type').find(':selected').val(),
                        purchase_no : $('#purchase_no').val(),
                        nominal : $('#payment_nominal').val(),
                        dated : $('#payment_dated').val(),
                      }
                );

                const res = axios.post("{{ route('purchaseorders.payment_store') }}", json, {
                      headers: {
                        'Content-Type': 'application/json'
                      }
                }).then(resp => {
                          if(resp.data.status=="success"){
                            refreshTable();
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

      function refreshTable(){
        const json = JSON.stringify({
                purchase_no : $('#purchase_no').val(),
              }
        );

        const res = axios.post("{{ route('purchaseorders.payment_get') }}", json, {
              headers: {
                'Content-Type': 'application/json'
              }
        }).then(resp => {
                  if(resp.data.status=="success"){
                    var data_doc = resp.data.data;
                    $('#table_payment tbody').html("");
                    var total_p = 0;
                    for (let index = 0; index < data_doc.length; index++) {
                      const element = data_doc[index];

                      var ct = '<tr><td>'+element.dated+'</td><td>'+element.payment_type+'</td><td>'+currency((element.nominal), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format()+'</td><td><input type="button" class="btn btn-sm btn-danger" onclick="deletePayment('+element.id+',\''+element.dated+'\');" value="Delete"></td></tr>';
                      $('#table_payment tbody').append(ct);
                      total_p = total_p + parseFloat(element.nominal);
                      
                    } 
                    $('#total_payment').text("Total : "+currency((total_p), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
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
         
      $(function () {
          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
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

          //$('#lbl_total').text("Total ("+$('#curr_def').val()+")");
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          
          $('#invoice_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });

          $('#payment_dated').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });

          $('#payment_dated').val(formattedToday);

        
          var url = "{{ route('purchaseorders.getdocdata',$purchase->purchase_no) }}";
          const resGetPO = axios.get(url, {
            headers: {
                'Content-Type': 'application/json'
              }
          }).then(resp => {
                for(var i=0;i<resp.data.length;i++){
                    var product = {
                          "id"          : resp.data[i]["product_id"],
                          "abbr"        : resp.data[i]["abbr"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"         : resp.data[i]["uom"],
                          "qty"         : resp.data[i]["qty"],
                          "qty_rec"         : resp.data[i]["qty_rec"],
                          "disc"         : resp.data[i]["discount"],
                          "total"       : resp.data[i]["subtotal"],
                          "total_vat"       : resp.data[i]["subtotal_vat"],
                          "price"       : resp.data[i]["price"]
                    }

                    orderList.push(product);
                }

                var counter_rec = 0;
                for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];

                  table.row.add( {
                   "id"           : obj["id"],
                    "remark"      : obj["remark"],
                    "uom"         : obj["uom"],
                    "price"       : obj["price"],
                    "qty"         : obj["qty"],
                    "disc"         : obj["disc"],
                    "total"       : obj["total"],
                    "qty_rec"       : obj["qty_rec"],
                  }).draw(false);
                  order_total = order_total + (parseFloat(orderList[i]["total_vat"]));

                  counter_rec = counter_rec + parseFloat(obj["qty_rec"]);
                }


                if(counter_rec>0){
                  $('#btn_list_rec').removeClass("d-none");

                }else{
                  $('#btn_list_rec').addClass("d-none");
                }

                $('#order-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

          });
      });

        var table = $('#order_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            ''
          }],
          columns: [
            { data: 'remark' },
            { data: 'uom' },
            { data: 'price' },
            { data: 'qty' },
            { data: 'disc' },
            { data: 'total' },
            { data: 'qty_rec' },
        ],
        }); 
    </script>
@endpush
