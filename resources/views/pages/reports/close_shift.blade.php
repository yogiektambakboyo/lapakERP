@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Laporan - Serah Terima')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Laporan - Serah Terima</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-8">
                    @lang('general.lbl_title')
                </div>
                <div class="col-md-10"> 	
                        <button onclick="openDialogFilterSearch('Filter');" class="btn btn-sm btn-lime">@lang('general.btn_filter')</button> 
                        <button onclick="openDialogFilterSearch('Export Excel');" class="btn btn-sm btn-success">Export</button>  
                </div>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped nowrap" id="example">
            <thead>
            <tr>
                <th scope="col" width="2%" class="nex">@lang('general.lbl_action')</th> 
                <th scope="col" width="2%" class="nex">@lang('general.lbl_action')</th> 
                <th scope="col" width="10%">@lang('general.lbl_branch')</th>
                <th scope="col" width="6%">@lang('general.lbl_dated')</th>
                <th>Shift</th>
                <th scope="col">@lang('general.service')</th>     
                <th scope="col">Salon</th>     
                <th scope="col">@lang('general.product')</th>    
                <th scope="col">@lang('general.lbl_drink')</th>     
                <th scope="col">Extra</th>    
                <th scope="col">Charge Lebaran</th>    
                <th scope="col">Total</th>    
                <th scope="col">@lang('general.lbl_cash')</th>     
                <th scope="col">BCA D</th>    
                <th scope="col">BCA K</th>    
                <th scope="col">Mandiri D</th>    
                <th scope="col">Mandiri K</th> 
                <th scope="col">QRIS</th> 
                <th scope="col">Transfer</th> 

                <th scope="col">B1-D</th> 
                <th scope="col">B1-K</th>
                <th scope="col">B2-D</th> 
                <th scope="col">B2-K</th>
                <th scope="col">B1-TRF</th> 
                <th scope="col">B2-TRF</th> 
                <th scope="col">B1-QRIS</th> 
                <th scope="col">B2-QRIS</th>
                
                <th scope="col">#SPK</th> 
                <th scope="col">#Tamu</th>  
            </tr>
            </thead>
            <tbody>

                @foreach($report_data as $rdata)
                    <tr>
                        <td><button onclick="openDialog('{{ $rdata->branch_id }}','{{ $rdata->dated }}','{{ $rdata->shift_id }}');" class="btn btn-warning btn-sm">Print</button></td>
                        <td><button onclick="openDialog2('{{ $rdata->branch_id }}','{{ $rdata->dated }}','{{ $rdata->shift_id }}');" class="btn btn-primary btn-sm">Print w/ CL</button></td>
                        <th scope="row">{{ $rdata->branch_name }}</th>
                        <td>{{ Carbon\Carbon::parse($rdata->dated)->format('d-m-Y') }}</td>
                        <td>{{ $rdata->shift_name }}</td>
                        <td>{{ number_format($rdata->total_service_no_cl,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_salon_no_cl,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_product,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_drink,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_extra,0,',','.') }}</td>
                        <td>{{ number_format(($rdata->total_lebaran_cl+$rdata->total_lebaran),0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_all,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_cash,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b_d,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b_k,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_m_d,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_m_k,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_qr,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_tr,0,',','.') }}</td>

                        <td>{{ number_format($rdata->total_b1d,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b1c,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b2d,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b2c,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b1t,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b2t,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b1q,0,',','.') }}</td>
                        <td>{{ number_format($rdata->total_b2q,0,',','.') }}</td>
                        <td>{{ number_format($rdata->qty_transaction,0,',','.') }}</td>
                        <td>{{ number_format($rdata->qty_customers,0,',','.') }}</td>
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
                    <form action="{{ route('reports.closeshift.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id_in" id="filter_branch_id_in">
                                <option value="%">-- All -- </option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
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


                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Shift</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                            name="filter_shift_in" id="filter_shift_in">
                            <option value="%">-- All -- </option>
                            @foreach($shifts as $shift)
                                <option value="{{ $shift->id }}">{{ $shift->remark }} ( {{ $shift->time_start }} - {{ $shift->time_end }}) </option>
                            @endforeach
                        </select>
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" data-bs-dismiss="modal"  class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
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
                    <form target="_blank" action="{{ route('reports.closeshift.getdata') }}" method="GET">   
                        @csrf 
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id" hidden>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12">
                            Apakah anda yakin akan mencetak laporan serah terima?
                        </div>
                        <div class="col-md-12">
                            <input type="hidden" name="filter_type" value="view">
                            <input type="text" 
                            name="filter_begin_date"
                            id="filter_begin_date"
                            class="form-control" 
                            value="{{ old('filter_begin_date') }}" required hidden/>
                            @if ($errors->has('filter_begin_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date') }}</span>
                                @endif
                        </div>

                       
                        <div class="col-md-12">
                            <select class="form-control" hidden 
                            name="filter_shift" id="filter_shift">
                            @foreach($shifts as $shift)
                                <option value="{{ $shift->id }}">{{ $shift->remark }} ( {{ $shift->time_start }} - {{ $shift->time_end }}) </option>
                            @endforeach
                        </select>
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" data-bs-dismiss="modal"  class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
        </div>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter-cl" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">Konfirmasi</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form target="_blank" action="{{ route('reports.closeshift.getdata') }}" method="GET">   
                        @csrf 
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id_cl" id="filter_branch_id_cl" hidden>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12">
                            Apakah anda yakin akan mencetak laporan serah terima?
                        </div>
                        <div class="col-md-12">
                            <input type="hidden" name="filter_type" value="cl">
                            <input type="text" 
                            name="filter_begin_date_cl"
                            id="filter_begin_date_cl"
                            class="form-control" 
                            value="{{ old('filter_begin_date') }}" required hidden/>
                            @if ($errors->has('filter_begin_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date') }}</span>
                                @endif
                        </div>

                       
                        <div class="col-md-12">
                            <select class="form-control" hidden 
                            name="filter_shift_cl" id="filter_shift_cl">
                            @foreach($shifts as $shift)
                                <option value="{{ $shift->id }}">{{ $shift->remark }} ( {{ $shift->time_start }} - {{ $shift->time_end }}) </option>
                            @endforeach
                        </select>
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" data-bs-dismiss="modal"  class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
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
          var myModalCL = new bootstrap.Modal(document.getElementById('modal-filter-cl'));

          function openDialog(branch_id,dated,shift_id){
            $('#filter_branch_id').val(branch_id);
            $('#filter_shift').val(shift_id);
            $('#filter_begin_date').val(dated.substr(5,2)+"/"+dated.substr(8,2)+"/"+dated.substr(0,4));
            //$('#filter_branch_id').prop('disabled', true);
            //$('#filter_shift').prop('disabled', true);
            //$('#filter_begin_date').prop('disabled', true);
            myModal.show();
          }

          function openDialog2(branch_id,dated,shift_id){
            $('#filter_branch_id_cl').val(branch_id);
            $('#filter_shift_cl').val(shift_id);
            $('#filter_begin_date_cl').val(dated.substr(5,2)+"/"+dated.substr(8,2)+"/"+dated.substr(0,4));
            //$('#filter_branch_id').prop('disabled', true);
            //$('#filter_shift').prop('disabled', true);
            //$('#filter_begin_date').prop('disabled', true);
            myModalCL.show();
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
        $('#example').DataTable({
            "scrollX": true
        });
    });
</script>
@endpush