@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Lihat Perjalanan')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4 class="">No Perjalanan {{ $purchase->doc_no }}</h4></div>
      <div class="">
        <a href="{{ route('triprequest.print', $purchase->id) }}" class="btn btn-warning">@lang('general.lbl_print') </a>
        <a href="{{ route('triprequest.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
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
                value="{{ Carbon\Carbon::parse($purchase->dated)->format('d-m-Y') }}"
                required disabled/>
                @if ($errors->has('purchase_date'))
                          <span class="text-danger text-left">{{ $errors->first('purchase_date') }}</span>
                      @endif
              </div>

              <label class="form-label col-form-label col-md-1">Cabang Asal</label>
              <div class="col-md-3">
                <input type="text" 
                name="location_source"
                id="location_source"
                class="form-control" 
                value="{{ $purchase->location_source }}"
                required disabled/>
              </div>

              <label class="form-label col-form-label col-md-2">Cabang Tujuan</label>
              <div class="col-md-3">
                <input type="text" 
                name="location_destination"
                id="location_destination"
                class="form-control" 
                value="{{ $purchase->location_destination }}"
                required disabled/>
              </div>

                
            </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-1">Staff</label>
                <div class="col-md-2">
                  <input type="text" 
                  name="staff"
                  id="staff"
                  class="form-control" 
                  value="{{ $purchase->staff }}" disabled/>
                  </div>
              <label class="form-label col-form-label col-md-1">@lang('general.lbl_remark')</label>
                <div class="col-md-2">
                  <input type="text" 
                  name="remark"
                  id="remark"
                  class="form-control" 
                  value="{{ $purchase->remark }}" disabled/>
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
                  <th scope="col" width="10%">Total</th>
              </tr>
              </thead>
              <tbody>
              </tbody>
            </table> 
            
            
            <br>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-9 text-end d-none"><h2>Sub Total </h2></label>
              <div class="col-md-3 d-none">
                <h3 class="text-end"><label id="sub-total">{{ number_format(($purchase->total-$purchase->total_vat),0,',','.') }}</label></h3>
              </div>

              <label class="form-label col-form-label col-md-9 text-end d-none"><h2>@lang('general.lbl_tax') </h2></label>
              <div class="col-md-3 d-none">
                <h3 class="text-end"><label id="vat-total">{{ number_format($purchase->total,0,',','.') }}</label></h3>
              </div>

              <label class="form-label col-form-label col-md-9 text-end"><h1>Total</h1></label>
              <div class="col-md-3">
                <h1 class="display-5 text-end"><label id="order-total">Rp. {{ number_format($purchase->total,0,',','.') }}</label></h1>
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

        
          var url = "{{ route('triprequest.getdocdata',$purchase->doc_no) }}";
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
                          "disc"         : resp.data[i]["discount"],
                          "total"       : resp.data[i]["subtotal"],
                          "total_vat"       : resp.data[i]["subtotal_vat"],
                          "price"       : resp.data[i]["price"]
                    }

                    orderList.push(product);

                    $('#location_source').val(resp.data[i]["location_source"]);
                    $('#location_destination').val(resp.data[i]["location_destination"]);
                    $('#staff').val(resp.data[i]["name"]);
                }

                for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];

                  table.row.add( {
                   "id"           : obj["id"],
                    "remark"      : obj["remark"],
                    "uom"         : obj["uom"],
                    "price"       : obj["price"],
                    "qty"         : obj["qty"],
                    "total"       : obj["total"],
                  }).draw(false);
                  order_total = order_total + (parseFloat(orderList[i]["total"]));
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
            { data: 'total' },
        ],
        }); 
    </script>
@endpush
