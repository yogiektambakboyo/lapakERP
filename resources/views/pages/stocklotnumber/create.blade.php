@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Buat Stok Lot Number')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Stok Lot Number</h2>

        <div class="container mt-4">

            <form method="POST" action="{{ route('stocklotnumber.store') }}">
                @csrf
                <div class="mb-3">
                    <label for="spkid" class="form-label">SPK ID *</label>
                    <input value="{{ old('spkid') }}" 
                        type="text" 
                        class="form-control" 
                        name="spkid" 
                        placeholder="SPK ID" required>

                    @if ($errors->has('spkid'))
                        <span class="text-danger text-left">{{ $errors->first('spkid') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label for="lot_number" class="form-label">Lot Number *</label>
                    <input value="{{ old('lot_number') }}" 
                        type="text" 
                        class="form-control" 
                        name="lot_number" 
                        placeholder="@lang('general.lot_number')" required>

                    @if ($errors->has('lot_number'))
                        <span class="text-danger text-left">{{ $errors->first('lot_number') }}</span>
                    @endif
                </div>

                <div class="mb-3">
                    <label class="form-label">SKU *</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="alias_code">
                            <option value="">Silahkan Pilih SKU</option>
                            @foreach($products as $product)
                                <option value="{{ $product->alias_code }}">{{  $product->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                  </div>


                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('stocklotnumber.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection