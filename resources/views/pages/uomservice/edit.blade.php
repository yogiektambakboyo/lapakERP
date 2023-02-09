@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Uoms')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_uomedit')</h2>
        <div class="container mt-4">

            <form method="POST" action="{{ route('uomservice.update', $uom->id) }}">
                @method('patch')
                @csrf
                <div class="mb-3">
                    <label for="name" class="form-label">@lang('general.lbl_name')</label>
                    <input value="{{ $uom->remark }}" 
                        type="text" 
                        class="form-control" 
                        name="remark" 
                        placeholder="Remark" required>

                        <input value="2" 
                        type="hidden" 
                        class="form-control" 
                        name="type_id" >

                    @if ($errors->has('name'))
                        <span class="text-danger text-left">{{ $errors->first('remark') }}</span>
                    @endif
                </div>
                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('uomservice.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </form>
        </div>

    </div>
@endsection