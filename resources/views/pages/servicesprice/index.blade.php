@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Price')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_service_price')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.label')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('servicesprice.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <input type="hidden" class="form-control  form-control-sm" name="filter_branch_id" value="{{ $request->filter_branch_id }}">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.label_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">@lang('general.btn_filter')</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('servicesprice.create') }}" class="btn btn-primary float-right  {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th>@lang('general.lbl_name')</th>
                <th scope="col" width="15%">@lang('general.lbl_branch')</th>
                <th scope="col" width="10%">@lang('general.lbl_price')</th>
                <th scope="col" width="2%">@lang('general.lbl_action')</th>   
                <th scope="col" width="2%"></th> 
            </tr>
            </thead>
            <tbody>

                @foreach($products as $product)
                    <tr>
                        <td>{{ $product->product_name }}</td>
                        <td>{{ $product->branch_name }}</td>
                        <td>{{ number_format($product->product_price,0,',','.') }}</td>
                        <td><a href="{{ route('servicesprice.edit', [$product->branch_id,$product->id]) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }}">@lang('general.lbl_edit')</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            <a onclick="showConfirm( '{{ $product->branch_id }}','{{ $product->id }}','{{ $product->product_name }}' )" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">@lang('general.lbl_delete')</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('servicesprice.search') }}" method="GET">   
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
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
        </div>

    </div>
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

          
          $(document).ready(function () {
                $('#example').DataTable();
            });

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

        function showConfirm(branch_id,product_id,data){
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
                var url = "{{ route('servicesprice.destroy',['XX','YY']) }}";
                var lastvalurl = "XX";
                var lastvalurl2 = "YY";
                console.log(url);
                url = url.replace(lastvalurl, branch_id)
                url = url.replace(lastvalurl2, product_id)
                const res = axios.delete(url, {}, {
                    headers: {
                        // Overwrite Axios's automatically set Content-Type
                        'Content-Type': 'application/json'
                    }
                    }).then(resp => {
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
                                    window.location.href = "{{ route('servicesprice.index') }}"; 
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
                            }
                            );
                        }
                    });
            }
            })
        }
    </script>
@endpush