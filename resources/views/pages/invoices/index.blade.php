@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Sales Invoice')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_invoice')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-12">
                    @lang('general.lbl_invoice_title')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('invoices.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <input type="hidden" name="filter_begin_date" value="2022-01-01"><input type="hidden" name="filter_end_date" value="2035-01-01">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.lbl_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">@lang('general.btn_filter')</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                        <div class="col-2"><input type="button" class="btn btn-sm btn-warning d-none" value="Gabung Pembayaran" name="join" id="join_payment"   href="#modal-add-payment" data-bs-toggle="modal" data-bs-target="#modal-add-payment"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('invoices.create') }}" class="btn btn-primary float-right {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="14%">@lang('general.lbl_branch')</th>
                <th>@lang('general.invoice_no')</th>
                <th scope="col" width="8%">@lang('general.lbl_dated')</th>
                <th scope="col" width="15%">@lang('general.lbl_total_customer')</th>
                <th scope="col" width="10%">Total</th>
                <th scope="col" width="10%">@lang('general.lbl_total_payment')</th>
                <th scope="col" width="2%" class="nex">@lang('general.lbl_action')</th>  
                <th scope="col" width="2%" class="nex"></th>
                <th scope="col" width="2%" class="nex"></th>    
                <th scope="col" width="2%" class="nex"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($invoices as $order)
                    <tr>
                        <td>{{ $order->branch_name }}</td>
                        <td @if ($order->is_checkout == 0) class="bg-danger" @endif>{{ $order->invoice_no }}</td>
                        <td>{{ Carbon\Carbon::parse($order->dated)->format('d-m-Y') }}</td>
                        <td>{{ $order->customer }}</td>
                        <td>{{ number_format($order->total,0,',','.') }}</td>
                        <td  @if ($order->total_payment < $order->total) class="bg-warning" @endif>{{ number_format($order->total_payment,0,',','.') }}</td>
                        <td><a href="{{ route('invoices.show', $order->id) }}" class="btn btn-warning btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_show')</a></td>
                        @if (($order->is_checkout == 0)&&($order->total_payment >= $order->total))
                        <td>
                            <a onclick="showConfirmCheckout({{ $order->id }}, '{{ $order->invoice_no }}')" class="btn btn-success btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_checkout')</a>
                        </td>
                        @elseif($order->is_checkout == 0)
                        <td>
                            <a onclick="showErrorCheckout({{ $order->id }}, '{{ $order->invoice_no }}')" class="btn btn-success btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_checkout')</a>
                        </td>
                        @else
                        <td></td>
                        @endif
                        <td><a href="{{ route('invoices.edit', $order->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">@lang('general.lbl_edit')</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            <a onclick="showConfirm({{ $order->id }}, '{{ $order->invoice_no }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">@lang('general.lbl_delete')</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('invoices.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="">@lang('general.lbl_allbranch')</option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_date_start')</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_begin_date"
                            id="filter_begin_date"
                            class="form-control" 
                            value="{{ old('filter_begin_date') }}" required/>
                            @if ($errors->has('filter_begin_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date') }}</span>
                                @endif
                        </div>

                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_date_end')</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_end_date"
                            id="filter_end_date"
                            class="form-control" 
                            value="{{ old('filter_end_date') }}" required/>
                            @if ($errors->has('filter_end_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_end_date') }}</span>
                                @endif
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
        </div>

        <div class="modal fade" id="modal-add-payment" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">Gabung Pembayaran</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  
                  <div class="container mt-4">
                          <div class="mb-3">
                              <label for="cust_name" class="form-label">@lang('general.lbl_name')</label>
                              <input value="{{ old('cust_name') }}" 
                                  type="text" 
                                  class="form-control" 
                                  name="cust_name" 
                                  id="cust_name" 
                                  placeholder="@lang('general.lbl_name')" required>
          
                              @if ($errors->has('cust_name'))
                                  <span class="text-danger text-left">{{ $errors->first('cust_name') }}</span>
                              @endif
                          </div>
          
                          
                  </div>
      
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_save_payment">@lang('general.lbl_save')</button>
                </div>
            </div>
            </div>
          </div>


    </div>
