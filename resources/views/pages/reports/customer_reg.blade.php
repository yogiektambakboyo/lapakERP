@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Reports - Commision Cashier')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_report') - @lang('general.lbl_customer_reg')</h1>
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

        <table class="table table-striped" id="example">
            <thead>
                <tr>
                    <th scope="col" width="6%">@lang('general.lbl_branch')</th>
                    <th scope="col" width="17%">@lang('general.lbl_seller')</th>
                    <th scope="col" width="5%">@lang('general.lbl_id')</th>
                    <th scope="col" width="5%">@lang('general.lbl_name')</th>
                    <th scope="col" width="4%">@lang('general.lbl_address')</th>
                    <th scope="col" width="5%">@lang('general.lbl_phone_no')</th>   
                    <th scope="col" width="12%">@lang('general.lbl_handphone')</th>
                    <th scope="col" width="12%">@lang('general.lbl_city')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_creditlimit')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_longitude')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_latitude')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_email')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_citizenid')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactperson')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactpersonjobpos')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactpersonlevel')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactperson')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_type')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_classification')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_photo')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_notes')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_created_at')</th>    
                </tr>
                </thead>
                <tbody>
    
                    @foreach($report_data as $trip)
                        <tr>
                            <th scope="row">{{ $trip->branch_name }}</th>
                            <th scope="row">{{ $trip->sellername }}</th>
                            <td>{{ $trip->id }}</td>
                            <td>{{ $trip->name }}</td>
                            <td>{{ $trip->address }}</td>
                            <td>{{ $trip->phone_no }}</td>
                            <td>{{ $trip->handphone }}</td>
                            <td>{{ $trip->city }}</td>
                            <td>{{ $trip->credit_limit }}</td>
                            <td>{{ $trip->longitude }}</td>
                            <td>{{ $trip->latitude }}</td>
                            <td>{{ $trip->email }}</td>
                            <td>{{ $trip->citizen_id }}</td>
                            <td>{{ $trip->tax_id }}</td>
                            <td>{{ $trip->contact_person }}</td>
                            <td>{{ $trip->contact_person_job_position }}</td>
                            <td>{{ $trip->contact_person_level }}</td>
                            <td>{{ $trip->type }}</td>
                            <td>{{ $trip->clasification }}</td>
                            <td>{{ $trip->photo }}</td>
                            <td>{{ $trip->notes }}</td>
                            <td>{{ $trip->created_at }}</td>
                        </tr>
                    @endforeach
                </tbody>
        </table>

        <div class="d-flex">
           
        </div>

        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                ...
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                <button type="button" class="btn btn-primary">@lang('general.lbl_apply')</button>
                </div>
            </div>
            </div>
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
                    <form action="{{ route('reports.customer_reg.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                            <input type="hidden" name="export" id="export" value="@lang('general.btn_search')">
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
                    <form action="" method="GET">   
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

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#filter_begin_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_begin_date').val(formattedToday);

          $('#filter_begin_date_in').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_begin_date_in').val(formattedToday);


          $('#filter_end_date_in').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_end_date_in').val(formattedToday);

          var myModal = new bootstrap.Modal(document.getElementById('modal-filter'));
          var myModal2 = new bootstrap.Modal(document.getElementById('modal-filter2'));

          function openDialog(branch_id,dated,shift_id){
            $('#filter_branch_id').val(branch_id);
            $('#filter_shift').val(shift_id);
            $('#filter_begin_date').val(dated.substr(5,2)+"/"+dated.substr(8,2)+"/"+dated.substr(0,4));
            myModal.show();
          }

          function openDialogFilterSearch(command){
            $('#export').val(command);
            myModal2.show();
          }


        $('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');

    </script>
@endpush