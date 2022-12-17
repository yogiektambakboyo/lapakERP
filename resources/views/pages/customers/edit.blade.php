@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit Customer</h2>
        <div class="lead">
            Editing Customer.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('customers.update', $customer->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">Name</label>
                    <input value="{{ $customer->name }}" 
                        type="text" 
                        class="form-control" 
                        name="name" 
                        placeholder="Name" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">Address</label>
                    <input value="{{ $customer->address }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="Address" required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">Phone No</label>
                    <input value="{{ $customer->phone_no }}" 
                        type="text" 
                        class="form-control" 
                        name="phone_no" 
                        placeholder="Phone No" required>

                    @if ($errors->has('phone_no'))
                        <span class="text-danger text-left">{{ $errors->first('phone_no') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}"  @if($branch->id == $customer->branch_id) selected @endif>{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>
           
                <button type="submit" class="btn btn-primary">Save customer</button>
                <a href="{{ route('customers.index') }}" class="btn btn-default">Back</a>
            </form>
        </div>

    </div>
@endsection