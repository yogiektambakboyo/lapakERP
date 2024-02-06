@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Products')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.product')</h1>
        <div class="lead row mb-3">
            <div class="col-md-9">
                <div class="col-md-4">
                    @lang('general.label')
                </div>
                <div class="col-md-8"> 	
                    {{-- <form action="{{ route('products.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.label_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                    </form> --}}
                </div>
            </div>
            <div class="col-md-3">
                <button onclick="openDialogFilterSearch('Filter');" class="btn btn-lime"><span class="fa fa-qrcode"></span> Print QR</button> 
                <a href="{{ route('products.create') }}" class="btn btn-primary float-right"><span class="fa fa-plus-circle"></span> @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th>@lang('general.lbl_name')</th>
                <th scope="col" width="15%">@lang('general.category')</th>
                <th scope="col" width="10%">@lang('general.brand')</th>
                <th scope="col" width="5%">@lang('general.tipe')</th>
                <th scope="col" width="5%">Barcode</th>
                <th scope="col" width="2%" class="nex">@lang('general.lbl_action')</th>   
                <th scope="col" width="2%" class="nex"></th>
                <th scope="col" width="2%" class="nex"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($products as $product)
                    <tr>
                        <th scope="row">{{ $product->id }}</th>
                        <td>{{ $product->product_name }}</td>
                        <td>{{ $product->product_category }}</td>
                        <td>{{ $product->product_brand }}</td>
                        <td>{{ $product->product_type }}</td>
                        <td>{{ $product->barcode }}</td>
                        <td><a href="{{ route('products.show', $product->id) }}" class="btn btn-warning btn-sm">@lang('general.lbl_show')</a></td>
                        <td><a href="{{ route('products.edit', $product->id) }}" class="btn btn-info btn-sm {{ $act_permission->allow_edit==1?'':'d-none' }} ">@lang('general.lbl_edit')</a></td>
                        <td>
                            <a onclick="showConfirm({{ $product->id }}, '{{ $product->product_name }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">@lang('general.lbl_delete')</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter2" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('products.print_qr') }}" method="GET" target="_blank">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Filter Vendor</label>
                        </div>
                        <div class="col-md-12">
                            <input class="form-control" type="text"
                                name="filter_vendor" id="filter_vendor" value="%">
                        </div>

                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Filter Bulan</label>
                        </div>
                        <div class="col-md-12">
                            <input class="form-control" type="text"
                                name="filter_bulan" id="filter_bulan" value="%">
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

        <!-- Vertically centered modal -->

    </div>
@endsection


@push('scripts')
    <script type="text/javascript">
        const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1;
          let dd = today.getDate();

          var myModal2 = new bootstrap.Modal(document.getElementById('modal-filter2'));

          function openDialogFilterSearch(command){
            $('#export').val(command);
            myModal2.show();
          }

$(document).ready(function () {
        $('#example').DataTable(
            {
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copyHtml5',
                        exportOptions: {
                            columns: ':not(.nex)'
                        }
                    },
                    {
                        extend: 'excelHtml5',
                        exportOptions: {
                            columns: ':not(.nex)'
                        }
                    }
                ]
            }
        );
    });

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
            confirmButtonText: "@lang('general.lbl_sure_delete')",
            cancelButtonText: "@lang('general.lbl_cancel')"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('products.destroy','XX') }}";
                    var lastvalurl = "XX";
                    url = url.replace(lastvalurl, id)
                    const res = axios.delete(url, {}, {
                        headers: {
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: "@lang('general.lbl_msg_delete')",
                                        text: "@lang('general.lbl_msg_delete_title')",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close')"
                                        }).then((result) => {
                                            window.location.href = "{{ route('products.index') }}"; 
                                        })
                                }else{
                                    Swal.fire(
                                    {
                                        position: 'top-end',
                                        icon: 'warning',
                                        text: "@lang('general.lbl_msg_failed') - "+resp.data.message,
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
