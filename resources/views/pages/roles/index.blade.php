@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Roles')
@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Roles</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('roles.create') }}" class="btn btn-primary btn-sm float-right"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table id="table_view" class="table table-striped nowrap" width="100%">
         <thead>
          <tr>
             <th width="1%">No</th>
             <th width="90%">@lang('general.lbl_name')</th>
             <th width="3%" colspan="0">Action</th>
             <th width="3%" colspan="0" class="d-none"></th>
             <th width="3%" colspan="0" class="d-none"></th>
          </tr>
        </thead> 
        <tbody>
            @foreach ($roles as $key => $role)
            <tr>
                <th>{{ $role->id }}</th>
                <td>{{ $role->name }}</td>
                <td>
                    <a class="btn btn-warning btn-sm" href="{{ route('roles.show', $role->id) }}">Show</a>
                </td>
                <td>
                    <a class="btn btn-info btn-sm" href="{{ route('roles.edit', $role->id) }}">Edit</a>
                </td>
                <td>
                    {!! Form::open(['method' => 'DELETE','route' => ['roles.destroy', $role->id],'style'=>'display:inline']) !!}
                    {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                    {!! Form::close() !!}
                </td>
            </tr>
            @endforeach
        </tbody>
        </table>
    </div>
@endsection

@section('scripts')

