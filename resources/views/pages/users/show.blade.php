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
            <a href="#tab_employee_info" data-bs-toggle="tab" class="nav-link active"><span class="fas fa-user-tie"></span> Employee Info</a>
          </li>
          <li class="nav-item">
            <a href="#tab_personal_info" data-bs-toggle="tab" class="nav-link"><span class="fas fa-user"></span> Personal Info</a>
          </li>
          <li class="nav-item">
            <a href="#tab_contact" data-bs-toggle="tab" class="nav-link"><span class="fas fa-id-card"></span> Contact</a>
          </li>
          <li class="nav-item">
            <a href="#tab_account" data-bs-toggle="tab" class="nav-link"><span class="fas fa-lock"></span> Account</a>
          </li>
          <li class="nav-item">
            <a href="#tab_training" data-bs-toggle="tab" class="nav-link"><span class="fas fa-clock-rotate-left"></span> Training & Skill</a>
          </li>
          <li class="nav-item">
            <a href="#tab_history" data-bs-toggle="tab" class="nav-link"><span class="fas fa-clock-rotate-left"></span> Work History</a>
          </li>
          <li class="nav-item">
            <a href="#tab_experience" data-bs-toggle="tab" class="nav-link"><span class="fas fa-user-clock"></span> Work Experience</a>
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
                <label class="form-label col-form-label col-md-2">Employee Status</label>
                <div class="col-md-8">
                  <select class="form-control" 
                      name="employee_status" disabled>
                      <option value="">Select Employee Status</option>
                      @foreach($employeestatusx as $employee_status)
                          <option value="{{ $employee_status }}" {{ ($employee_status==$users->employee_status ) 
                            ? 'selected'
                            : '' }}>{{ $employee_status }}</option>
                      @endforeach
                  </select>
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->branch_name }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Department</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->department }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Tgl Join</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ \Carbon\Carbon::parse($users->join_date)->format('d-m-Y') }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Join @lang('general.lbl_years')</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->join_years }}" readonly />
                </div>
              </div>

              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Tahun Bekerja *</label>
                <div class="col-md-8">
                  <input type="number" 
                  name="work_year"
                  id="work_year"
                  class="form-control" 
                  value="{{ $user->work_year }}" readonly/>
                  @if ($errors->has('work_year'))
                            <span class="text-danger text-left">{{ $errors->first('work_year') }}</span>
                        @endif
                </div>
              </div>

              </div>
            </div>
          </div>
          <div class="tab-pane fade" id="tab_personal_info">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>Personal Info</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Netizen ID</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->netizen_id }}" readonly />
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="form-label col-form-label col-md-2">Netizen ID Photo</label>
                    <div class="col-md-8">
                      <a href="/images/user-files/{{ $users->photo_netizen_id }}" target="_blank"><img src="/images/user-files/{{ $users->photo_netizen_id }}" width="200" height="100" class="rounded float-start"></a>
                    </div>
                </div>  
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Gender</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->gender }}" readonly />
                  </div>
                </div>
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Tempat Lahir</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->birth_place }}" readonly />
                  </div>
                </div>
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Tgl Lahir   </label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->birth_date }}" readonly />
                  </div>
                </div>    
              </div>
            </div>
          </div>
          <div class="tab-pane fade" id="tab_contact">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>Contact</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">@lang('general.lbl_address')</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->address }}" readonly />
                  </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_city')</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->city }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">@lang('general.lbl_phoneno')</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->phone_no }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Email</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->email }}" readonly />
                </div>
              </div>
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Referral ID</label>
                  <div class="col-md-8">
                      <select class="form-control" 
                            name="referral_id" readonly>
                            <option value="">Select Referral</option>
                            @foreach($usersReferrals as $usersreferral)
                                <option value="{{ $usersreferral->id }}" {{ ($user->referral_id==$usersreferral->id) 
                                  ? 'selected'
                                  : '' }} >{{  $usersreferral->name }}</option>
                            @endforeach
                        </select>
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

          <div class="tab-pane fade" id="tab_training">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>Training & Skill</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <div class="col-md-2">
                    <label class="form-label col-form-label">@lang('general.lbl_dated_mmddYYYY')</label>
                    <input type="text" 
                    name="input_date"
                    id="input_date"
                    class="form-control" 
                    value="{{ old('input_date') }}" required/>
                    @if ($errors->has('input_date'))
                              <span class="text-danger text-left">{{ $errors->first('input_date') }}</span>
                          @endif
                  </div>

                  <div class="col-md-2">
                    <label class="form-label col-form-label">Module</label>
                    <select class="form-control" 
                          name="input_module" id="input_module" required>
                          <option value="">Select Module</option>
                          @foreach($products as $product)
                              <option value="{{ $product->id }}">{{ $product->remark }}</option>
                          @endforeach
                      </select>
                  </div>
                  
                  <div class="col-md-2">
                    <label class="form-label col-form-label">Trainer</label>
                    <select class="form-control" 
                          name="input_trainer" id="input_trainer" required>
                          <option value="">Select Trainer</option>
                          @foreach($userTrainers as $userTrainer)
                              <option value="{{ $userTrainer->id }}">{{ $userTrainer->name }}</option>
                          @endforeach
                      </select>
                  </div>

                  <div class="col-md-2">
                    <label class="form-label col-form-label">Status</label>
                    <select class="form-control" 
                          name="input_status" id="input_status" required>
                          <option value="">Select Status</option>
                          @foreach($status as $stat)
                              <option value="{{ $stat }}">{{ $stat }}</option>
                          @endforeach
                      </select>
                  </div>

                  <div class="col-md-2">
                    <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
                    <input id="input_user_id" value="{{ $user->id }}" type="hidden">
                    <a href="#" id="input_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>Add Training</div></a>
                  </div>



                  <div class="col-md-12">
                    <table class="table table-striped" id="example">
                        <thead>
                        <tr>
                            <th scope="col" width="10%">Training Date</th>
                            <th scope="col">Title</th>
                            <th scope="col" width="10%">Trainer</th>
                            <th scope="col" width="15%">Status</th> 
                        </tr>
                        </thead>
                        <tbody>            
                          @foreach($userSkills as $userSkill)
                            <tr>
                                <th scope="row">{{ $userSkill->dated }}</th>
                                <td>{{ $userSkill->remark }}</td>
                                <td>{{ $userSkill->name }}</td>
                                <td>{{ $userSkill->status }}</td>
                                <td><a href="#" onclick="deleteTraining('{{ $userSkill->dated }}',{{ $user->id}},{{ $userSkill->product_id }},'{{ $userSkill->status }}');" class="btn btn-danger btn-sm">@lang('general.lbl_delete')</a></td>
                            </tr>
                        @endforeach
                        </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>


          <div class="tab-pane fade" id="tab_experience">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>Work Experience</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <div class="col-md-2">
                    <label class="form-label col-form-label">Job Positions</label>
                    <input type="text" 
                    name="input_exp_job"
                    id="input_exp_job"
                    class="form-control" 
                    value="{{ old('input_exp_job') }}" required/>
                    @if ($errors->has('input_exp_job'))
                              <span class="text-danger text-left">{{ $errors->first('input_exp_job') }}</span>
                          @endif
                  </div>

                  <div class="col-md-2">
                    <label class="form-label col-form-label">Company</label>
                    <input type="text" 
                    name="input_exp_company"
                    id="input_exp_company"
                    class="form-control" 
                    value="{{ old('input_exp_company') }}" required/>
                    @if ($errors->has('input_exp_company'))
                              <span class="text-danger text-left">{{ $errors->first('input_exp_company') }}</span>
                          @endif
                  </div>

                  <div class="col-md-2">
                    <label class="form-label col-form-label">@lang('general.lbl_years')</label>
                    <input type="text" 
                    name="input_exp_years"
                    id="input_exp_years"
                    class="form-control" 
                    value="{{ old('input_exp_years') }}" required/>
                    @if ($errors->has('input_exp_years'))
                              <span class="text-danger text-left">{{ $errors->first('input_exp_years') }}</span>
                          @endif
                  </div>

                  <div class="col-md-2">
                    <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
                    <a href="#" id="input_exp_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>Add Experience</div></a>
                  </div>



                  <div class="col-md-12">
                    <table class="table table-striped" id="example">
                        <thead>
                        <tr>
                            <th scope="col" width="10%">Job Position</th>
                            <th scope="col">Company</th>
                            <th scope="col" width="10%">Years</th>
                            <th scope="col" width="10%">Action</th>
                        </tr>
                        </thead>
                        <tbody>            
                          @foreach($userExperiences as $userExperience)
                            <tr>
                                <th scope="row">{{ $userExperience->job_position }}</th>
                                <td>{{ $userExperience->company }}</td>
                                <td>{{ $userExperience->years }}</td>
                                <td><a href="#" onclick="deleteExperience({{ $userExperience->id }});" class="btn btn-danger btn-sm">@lang('general.lbl_delete')</a></td>
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
