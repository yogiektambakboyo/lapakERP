@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Return Invoice')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_return_sell')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-12">
                    @lang('general.lbl_title_transaction')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('returnsell.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <input type="hidden" name="filter_begin_date" value="2022-01-01"><input type="hidden" name="filter_end_date" value="2035-01-01">
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">@lang('general.btn_filter')</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col" width="10%">@lang('general.lbl_branch')</th>
                <th>@lang('general.lbl_return_no')</th>
                <th scope="col" width="8%">@lang('general.lbl_dated')</th>
                <th scope="col" width="15%">@lang('general.lbl_total_customer')</th>
                <th scope="col" width="10%">Total</th>
                <th scope="col" width="10%">@lang('general.lbl_total_discount')</th>
                <th scope="col" width="10%">@lang('general.lbl_total_payment')</th>
                <th scope="col" width="2%">@lang('general.lbl_action')</th>  
                <th scope="col" width="2%"></th>
                <th scope="col" width="2%"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($returnsells as $returnsell)
                    <tr>
                        <th scope="row">{{ $returnsell->id }}</th>
                        <td>{{ $returnsell->branch_name }}</td>
                        <td>{{ $returnsell->invoice_no }}</td>
                        <td>{{ $returnsell->dated }}</td>
                        <td>{{ $returnsell->customer }}</td>
                        <td>{{ number_format($returnsell->total,0,',','.') }}</td>
                        <td>{{ number_format($returnsell->total_discount,0,',','.') }}</td>
                        <td>{{ number_format($returnsell->total_payment,0,',','.') }}</td>
                        <td><a href="{{ route('returnsell.show', $returnsell->id) }}" class="btn btn-warning btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_show')</a></td>
                        <td><a href="{{ route('returnsell.edit', $returnsell->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">@lang('general.lbl_edit')</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            <a onclick="showConfirm({{ $returnsell->id }}, '{{ $returnsell->return_sell_no }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">@lang('general.lbl_delete')</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $returnsells->links() !!}
        </div>

        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('returnsell.search') }}" method="GET">   
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
                    var url = "{{ route('returnsell.destroy','XX') }}";
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
                                            window.location.href = "{{ route('returnsell.index') }}"; 
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
