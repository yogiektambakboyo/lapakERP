@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Profile Users')

@section('content')
<form method="post" action="{{ route('users.update', $user->id) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Profile User #{{ $user->id }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <button type="submit" class="btn btn-info">Update</button>
                <a href="{{ route('users.index') }}" class="btn btn-default">Cancel</a>
            </div>
          </div>
        </div>
        <div class="lead">

          <div class="row">
            <div class="col-md-1">
               <!-- begin widget-img -->
                <div class="widget-img rounded bg-dark widget-img-xl" style="background-image: url(/assets/img/user/{{ $user->photo }})"></div>
              <!-- end widget-img -->
            </div>
            <div class="col-md-11">
                <label class="col-md-8"><span class="badge bg-primary">{{ $user->employee_id }}</span></label>
                <label class="col-md-8"><h1 class="display-4">{{ $user->name }}</h1></label>
            </div>
          </div>
            
        </div>


        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Employee Info</h4></div>
          <div class="panel-body bg-white text-black">
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Name</label>
                <div class="col-md-8">
                  <input type="text" name="name" class="form-control" value="{{ $user->name }}"  />
                </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Job Title</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="job_id" required>
                    <option value="">Select Job Title</option>
                    @foreach($jobTitles as $jobTitle)
                        <option value="{{ $jobTitle->id }}"
                            {{ ($user->job_title == $jobTitle->remark) 
                                ? 'selected'
                                : '' }}>{{ $jobTitle->remark }}</option>
                    @endforeach
                </select>
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Branch</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="branch_id" required>
                    <option value="">Select Branch</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"
                            {{ ($user->branch_name==$branch->remark) 
                                ? 'selected'
                                : '' }}>{{  $branch->remark }}</option>
                    @endforeach
                </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Department</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="department_id" required>
                    <option value="">Select Department</option>
                    @foreach($departments as $department)
                        <option value="{{ $department->id }}" {{ ($user->department==$department->remark) 
                          ? 'selected'
                          : '' }} >{{  $department->remark }}</option>
                    @endforeach
                </select>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Join Date (mm/dd/YYYY)</label>
            <div class="col-md-8">
              <input type="text" 
              name="join_date"
              id="datepicker"
              class="form-control" 
              value="{{ \Carbon\Carbon::parse($user->join_date)->format('d/m/Y') }}"  required/>
              @if ($errors->has('join_date'))
                        <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                    @endif
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Join Years</label>
            <div class="col-md-8">
              <input type="text" name="join_years" class="form-control" value="{{ $user->join_years }}"  readonly/>
            </div>
          </div>
          </div>
        </div>

        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Personal Info</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Netizen ID</label>
              <div class="col-md-8">
                <input type="text" 
                name="netizen_id"
                class="form-control" 
                value="{{ $user->netizen_id }}"  />
                </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Netizen ID Photo</label>
                <div class="col-md-8">
                  <a href="/images/user-files/{{ $user->photo_netizen_id }}" target="_blank"><img src="/images/user-files/{{ $user->photo_netizen_id }}" width="200" height="100" class="rounded float-start" alt="..."></a>
                  <input type="file" 
                  name="photo_netizen_ids"
                  class="form-control"  />
                  <span></span>
                </div>
            </div>  
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Gender</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="gender" required>
                    <option value="">Select Gender</option>
                    @foreach($gender as $value)
                        <option value="{{ $value }}"
                            {{ $user->gender == $value 
                                ? 'selected'
                                : '' }}>{{ $value }}</option>
                    @endforeach
                </select>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Birth Place</label>
              <div class="col-md-8">
                <input type="text" 
                name="birth_place"
                class="form-control" 
                value="{{ $user->birth_place }}"  />
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Birth Date (mm/dd/yyyy)</label>
              <div class="col-md-8">
                <input type="text" 
                  name="birth_date"
                  id="datepicker_2"
                  class="form-control" 
                  value="{{ \Carbon\Carbon::parse($user->birth_date)->format('d/m/Y') }}"  required/>
                  @if ($errors->has('birth_date'))
                      <span class="text-danger text-left">{{ $errors->first('birth_date') }}</span>
                  @endif
              </div>
            </div>    
          </div>
        </div>

        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Contact</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Address</label>
              <div class="col-md-8">
                <input type="text" 
                name="address" required
                class="form-control" 
                value="{{ $user->address }}"  />
                @if ($errors->has('address'))
                <span class="text-danger text-left">{{ $errors->first('address') }}</span>
              @endif
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">City</label>
            <div class="col-md-8">
              <input type="text" 
              name="city"
              class="form-control" 
              value="{{ $user->city }}"  />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Phone No</label>
            <div class="col-md-8">
              <input type="text" 
              name="phone_no"
              class="form-control" 
              value="{{ $user->phone_no }}"  />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Email</label>
            <div class="col-md-8">
              <input type="text" 
              name="email" required
              class="form-control" 
              value="{{ $user->email }}"  />
              @if ($errors->has('email'))
                <span class="text-danger text-left">{{ $errors->first('email') }}</span>
              @endif
            </div>
          </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Referral ID</label>
              <div class="col-md-8">
                <select class="form-control" 
                      name="referral_id" required>
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

        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Account</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">User Name</label>
              <div class="col-md-8">
                <input type="text" 
                class="form-control"
                name="username" 
                value="{{ $user->username }}"  required/>
                @if ($errors->has('username'))
                    <span class="text-danger text-left">{{ $errors->first('username') }}</span>
                @endif
              </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">App Accesss</label>
                <div class="col-md-8">
                    <select class="form-control" 
                        name="role" required>
                        <option value="">Select role</option>
                        @foreach($roles as $role)
                            <option value="{{ $role->id }}"
                                {{ in_array($role->name, $userRole) 
                                    ? 'selected'
                                    : '' }}>{{ $role->name }}</option>
                        @endforeach
                    </select>
                    @if ($errors->has('role'))
                        <span class="text-danger text-left">{{ $errors->first('role') }}</span>
                    @endif
                </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Status</label>
              <div class="col-md-8">
                <input type="checkbox" name="active" id="active" value="{{ $user->active }}" {{ $user->active==1 ? 'checked' : ''  }} > <label for="active">Active</label>
              </div>
            </div>
          </div>
        </div>
    </div>
</form>
@endsection
