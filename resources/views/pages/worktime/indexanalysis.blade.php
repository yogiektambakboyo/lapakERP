@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Analisa Kehadiran')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Analisa Kehadiran per Staff</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-12">
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('presence.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <input type="hidden" name="filter_begin_date" value="2022-01-01"><input type="hidden" name="filter_end_date" value="2035-01-01">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.lbl_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">@lang('general.btn_filter')</a></div>   
                    </form>
                </div>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <div class="row mt-2">
            <div class="col-md-2">
                <h4>Nama</h4>
            </div>
            <div class="col-md-4">
                <h4>{{  count($worktime)<=0?'':$worktime[0]->name }}</h4>
            </div>

            <div class="col-md-3">
                <h4>Persentase Kehadiran</h4>
            </div>
            <div class="col-md-3">
                <h4>{{  count($worktime_sum)<=0?'':(number_format(((floatval($worktime_sum[0]->sum))*100)/floatval($worktime_sum[0]->counter),2,",","."))."%" }}</h4>
            </div>

            <div class="col-md-2">
                <h4>Cabang</h4>
            </div>
            <div class="col-md-4">
                <h4>{{  count($worktime)<=0?'':$worktime[0]->branch_name }}</h4>
            </div>

            <div class="col-md-3">
                <h4>Jumlah Izin</h4>
            </div>
            <div class="col-md-3">
                <h4>{{  $leave==null?'':(count($leave)) }}</h4>
            </div>

            <div class="col-md-2">
                <h4>Periode</h4>
            </div>
            <div class="col-md-10">
                <h4>{{  $filter_begin_date.' - '.$filter_end_date }}</h4>
            </div>
        </div>

        <div class="row mt-4">
            <div class="col-md-6">
                <table class="table table-striped" id="example">
                    <thead>
                    <tr>
                        <th>Tgl</th>
                        <th>Jam Presensi</th>
                    </tr>
                    </thead>
                    <tbody>
        
                        @foreach($worktime as $order)
                            <tr>
                                <td data-order="{{ $order->dated }}">{{ $order->dated }}</td>
                                <td>{{ $order->status }}</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
            <div class="col-md-6">
                <table class="table table-striped" id="table_leave">
                    <thead>
                    <tr>
                        <th>Tgl</th>
                        <th>Reason</th>
                    </tr>
                    </thead>
                    <tbody>
        
                        @foreach($leave as $order)
                            <tr>
                                <td  data-order="{{ $order->dated }}">{{ $order->dated }}</td>
                                <td>{{ $order->status }}</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>

        



        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('presenceanalysis.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="">Pilih Cabang Dahulu</option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Staff</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_user_id" id="filter_user_id">
                                <option value="%">Pilih Staff</option>
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
         //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
         
          const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = dd + '/' + mm + '/' + yyyy;
          const formattedNextYear = dd + '/' + mm + '/' + yyyy1;

          $('#filter_begin_date').datepicker({
            dateFormat: 'dd/mm/yy',
              todayHighlight: true,
          });
          $('#filter_begin_date').val(formattedToday);


          $('#filter_end_date').datepicker({
              dateFormat: 'dd/mm/yy',
              todayHighlight: true,
          });
          $('#filter_end_date').val(formattedToday);
    </script>
@endpush

@push('scripts')
<script type="text/javascript">
    let table, table_payment;
    let str_inv = "";
    let list_invoice;
    let list_invoice_init;
    let total_invoice = 0;
    let total_payment = 0;
    let total_charge = 0;
    let total_payment_nominal = 0;
    
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

        $('#table_leave').DataTable(
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


    $('#filter_branch_id').on('change', function(){
        const res = axios.get("{{ route('presenceanalysis.getallstaff') }}", {
            headers: {
                'Content-Type': 'application/json'
            },
            params: {
                branch_id : $('#filter_branch_id').find(':selected').val()
            }
        }).then(resp => {
            if(resp.data.length<=0){
                Swal.fire(
                {
                    position: 'top-end',
                    icon: 'warning',
                    text: 'Data tidak ditemukan',
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                    }
                );
            }else{
                    $("#filter_user_id").find("option").remove();   
                    for (let index = 0; index < resp.data.data.length; index++) {
                        const element = resp.data.data[index];
                        $("#filter_user_id").append(new Option(""+element.name, ""+element.id));
                    }
            }
            
        });
            
    });

</script>
@endpush
