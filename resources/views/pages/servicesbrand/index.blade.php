@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Brand')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.brand')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-6">
                    @lang('general.label')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('servicesbrand.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.label_search')" value="{{ $keyword }}"></div>
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('servicesbrand.create') }}" class="btn btn-primary float-right {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="1%">#</th>
                <th>@lang('general.lbl_name')</th>
                <th scope="col" width="2%">@lang('general.lbl_action')</th>   
                <th scope="col" width="2%"></th>  
            </tr>
            </thead>
            <tbody>

                @foreach($brands as $brand)
                    <tr>
                        <th scope="row">{{ $brand->id }}</th>
                        <td>{{ $brand->remark }}</td>
                        <td><a href="{{ route('servicesbrand.edit', $brand->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }}">@lang('general.lbl_edit')</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            {!! Form::open(['method' => 'DELETE','route' => ['servicesbrand.destroy', $brand->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Hapus', ['class' => 'btn btn-danger btn-sm']) !!}
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
    $(document).ready(function () {
        $('#example').DataTable();
    });
</script>
@endpush