@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New UOM')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_add_uom_new')</h2>
        <div class="container mt-4">

            <form method="POST" action="{{ route('uomservice.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="remark" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ old('remark') }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="@lang('general.lbl_name')" required>

                        <input value="2" 
                        type="hidden" 
                        class="form-control" 
                        name="type_id" >

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('uomservice.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </form>
        </div>

    </div>
@endsection