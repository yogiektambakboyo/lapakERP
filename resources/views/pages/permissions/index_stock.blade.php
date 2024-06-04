@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Lot Number')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Lot Number</h2>
        <div class="lead row mb-3">
            <div class="col-md-12">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
            </div>
            <div class="col-md-8"> 	
                <form action="{{ route('stocklotnumber.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                    <div class="col-12"><input type="text" class="form-control  form-control-lg" name="search" placeholder="@lang('general.lbl_search') . . ." value="{{ $keyword }}"></div>
                    <div class="col-12"><input type="submit" class="btn btn-secondary" value="@lang('general.btn_search')" name="submit"></div>   
                </form>
            </div>
            <div class="col-md-2">
                <a href="{{ route('stocklotnumber.create') }}" class="btn btn-primary btn-sm float-right"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>

        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="10%">No Surat</th>
                <th scope="col" width="5%">SPK ID</th>
                <th scope="col">Lot Number</th>
                <th scope="col">SKU</th>
                <th scope="col" width="5%">Digunakan?</th> 
            </tr>
            </thead>
            <tbody>
                @php $counter=1; @endphp
                @foreach($permissions as $permission)
                    <tr>
                        <th>{{ $permission->no_surat }}</th>
                        <td>{{ $permission->spkid }}</td>
                        <td>{{ $permission->lot_number }}</td>
                        <td>{{ $permission->remark }}</td>
                        <td>{{ $permission->is_used }}</td>
                    </tr>
                @php $counter++; @endphp
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $permissions->links() !!}
        </div>

    </div>
@endsection
