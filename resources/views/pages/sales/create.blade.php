@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Customer')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_seller_new')</h2>


        <div class="container mt-4">

            <form method="POST" action="{{ route('sales.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name') *</label>
                    <input value="{{ old('name') }}" 
                        type="text" 
                        class="form-control" 
                        name="name" 
                        placeholder="@lang('general.lbl_name')" required>

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">@lang('general.lbl_address') *</label>
                    <input value="{{ old('address') }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="@lang('general.lbl_address')" required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="username" class="form-label">@lang('general.lbl_username') *</label>
                    <input value="{{ old('username') }}" 
                        type="text" 
                        class="form-control" 
                        name="username" 
                        placeholder="@lang('general.lbl_username')" required>

                    @if ($errors->has('username'))
                        <span class="text-danger text-left">{{ $errors->first('username') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">@lang('general.lbl_password') * (Minimal 4 karakter tanpa spasi)</label>
                    <input value="{{ old('password') }}" 
                        type="text" 
                        class="form-control" 
                        name="password" 
                        placeholder="@lang('general.lbl_password')" required>

                    @if ($errors->has('password'))
                        <span class="text-danger text-left">{{ $errors->first('password') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch') *</label>
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

                  <div class="mb-3">
                    <label for="external_code" class="form-label">@lang('general.lbl_external_code')</label>
                    <input value="{{ old('external_code') }}" 
                        type="text" 
                        class="form-control" 
                        name="external_code" 
                        placeholder="@lang('general.lbl_external_code')">

                    @if ($errors->has('external_code'))
                        <span class="text-danger text-left">{{ $errors->first('external_code') }}</span>
                    @endif
                </div>
                
                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('sales.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection