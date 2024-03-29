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

        <table class="table table-striped display nowrap" id="example"  style="width:100%">
            <thead>
                <tr>
                    <th scope="col">@lang('general.lbl_action')</th> 
                    <th scope="col">@lang('general.lbl_branch')</th>
                    <th scope="col">@lang('general.lbl_seller')</th>
                    <th scope="col">@lang('general.lbl_id')</th>
                    <th scope="col">@lang('general.lbl_name')</th>
                    <th scope="col">@lang('general.lbl_address')</th>
                    <th scope="col">@lang('general.lbl_phone_no')</th>   
                    <th scope="col" width="12%">@lang('general.lbl_handphone')</th>
                    <th scope="col" width="12%">@lang('general.lbl_city')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_creditlimit')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_geolocation')</th>     
                    <th scope="col" width="12%">@lang('general.lbl_email')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_citizenid')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactperson')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactpersonjobpos')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactpersonlevel')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_contactperson')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_type')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_classification')</th>       
                    <th scope="col" width="12%">@lang('general.lbl_notes')</th>    
                    <th scope="col" width="12%">@lang('general.lbl_created_at')</th>    
                </tr>
                </thead>
                <tbody>
    
                    @foreach($report_data as $trip)
                        <tr>
                            <td><button  class="btn btn-sm btn-primary" onclick="openDialogImage('{{ $trip->photo }}')" value="Show Photo">Photo</button><button  class="btn btn-sm btn-warning" onclick="openDialogApprove('{{ $trip->id }}','{{ $trip->name }}')" value="Show Photo">Approve</button></td>
                            <th scope="row">{{ $trip->branch_name }}</th>
                            <th scope="row">{{ $trip->sellername }}</th>
                            <td>{{ $trip->id }}</td>
                            <td>{{ $trip->name }}</td>
                            <td>{{ $trip->address }}</td>
                            <td>{{ $trip->phone_no }}</td>
                            <td>{{ $trip->handphone }}</td>
                            <td>{{ $trip->city }}</td>
                            <td>{{ $trip->credit_limit }}</td>
                            <td><a target="_blank" class="btn btn-sm btn-primary" href="http://maps.google.com/maps?q={{ $trip->latitude }},{{ $trip->longitude }}" value="Lihat Peta">Peta</a> {{ $trip->latitude }},{{ $trip->longitude }}</td>
                            <td>{{ $trip->email }}</td>
                            <td>{{ $trip->citizen_id }}</td>
                            <td>{{ $trip->tax_id }}</td>
                            <td>{{ $trip->contact_person }}</td>
                            <td>{{ $trip->contact_person_job_position }}</td>
                            <td>{{ $trip->contact_person_level }}</td>
                            <td>{{ $trip->type }}</td>
                            <td>{{ $trip->clasification }}</td>
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

        <div class="modal fade" id="modal-filterApprove" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"><label id="lbl_title_store"><label></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('reports.customer_reg.approve') }}" method="POST">   
                        @csrf 
                        <div class="row">
                            <div class="col-md-12">
                                <label class="form-label col-form-label col-md-12">@lang('general.lbl_approve_sure')</label>
                                <select class="form-control" 
                                    name="input_approve" id="input_approve">
                                        <option value="1">Approve </option>
                                        <option value="-1">Reject </option>
                                </select>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label col-form-label col-md-12">@lang('general.lbl_notes')</label>
                                <input class="form-control" 
                                    name="input_notes" id="input_notes">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label col-form-label col-md-4">@lang('general.lbl_visit_day')</label>
                                <div class="form-check">
                                    <input class="form-check-input"   name="input_day" type="radio" value="Monday" id="input_day_mon">
                                    <label class="form-check-label" for="input_day_mon">Senin</label>
                                </div>
        
                                <div class="form-check">
                                    <input class="form-check-input"  name="input_day"  type="radio" value="Tuesday" id="input_day_tue">
                                    <label class="form-check-label" for="input_day_tue">Selasa</label>
                                </div>
        
                                <div class="form-check">
                                    <label class="form-check-label" for="input_day_wed">Rabu</label>
                                    <input class="form-check-input"   name="input_day" type="radio" value="Wednesday" id="input_day_wed">
                                </div>
        
                                <div class="form-check">
                                    <input class="form-check-input"  name="input_day"  type="radio" value="Thursday" id="input_day_thu">
                                   <label class="form-check-label" for="input_day_thu">Kamis</label>
                                </div>
        
                                <div class="form-check">
                                    <input class="form-check-input"  name="input_day"  type="radio" value="Friday" id="input_day_fri">
                                    <label class="form-check-label" for="input_day_fri">Jum'at</label>
                                </div>
        
                                <div class="form-check">
                                    <input class="form-check-input"  name="input_day"  type="radio" value="Saturday" id="input_day_sab">
                                    <label class="form-check-label" for="input_day_sab">Sabtu</label>
                                </div>
        
                                <div class="form-check">
                                    <input class="form-check-input"   name="input_day" type="radio" value="Sunday" id="input_day_sun">
                                    <label class="form-check-label" for="input_day_sun">Minggu</label>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label col-form-label col-md-4">@lang('general.lbl_visit_week')</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="1" id="input_week_1">
                                    <label class="form-check-label" for="input_week_1">
                                     Minggu 1
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="2" id="input_week_2">
                                    <label class="form-check-label" for="input_week_2">
                                     Minggu 2
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="3" id="input_week_3">
                                    <label class="form-check-label" for="input_week_3">
                                     Minggu 3
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="4" id="input_week_4">
                                    <label class="form-check-label" for="input_week_4">
                                     Minggu 4
                                    </label>
                                </div>
                            </div>
                        </div>
                        <br>
                        <input type="hidden" id="input_id" name="input_id">
                        <input type="hidden" id="input_week" name="input_week">
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">@lang('general.lbl_save')</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
        </div>

        
        <div class="modal fade" id="modal-filterimg" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog  modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">Gambar</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12 d-flex justify-content-center">
                        <img id="dialog_img" src="" width="600px">
                    </div>
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
          var myModalImg = new bootstrap.Modal(document.getElementById('modal-filterimg'));
          var myModalApprove = new bootstrap.Modal(document.getElementById('modal-filterApprove'));

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

          function openDialogImage(command){
            $('#dialog_img').attr("src", "https://kakikupos.com/images/smd-image/"+command);
            myModalImg.show();
          }

          function openDialogApprove(id, name){
            $('#input_id').val(id);
            $('#lbl_title_store').text(name);
            myModalApprove.show();
          }

          $('#example').DataTable({
                scrollX: true,
        });

        $('#input_day_mon').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_tue').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_wed').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_thu').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_fri').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_sab').on('change', function() {
            $('#input_day').val(this.value);
        });
        $('#input_day_sun').on('change', function() {
            $('#input_day').val(this.value);
        });

        $('#input_week_1').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });
        $('#input_week_2').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });
        $('#input_week_3').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });
        $('#input_week_4').on('change', function() {
            var weekchecked = "";
            if($('#input_week_1').is(':checked')){
                weekchecked = weekchecked + "1";
            }
            if($('#input_week_2').is(':checked')){
                weekchecked = weekchecked + "2";
            }
            if($('#input_week_3').is(':checked')){
                weekchecked = weekchecked + "3";
            }
            if($('#input_week_4').is(':checked')){
                weekchecked = weekchecked + "4";
            }
            $('#input_week').val(weekchecked);
        });



        $('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');

    </script>
@endpush