@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Supplier')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Create Supllier</h2>
        <div class="lead">
            Add new Supllier.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('suppliers.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input value="{{ old('name') }}" 
                        type="text" 
                        class="form-control" 
                        name="name" 
                        placeholder="Name" required>

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <input value="{{ old('address') }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="Address" required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">Handphone</label>
                    <input value="{{ old('phone_no') }}" 
                        type="text" 
                        class="form-control" 
                        name="handphone" 
                        placeholder="Handphone" required>

                    @if ($errors->has('phone_no'))
                        <span class="text-danger text-left">{{ $errors->first('handphone') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">Email</label>
                    <input value="{{ old('email') }}" 
                        type="text" 
                        class="form-control" 
                        name="email" 
                        placeholder="Email" required>

                    @if ($errors->has('email'))
                        <span class="text-danger text-left">{{ $errors->first('email') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>
                
                <button type="submit" class="btn btn-primary">Save supplier</button>
                <a href="{{ route('customers.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection