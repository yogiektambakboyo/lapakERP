@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_edit_seller')</h2>
        <div class="container mt-4">

            <form method="POST" action="{{ route('sales.update', $sales->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ $sales->name }}" 
                        type="text" 
                        class="form-control" 
                        name="name" 
                        placeholder="@lang('general.lbl_name')" required>

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">@lang('general.lbl_address')</label>
                    <input value="{{ $sales->address }}" 
                        type="text" 
                        class="form-control" 
                        name="address" 
                        placeholder="@lang('general.lbl_address')" required>

                    @if ($errors->has('address'))
                        <span class="text-danger text-left">{{ $errors->first('address') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">@lang('general.lbl_username')</label>
                    <input value="{{ $sales->username }}" 
                        type="text" 
                        class="form-control" 
                        name="username" 
                        placeholder="@lang('general.lbl_username')" required>

                    @if ($errors->has('username'))
                        <span class="text-danger text-left">{{ $errors->first('username') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="phone_no" class="form-label">@lang('general.lbl_password')</label>
                    <input value="{{ $sales->password }}" 
                        type="text" 
                        class="form-control" 
                        name="password" 
                        placeholder="@lang('general.lbl_password')" required>

                    @if ($errors->has('password'))
                        <span class="text-danger text-left">{{ $errors->first('password') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}"  @if($branch->id == $sales->branch_id) selected @endif>{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>
           
                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('sales.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection