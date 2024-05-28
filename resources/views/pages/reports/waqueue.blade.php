@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Laporan - Pengiriman WA')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_report') - Pengiriman WhatsApp </h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-8">
                    @lang('general.lbl_title')
                </div>
                <div class="col-md-10"> 	
                        <button onclick="openDialogFilterSearch('Filter');" class="btn btn-sm btn-lime">@lang('general.btn_filter')</button> 
                </div>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="12%">Nomor Tujuan</th>
                <th>Pesan</th>
                <th scope="col" width="12%">Link File</th>
                <th scope="col">Status</th>          
                <th scope="col">Created At</th>    
            </tr>
            </thead>
            <tbody>

                @foreach($report_data as $rdata)
                    <tr>
                        <th scope="row">{{ $rdata->whatsapp_no }}</th>
                        <td>{{ $rdata->msg }}</td>
                        <td>{{ $rdata->file_link }}</td>
                        <td>{{ $rdata->is_send }}</td>
                        <td>{{ $rdata->created_at }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
           
        </div>

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
                    <form action="{{ route('reports.invoice.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_date_start')</label>
                        </div>
                        <div class="col-md-12">
                            <input type="hidden" name="export" id="export" value="@lang('general.btn_search')">
                            <input type="text" 
                            name="filter_begin_date_in"
                            id="filter_begin_date_in"
                            class="form-control" 
                            value="{{ old('filter_begin_date_in') }}" required/>
                            @if ($errors->has('filter_begin_date_in'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date_in') }}</span>
                                @endif
                        </div>

                        <div class="col-md-12">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_date_end')</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_end_date_in"
                            id="filter_end_date_in"
                            class="form-control" 
                            value="{{ old('filter_end_date_in') }}" required/>
                            @if ($errors->has('filter_end_date_in'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_end_date_in') }}</span>
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

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">Konfirmasi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('reports.closeshift.getdata') }}" method="GET">   
                        @csrf 
                       
                        <div class="col-md-12">
                            Apakah anda yakin akan mencetak laporan serah terima?
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_begin_date"
                            id="filter_begin_date"
                            class="form-control" 
                            value="{{ old('filter_begin_date') }}" required hidden/>
                            @if ($errors->has('filter_begin_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date') }}</span>
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

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          const formattedNextYear = dd + '-' + mm + '-' + yyyy1;

          $('#filter_begin_date').datepicker({
            dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#filter_begin_date').val(formattedToday);

          $('#filter_begin_date_in').datepicker({
            dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#filter_begin_date_in').val(formattedToday);


          $('#filter_end_date_in').datepicker({
            dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#filter_end_date_in').val(formattedToday);

          var myModal = new bootstrap.Modal(document.getElementById('modal-filter'));
          var myModal2 = new bootstrap.Modal(document.getElementById('modal-filter2'));

          function openDialog(branch_id,dated,shift_id){
            $('#filter_branch_id').val(branch_id);
            $('#filter_shift').val(shift_id);
            $('#filter_begin_date').val(dated.substr(5,2)+"/"+dated.substr(8,2)+"/"+dated.substr(0,4));
            //$('#filter_branch_id').prop('disabled', true);
            //$('#filter_shift').prop('disabled', true);
            //$('#filter_begin_date').prop('disabled', true);
            myModal.show();
          }

          function openDialogFilterSearch(command){
            $('#export').val(command);
            myModal2.show();
          }

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

        //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');

    </script>
@endpush

@push('scripts')
<script type="text/javascript">
    $(document).ready(function () {

        document.addEventListener('DOMContentLoaded', function () {
            let table = new DataTable('#example', {
                dom: 'Bfrtip',
                buttons: [
                        {
                            extend: 'copy',
                            text: 'Copy',
                            className: 'btn btn-default',
                            exportOptions: {
                                columns: ':not(.noexport)'
                            }
                        },
                        {
                            extend: 'csv',
                            text: 'CSV',
                            className: 'btn btn-default',
                            exportOptions: {
                                columns: ':not(.noexport)'
                            }
                        },
                        {
                            extend: 'excel',
                            text: 'Excel',
                            className: 'btn btn-default',
                            exportOptions: {
                                columns: ':not(.noexport)'
                            }
                        },
                        {
                            extend: 'pdf',
                            text: 'PDF',
                            className: 'btn btn-default',
                            exportOptions: {
                                columns: ':not(.noexport)'
                            }
                        },
                ]
            });
        });

    });
</script>
@endpush