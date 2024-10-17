@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Profile Users')

@section('content')
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Profile User #{{ $user->id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <a href="{{ route('users.edit', $user->id) }}" class="btn btn-info">Edit</a>
                <a href="{{ route('users.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </div>
          </div>
        </div>
        <div class="lead">

          <div class="row">
            <div class="col-md-1">
               <!-- begin widget-img -->
                <div class="widget-img rounded widget-img-xl" style="background-image: url(/images/user-files/{{ $users->photo }})"></div>
              <!-- end widget-img -->
            </div>
            <div class="col-md-11">
                <label class="col-md-8"><span class="badge bg-primary">{{ $users->employee_id }}</span></label>
                <label class="col-md-8"><h1 class="display-4">{{ $users->name }}</h1></label>
            </div>
          </div>
            
        </div>

        <ul class="nav nav-tabs">
          <li class="nav-item">
            <a href="#tab_employee_info" data-bs-toggle="tab" class="nav-link active"><span class="fas fa-user-tie"></span>@lang('user.lbl_employee_info')</a>
          </li>
          <li class="nav-item">
            <a href="#tab_account" data-bs-toggle="tab" class="nav-link"><span class="fas fa-lock"></span> @lang('user.lbl_account')</a>
          </li>
          
        </ul>
        <div class="tab-content panel p-3 rounded-0 rounded-bottom">
          <div class="tab-pane fade active show" id="tab_employee_info">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>Employee Info</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">@lang('general.lbl_jobtitleselect')</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->job_title }}" readonly />
                  </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->branch_name }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Email</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->email }}" readonly />
                </div>
              </div>

              </div>
            </div>
          </div>
         
          <div class="tab-pane fade" id="tab_account">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>Account</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">User Name</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $user->username }}" readonly />
                  </div>
                </div>
                <div class="row mb-3">
                    <label class="form-label col-form-label col-md-2">App Accesss</label>
                    <div class="col-md-8">
                        @foreach($user->roles as $role)
                            <span class="badge bg-primary">{{ $role->name }}</span>
                        @endforeach
                    </div>
                </div>
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Active</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $user->active }}" readonly />
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="tab-pane fade" id="tab_history">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>History</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <div class="col-md-12">
                    <table class="table table-striped" id="example">
                        <thead>
                        <tr>
                            <th>@lang('general.lbl_branch')</th>
                            <th scope="col" width="10%">Department</th>
                            <th scope="col" width="20%">@lang('general.lbl_jobtitle')</th> 
                            <th scope="col" width="15%">Date</th> 
                        </tr>
                        </thead>
                        <tbody>
            
                            @foreach($usersMutations as $usersmutation)
                                <tr>
                                    <td>{{ $usersmutation->branch_name }}</td>
                                    <td>{{ $usersmutation->department_name }}</td>
                                    <td>{{ $usersmutation->job_name }}</td>
                                    <td>{{ $usersmutation->created_at }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                  </div>
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

          $('#input_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#input_date').val(formattedToday);


          $('#input_submit').on('click',function(){
          if($('#input_date').val()==''){
            $('#input_date').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose date',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#supplier_id').val()==''){
            $('#supplier_id').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose supplier',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#input_module').val()==''){
            $('#input_module').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose module',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#input_trainer').val()==''){
            $('#input_trainer').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose trainer',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#input_status').val()==''){
            $('#input_status').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose status',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{
            const json = JSON.stringify({
                status : $('#input_status').val(),
                trainer : $('#input_trainer').val(),
                module : $('#input_module').val(),
                dated : $('#input_date').val(),
                user_id : $('#input_user_id').val(),
              }
            );
            const res = axios.post("{{ route('users.addtraining') }}", json, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.href = "{{ route('users.show', $user->id) }}"; 
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
                      }
                    );
                  }
            });
          }
        });


        $('#input_exp_submit').on('click',function(){
          if($('#input_exp_company').val()==''){
            $('#input_exp_company').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please fill company',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#input_exp_job').val()==''){
            $('#input_exp_job').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please fill job position',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#input_exp_years').val()==''){
            $('#input_exp_years').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please fill years',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{
            const json = JSON.stringify({
                years : $('#input_exp_years').val(),
                company : $('#input_exp_company').val(),
                job_position : $('#input_exp_job').val(),
                user_id : $('#input_user_id').val(),
              }
            );
            const res = axios.post("{{ route('users.addexperience') }}", json, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.href = "{{ route('users.show', $user->id) }}"; 
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
                      }
                    );
                  }
            });
          }
        });


        function deleteTraining(dated,user_id,product_id,status){
            const jsonDelete = JSON.stringify({
                status : status,
                module : product_id,
                dated : dated,
                user_id : user_id,
              }
            );
            const resDelete = axios.post("{{ route('users.deletetraining') }}", jsonDelete, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.href = "{{ route('users.show', $user->id) }}"; 
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
                      }
                    );
                  }
            });
        }

        function deleteExperience(id){
            const jsonDeleteExp = JSON.stringify({
                id : id,
              }
            );
            const resDeleteExp = axios.post("{{ route('users.deleteexperience') }}", jsonDeleteExp, {
              headers: {
                // Overwrite Axios's automatically set Content-Type
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                  if(resp.data.status=="success"){
                    window.location.href = "{{ route('users.show', $user->id) }}"; 
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
                      }
                    );
                  }
            });
        }
    </script>
@endpush
