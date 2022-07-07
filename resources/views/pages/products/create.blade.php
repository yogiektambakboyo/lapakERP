@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Users')

@section('content')
<form method="POST" action="{{ route('users.store') }}"  enctype="multipart/form-data">
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Add New User</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
                <button type="submit" class="btn btn-info">Save</button>
                <a href="{{ route('users.index') }}" class="btn btn-default">Cancel</a>
            </div>
          </div>
        </div>
    </br>
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4>Employee Info</h4></div>
          <div class="panel-body bg-white text-black">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Name</label>
                <div class="col-md-8">
                  <input type="text" name="name" class="form-control" value="{{ old('name') }}"  required/>
                </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Employee ID</label>
                <div class="col-md-8">
                  <input type="text" name="employee_id" class="form-control" value="{{ old('employee_id') }}"   required />
                </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Job Title</label>
              <div class="col-md-8">
                <select class="form-control" 
                    name="job_id" required>
                    <option value="">Select Job Title</option>
                    @foreach($jobTitles as $jobTitle)
                        <option value="{{ $jobTitle->id }}">{{ $jobTitle->remark }}</option>
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
                        <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
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
                        <option value="{{ $department->id }}">{{  $department->remark }}</option>
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
              value="{{ old('join_date') }}" required/>
              @if ($errors->has('join_date'))
                        <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                    @endif
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
                value="{{ old('netizen_id') }}"    required/>
                </div>
            </div>
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2">Netizen ID Photo</label>
                <div class="col-md-8">
                  <a href="/images/user-files/ttd.jpeg" target="_blank"><img src="/images/user-files/ttd.jpeg" width="200" height="100" class="rounded float-start" alt="..."></a>
                  <input type="file" 
                  name="{{ old('photo_netizen_id') }}"
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
                        <option value="{{ $value }}">{{ $value }}</option>
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
                value="{{ old('birth_place') }}"    required/>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Birth Date  (mm/dd/yyyy)</label>
              <div class="col-md-8">
                <div class="col-md-8">
                  <input type="text" 
                    name="birth_date"
                    id="datepicker_2"
                    class="form-control" 
                    value="{{ old('birth_date') }}"  required/>
                    @if ($errors->has('birth_date'))
                        <span class="text-danger text-left">{{ $errors->first('birth_date') }}</span>
                    @endif
                </div>
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
                value="{{ old('address') }}"  />
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
              value="{{ old('city') }}"  required/>
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Phone No</label>
            <div class="col-md-8">
              <input type="text" 
              name="phone_no"
              class="form-control" 
              value="{{ old('phone_no') }}"  />
            </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Email</label>
            <div class="col-md-8">
              <input type="text" 
              name="email" required
              class="form-control" 
              value="{{ old('email') }}"  />
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
                          <option value="{{ $usersreferral->id }}" >{{  $usersreferral->name }}</option>
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
                value="{{ old('username') }}"  required/>
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
                            <option value="{{ $role->id }}">{{ $role->name }}</option>
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
                <input type="checkbox" name="active" id="active" value="{{ old('active') }}" > <label for="active">Active</label>
              </div>
            </div>
          </div>
        </div>
    </div>
</form>
@endsection
