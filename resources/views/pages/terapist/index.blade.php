@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Daftar Terapis Cabang')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Daftar Terapis Cabang</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-12">
                    Atur data terapis anda disini
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

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th>No</th>
                <th scope="col" width="14%">@lang('general.lbl_branch')</th>
                <th>Nama</th>
                <th scope="col" width="8%">Alamat</th>
                <th scope="col" width="15%">Jenis Kelamin</th>
                <th scope="col" width="10%">Tgl Bergabung</th>
                <th scope="col" width="10%">Tahun Bergabung</th>
                <th scope="col" width="10%">KTP</th>
                <th scope="col" width="10%">No Handphone</th>
                <th scope="col" width="10%">Tgl Naik Tahun</th>
                <th scope="col" width="10%">Aktifitas Terakhir</th>
                <th scope="col" width="10%">Status Aktif</th>
            </tr>
            </thead>
            <tbody>
                @php
                 $count = 1;   
                @endphp

                @foreach($worktime as $order)
                    <tr>
                        <td>{{ $count++ }}</td>
                        <td>{{ $order->branch_name }}</td>
                        <td>{{ $order->name }}</td>
                        <td>{{ $order->address }}</td>
                        <td>{{ $order->gender }}</td>
                        <td data-order="{{ $order->join_date }}">{{ Carbon\Carbon::parse($order->join_date)->format('d-m-Y') }}</td>
                        <td>{{ $order->work_year }}</td>
                        <td>{{ $order->netizen_id }}</td>
                        <td>{{ $order->phone_no }}</td>
                        <td data-order="{{ $order->level_up_date }}">{{ Carbon\Carbon::parse($order->level_up_date)->format('d-m-Y') }}</td>
                        <td data-order="{{ $order->last_activity }}">{{ Carbon\Carbon::parse($order->last_activity)->format('d-m-Y') }}</td>
                        <td>{{ $order->active=="1"?"Aktif":"Tidak" }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <h1 class="modal-title fs-5" id="staticBackdropLabel">Foto</h1>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  <img id="img_photo" src="" width="400px;" height="500px;" alt="">
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                </div>
              </div>
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
                    <form action="{{ route('listterapist.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="%">@lang('general.lbl_allbranch')</option>
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
         //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
         
         

          
          const myModal = new bootstrap.Modal('#staticBackdrop', {
            keyboard: true
          });

          function showImg(imgfile){
            myModal.show();
          }

        
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
    });

</script>
@endpush
