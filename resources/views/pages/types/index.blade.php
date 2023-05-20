@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Branchs')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_type')</h2>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('types.create') }}" class="btn btn-primary btn-sm float-right"><span class="fa fa-plus-circle"></span> @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th scope="col" width="15%">@lang('general.lbl_name')</th>
                <th scope="col" colspan="3" width="1%" class="nex"></th> 
            </tr>
            </thead>
            <tbody>
                @foreach($types as $type)
                    <tr>
                        <th>{{ $type->id }}</th>
                        <td>{{ $type->remark }}</td>
                        <td><a href="{{ route('types.edit', $type->id) }}" class="btn btn-info btn-sm">@lang('general.lbl_edit')</a></td>
                        <td>
                            {!! Form::open(['method' => 'DELETE','route' => ['types.destroy', $type->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Hapus', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $types->links() !!}
        </div>

    </div>
@endsection
