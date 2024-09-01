@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Permissions')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>Permissions</h2>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('permissions.create') }}" class="btn btn-primary btn-sm float-right"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>

        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table id="table_view" class="table table-striped nowrap" width="100%">
            <thead>
            <tr>
                <th scope="col" width="80%">@lang('general.lbl_name')</th>
                <th width="7%" scope="col">Guard</th> 
                <th width="3%" colspan="0">@lang('general.lbl_action')</th>
                <th width="3%" colspan="0" class="d-none"></th>
            </tr>
            </thead>
            <tbody>
                @foreach($permissions as $permission)
                    <tr>
                        <td>{{ $permission->name }}</td>
                        <td>{{ $permission->guard_name }}</td>
                        <td><a href="{{ route('permissions.edit', $permission->id) }}" class="btn btn-info btn-sm">@lang('general.lbl_edit')</a></td>
                        <td>
                            {!! Form::open(['method' => 'DELETE','route' => ['permissions.destroy', $permission->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

    </div>
@endsection

@push('scripts')
<script type="text/javascript">
    let table;
    $(document).ready(function () {
        table = $('#table_view').DataTable({
        });
    });
</script>
@endpush
