@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Show Purchase Order')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">Receive Order {{ $receive->receive_no }}</h4></div>
      <div class="">
        <a href="{{ route('receiveorders.print', $receive->id) }}" class="btn btn-warning">@lang('general.lbl_print') </a>
        <a href="{{ route('receiveorders.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
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
                name="dated"
                id="dated"
                class="form-control" 
                value="{{ substr(explode(" ",$receive->dated)[0],8,2) }}-{{ substr(explode(" ",$receive->dated)[0],5,2) }}-{{ substr(explode(" ",$receive->dated)[0],0,4) }}"
                required readonly/>
                @if ($errors->has('receive_date'))
                          <span class="text-danger text-left">{{ $errors->first('receive_date') }}</span>
                      @endif
              </div>

              <label class="form-label col-form-label col-md-1">PO</label>
              <div class="col-md-2">
                <input class="form-control" 
                    name="ref_no" id="ref_no" value="{{$receive->ref_no}}" disabled>
              </div>

              <label class="form-label col-form-label col-md-1 d-none">Shipto</label>
              <div class="col-md-1 d-none">
                <select class="form-control" 
                    name="branch_id" id="branch_id" required disabled>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"  {{ $receive->branch_id == $branch->id ? 'selected' : '' }}>{{ $branch->remark }} </option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">Supplier</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="supplier_id" id="supplier_id" required disabled>
                    <option value="">Select Suppliers</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}" {{ $receive->supplier_id == $supplier->id ? 'selected' : '' }} >{{ $supplier->id }} - {{ $supplier->name }} </option>
                    @endforeach
                </select>
              </div>

                <label class="form-label col-form-label col-md-1">@lang('general.lbl_remark')</label>
                <div class="col-md-2">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ $receive->remark }}" disabled/>
                  </div>
            </div>

            <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_order_list')</strong></div>
            <div class="row mb-3">
              
            </div>
            

            <table class="table table-striped" id="data_table">
              <thead>
              <tr>
                  <th>@lang('general.product')</th>
                  <th scope="col" width="10%">@lang('general.lbl_uom')</th>
                  <th scope="col" width="10%">@lang('general.lbl_price')</th>
                  <th scope="col" width="5%">@lang('general.lbl_qty')</th>
                  <th scope="col" width="10%">Disc</th>
                  <th scope="col" width="10%">Expired</th>
                  <th scope="col" width="10%">Total</th>
              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            <br>
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
                  <label id="lbl_total" class="col-md-4 h3">Total ({{ $receive->currency }})</label>
                  <label class="col-md-4  h3" id="result-total">0</label>
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

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          
          $('#invoice_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });

        
          var url = "{{ route('receiveorders.getdocdata',$receive->receive_no) }}";
          const resGetPO = axios.get(url, {
            headers: {
                'Content-Type': 'application/json'
              }
          }).then(resp => {
                sub_total = 0;
                var total = resp.data[0]["result_total"];
                var total_vat = resp.data[0]["total_vat"]; 

                for(var i=0;i<resp.data.length;i++){
                    var product = {
                          "id"          : resp.data[i]["product_id"],
                          "abbr"        : resp.data[i]["abbr"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"         : resp.data[i]["uom"],
                          "qty"         : resp.data[i]["qty"],
                          "exp"         : resp.data[i]["exp"],
                          "bno"         : resp.data[i]["bno"],
                          "total"       : resp.data[i]["total"],
                          "disc"    : resp.data[i]["discount"],
                          "price"       : resp.data[i]["price"]
                    }

                    orderList.push(product);
                }

                for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];

                  table.row.add( {
                   "id"           : obj["id"],
                    "remark"      : obj["remark"],
                    "uom"         : obj["uom"],
                    "price"       : currency(obj["price"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "qty"         : currency(obj["qty"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "disc"         : currency(obj["disc"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                    "exp"         : obj["exp"],
                    "total"       : currency(obj["total"], { separator: ".", decimal: ",", symbol: "", precision: 0 }).format(),
                  }).draw(false);
                  sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["disc"])));
                       
                }

                $('#result-total').text(currency(total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                $('#vat-total').text(currency(total_vat, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());
                $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: " ", precision: 0 }).format());

          });
      });

        var table = $('#data_table').DataTable({
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
            { data: 'exp' },
            { data: 'total' },
        ],
        });

        
 
    </script>
@endpush
