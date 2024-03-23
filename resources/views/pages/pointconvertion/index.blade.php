@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Konversi Poin')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_point')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('pointconvertion.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.lbl_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('pointconvertion.create') }}" class="btn btn-primary float-right  {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="15%">@lang('general.lbl_branch')</th>
                <th scope="col" width="10%">@lang('general.lbl_point')</th>
                <th scope="col" width="10%">Komisi @lang('general.lbl_point')</th>
                <th scope="col" width="2%" class="nex">@lang('general.lbl_action')</th>   
                <th scope="col" width="2%" class="nex"></th>  
            </tr>
            </thead>
            <tbody>

                @foreach($products as $product)
                    <tr>
                        <td>{{ $product->branch_name }}</td>
                        <td>{{ $product->point }}</td>
                        <td>{{ $product->point_value }}</td>
                        <td><a href="{{ route('pointconvertion.edit', [$product->id]) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }}">@lang('general.lbl_edit')</a></td>
                        <td class="{{ $act_permission->allow_delete==1?'':'d-none' }}">
                            {!! Form::open(['method' => 'DELETE','route' => ['pointconvertion.destroy', [$product->id]],'style'=>'display:inline']) !!}
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