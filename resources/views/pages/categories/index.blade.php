@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Kategori')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_category')</h2>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('categories.create') }}" class="btn btn-primary btn-sm float-right"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped"  id="example">
            <thead>
            <tr>
                <th scope="col">@lang('general.lbl_name')</th>
                <th scope="col" width="15%">Jenis</th>
                <th scope="col" width="10%">Poin</th>
                <th scope="col" width="1%" class="nex"></th> 
                <th scope="col" width="1%" class="nex"></th> 
            </tr>
            </thead>
            <tbody>
                @foreach($categories as $category)
                    <tr>
                        <td>{{ $category->remark }}</td>
                        <td>{{ $category->add_colum }}</td>
                        <td>{{ $category->add_column_2 }}</td>
                        <td><a href="{{ route('categories.edit', $category->id) }}" class="btn btn-info btn-sm">@lang('general.lbl_edit')</a></td>
                        <td>
                            {!! Form::open(['method' => 'DELETE','route' => ['categories.destroy', $category->id],'style'=>'display:inline']) !!}
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
        $('#example').DataTable(
            {
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copyHtml5',
                        exportOptions: {
                            columns: ':not(.nex)'
                        }
                    },
                    {
                        extend: 'excelHtml5',
                        exportOptions: {
                            columns: ':not(.nex)'
                        }
                    }
                ]
            }
        );
    });
</script>
@endpush