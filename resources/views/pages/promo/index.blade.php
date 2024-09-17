@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Promo')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_promo')</h1>
        <div class="lead row mb-3">
            <div class="col-md-12">
                <div class="col-md-12">
                    @lang('general.lbl_title_transaction')
                </div>
                <div class="col-md-10"> 	
                </div>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="table_view">
            <thead>
            <tr>
                <th>@lang('general.lbl_doc_no')</th>
                <th scope="col" width="20%">@lang('general.lbl_remark')</th>
                <th scope="col" width="20%">@lang('general.lbl_product')</th>
                <th scope="col" width="12%">@lang('general.lbl_dated_start')</th>
                <th scope="col" width="12%">@lang('general.lbl_dated_end')</th>
                <th scope="col" width="2%">@lang('general.lbl_action')</th>  
            </tr>
            </thead>
            <tbody>

                @foreach($orders as $order)
                    <tr>
                        <td>{{ $order->doc_no }}</td>
                        <td>{{ $order->remark }}</td>
                        <td>{{ $order->product_name }}</td>
                        <td>{{ substr(explode(" ",$order->dated_start)[0],8,2) }}-{{ substr(explode(" ",$order->dated_start)[0],5,2) }}-{{ substr(explode(" ",$order->dated_start)[0],0,4) }}</td>
                        <td>{{ substr(explode(" ",$order->dated_end)[0],8,2) }}-{{ substr(explode(" ",$order->dated_end)[0],5,2) }}-{{ substr(explode(" ",$order->dated_end)[0],0,4) }}</td>
                        <td><a href="{{ route('lotnumber.show', $order->id) }}" class="btn btn-warning btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_show')</a></td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    </div>
@endsection


@push('scripts')
    <script type="text/javascript">
          const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          let table;
            $(document).ready(function () {
                table = $('#table_view').DataTable({
                });
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
            confirmButtonText: "@lang('general.lbl_sure_delete')"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('orders.destroy','XX') }}";
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
                                            window.location.href = "{{ route('orders.index') }}"; 
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
