@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Products Commision PIC')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_commision') Khusus</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-4">
                    @lang('general.lbl_title')
                </div>
                <div class="col-md-10"> 	
                    {{-- <form action="{{ route('productscommision_ex.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.lbl_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                    </form> --}}
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('productscommision_ex.create') }}" class="btn btn-primary float-right  {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th>@lang('general.lbl_name') Barang</th>
                <th scope="col" width="15%">@lang('general.lbl_branch')</th>
                <th scope="col" width="10%">Komisi Input Faktur</th>
                <th scope="col" width="10%">@lang('general.lbl_referral_fee')</th>
                <th scope="col" width="10%">Nama</th>
                <th scope="col" width="2%" class="nex">@lang('general.lbl_action')</th>   
                <th scope="col" width="2%" class="nex"></th>  
            </tr>
            </thead>
            <tbody>

                @foreach($products as $product)
                    <tr>
                        <td>{{ $product->product_name }}</td>
                        <td>{{ $product->branch_name }}</td>
                        <td>{{ $product->created_by_fee }}</td>
                        <td>{{ $product->referral_fee }}</td>
                        <td>{{ $product->pic_name }} (ID : {{ $product->users_id }})</td>
                        <td><a href="{{ route('productscommision_ex.edit', [$product->branch_id,$product->id]) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }}">@lang('general.lbl_edit')</a></td>
                        <td class="{{ $act_permission->allow_delete==1?'':'d-none' }}">
                            {!! Form::open(['method' => 'DELETE','route' => ['productscommision_ex.destroy', [$product->branch_id,$product->id]],'style'=>'display:inline']) !!}
                            {!! Form::submit('Hapus', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <!-- Vertically centered modal -->
        <!-- Modal -->
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                ...
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                <button type="button" class="btn btn-primary">@lang('general.lbl_apply')</button>
                </div>
            </div>
            </div>
        </div>

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