@endsection


@push('scripts')
    <script type="text/javascript">
         //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
         
          const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#filter_begin_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_begin_date').val(formattedToday);


          $('#filter_end_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_end_date').val(formattedToday);

          function showConfirm(id,data){
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
                    var url = "{{ route('invoices.destroy','XX') }}";
                    var lastvalurl = "XX";
                    console.log(url);
                    url = url.replace(lastvalurl, id)
                    const res = axios.delete(url, {}, {
                        headers: {
                            // Overwrite Axios's automatically set Content-Type
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: 'Deleted!',
                                        text: "@lang('general.lbl_msg_delete_title') ",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close') "
                                        }).then((result) => {
                                            window.location.href = "{{ route('invoices.index') }}"; 
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
                                    });
                            }
                        });
                    }
                })
        }

        function showErrorCheckout(id,data){

            Swal.fire(
            {
                position: 'top-end',
                icon: 'warning',
                text: "@lang('general.lbl_msg_failed') Faktur "+data+" belum lunas, silahkan penuhi pembayaran dahulu sesuai total ",
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
            });
        }

        function showConfirmCheckout(id,data){
            Swal.fire({
            title: "@lang('general.lbl_sure')",
            text: "@lang('general.lbl_sure_chekout_title') "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
            confirmButtonText: "@lang('general.lbl_sure_checkout')"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('invoices.checkout','XX') }}";
                    var lastvalurl = "XX";
                    console.log(url);
                    url = url.replace(lastvalurl, id)
                    const res = axios.patch(url, {}, {
                        headers: {
                            // Overwrite Axios's automatically set Content-Type
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: 'Success!',
                                        text: "@lang('general.lbl_msg_checkout_title') ",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close') "
                                        }).then((result) => {
                                            window.location.href = "{{ route('invoices.index') }}"; 
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
                                    });
                            }
                        });
                    }
                })
        }
    </script>
@endpush

@push('scripts')
<script type="text/javascript">
    let table;
    let str_inv = "";
    $(document).ready(function () {
        table = $('#example').DataTable({
                select: {
                    style: 'multi'
                },
        });

        $('#join_payment').on('click',function(){
            str_inv = "";
            $('#join_payment').text("Gabung Pembayaran ("+table.rows({ selected: true }).count()+")");
            rowdata = table.rows('.selected').data();
              for (var i = 0; i < rowdata.length; i++) {
                if(i==0){
                    str_inv = rowdata[i][1]; 
                }else{
                    str_inv = str_inv + ";"+rowdata[i][1]; 
                }
            }

            if(table.rows({ selected: true }).count()>1){
                $('#join_payment').removeClass("d-none");

                const json = JSON.stringify({
                        invoice_no : str_inv,
                    }
                );
              
                var url = "{{ route('invoices.getfreeinvoice') }}";
                const res = axios.post(url, json,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    }
                  }
                ).then(resp => {
                    

                    resp.data.forEach(element => {
                        console.log(element.invoice_no);
                    });

                });
                

            }else{
                $('#join_payment').addClass("d-none");
            }
           

            console.log(str_inv);
         });

         table
        .on('select', function (e, dt, type, indexes) {
            if(table.rows({ selected: true }).count()>1){
                //$('#join_payment').removeClass("d-none");
            }else{
                $('#join_payment').addClass("d-none");
            }
            $('#join_payment').val("Gabung Pembayaran ("+table.rows({ selected: true }).count()+")");
        })
        .on('deselect', function (e, dt, type, indexes) {
            if(table.rows({ selected: true }).count()>1){
                $('#join_payment').removeClass("d-none");
            }else{
                $('#join_payment').addClass("d-none");
            }
            $('#join_payment').val("Gabung Pembayaran ("+table.rows({ selected: true }).count()+")");
        });
    });
</script>
@endpush
