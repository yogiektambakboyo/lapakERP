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
                <a href="{{ route('users.index') }}" class="btn btn-default">Back</a>
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
            <a href="#tab_history" data-bs-toggle="tab" class="nav-link"><span class="fas fa-clock-rotate-left"></span> History</a>
          </li>
        </ul>
        <div class="tab-content panel p-3 rounded-0 rounded-bottom">
          <div class="tab-pane fade active show" id="tab_employee_info">
            <div class="panel text-white">
              <div class="panel-heading bg-teal-600"><h4>Employee Info</h4></div>
              <div class="panel-body bg-white text-black">
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Job Title</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->job_title }}" readonly />
                  </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Branch</label>
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
                <label class="form-label col-form-label col-md-2">Join Date  (mm/dd/YYYY)</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ \Carbon\Carbon::parse($users->join_date)->format('d/m/Y') }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Join Years</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->join_years }}" readonly />
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
                  <label class="form-label col-form-label col-md-2">Birth Place</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->birth_place }}" readonly />
                  </div>
                </div>
                <div class="row mb-3">
                  <label class="form-label col-form-label col-md-2">Birth Date</label>
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
                  <label class="form-label col-form-label col-md-2">Address</label>
                  <div class="col-md-8">
                    <input type="text" class="form-control" value="{{ $users->address }}" readonly />
                  </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">City</label>
                <div class="col-md-8">
                  <input type="text" class="form-control" value="{{ $users->city }}" readonly />
                </div>
              </div>
              <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Phone No</label>
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
                            <th>Branch</th>
                            <th scope="col" width="10%">Department</th>
                            <th scope="col" width="20%">Job Title</th>
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
