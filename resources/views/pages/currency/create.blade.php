@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_currency_new')</h2>
        <div class="container mt-4">

            <form method="POST" action="{{ route('currency.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="remark" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ old('remark') }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="@lang('general.lbl_currency_name')" required>

                    @if ($errors->has('remark'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="abbr" class="form-label">@lang('general.lbl_abbr')</label>
                    <input value="{{ old('abbr') }}" 
                        type="text" 
                        class="form-control" 
                        name="abbr" 
                        placeholder="Abbreviation" required>

                    @if ($errors->has('abbr'))
                        <span class="text-danger text-left">{{ $errors->first('abbr') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="abbr" class="form-label">@lang('general.lbl_active')</label>
                    <select name="active" id="active" class="form-select">
                        <option value="1">1</option>
                        <option value="0">0</option>
                    </select>

                    @if ($errors->has('active'))
                        <span class="text-danger text-left">{{ $errors->first('active') }}</span>
                    @endif
                </div>

                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('currency.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection