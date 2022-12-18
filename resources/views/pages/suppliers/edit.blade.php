@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Edit Customer</h2>
        <div class="lead">
            Editing Customer.
        </div>

        <div class="container mt-4">

            <form method="POST" action="{{ route('suppliers.update', $supplier->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ $supplier->name }}" 
                        type="text" 
                        class="form-control" 
                        name="name" 
                        placeholder="Name" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">@lang('general.lbl_address')</label>
                    <input value="{{ $supplier->address }}" 
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
                    <input value="{{ $supplier->handphone }}" 
                        type="text" 
                        class="form-control" 
                        name="handphone" 
                        placeholder="handphone" required>

                    @if ($errors->has('handphone'))
                        <span class="text-danger text-left">{{ $errors->first('handphone') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">Email</label>
                    <input value="{{ $supplier->email }}" 
                        type="text" 
                        class="form-control" 
                        name="email" 
                        placeholder="Email">

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
                                <option value="{{ $branch->id }}"  @if($branch->id == $supplier->branch_id) selected @endif>{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>
           
                <button type="submit" class="btn btn-primary">Save supplier</button>
                <a href="{{ route('suppliers.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection