@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Sales Order')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Purchase Order</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-10">
                    Manage your purchase order here, default data display last 7 days ago. Please use filter for show more data.
                </div>
                <br>
                <div class="col-md-8"> 	
                    <form action="{{ route('purchaseorders.search') }}" method="POST" class="row row-cols-lg-auto g-3 align-items-center">
                        @csrf
                        <input type="hidden" name="filter_begin_date" value="2022-01-01"><input type="hidden" name="filter_end_date" value="2035-01-01">
                        <div class="col-2"><input type="text" class="form-control  form-control-sm" name="search" placeholder="Find Purchase Order.." value="{{ $keyword }}"></div>
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-secondary" value="Search" name="submit"></div>   
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">Filter</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="Export Excel" name="export"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('purchaseorders.create') }}" class="btn btn-primary float-right {{ $act_permission->allow_create==1?'':'d-none' }}">Add new PO</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="10%">Branch</th>
                <th>Invoice No</th>
                <th scope="col" width="8%">Dated</th>
                <th scope="col" width="15%">Supplier</th>
                <th scope="col" width="10%">Total</th>
                <th scope="col" width="2%">Action</th>   
                <th scope="col" width="2%"></th>
                <th scope="col" width="2%"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($purchases as $purchase)
                    <tr>
                        <td>{{ $purchase->branch_name }}</td>
                        <td>{{ $purchase->purchase_no }}</td>
                        <td>{{ $purchase->dated }}</td>
                        <td>{{ $purchase->customer }}</td>
                        <td>{{ $purchase->total }}</td>
                        <td><a href="{{ route('purchaseorders.show', $purchase->id) }}" class="btn btn-warning btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">Show</a></td>
                        <td><a href="{{ route('purchaseorders.edit', $purchase->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">Edit</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            {!! Form::open(['method' => 'DELETE','route' => ['purchaseorders.destroy', $purchase->id],'style'=>'display:inline']) !!}
                            {!! Form::submit('Delete', ['class' => 'btn btn-danger btn-sm']) !!}
                            {!! Form::close() !!}
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="d-flex">
            {!! $purchases->links() !!}
        </div>

        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">Filter Data</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('purchaseorders.search') }}" method="POST">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Branch</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="">All Branch</option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label col-form-label col-md-4">Begin Date</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_begin_date"
                            id="filter_begin_date"
                            class="form-control" 
                            value="{{ old('filter_begin_date') }}" required/>
                            @if ($errors->has('filter_begin_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date') }}</span>
                                @endif
                        </div>

                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">End Date</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_end_date"
                            id="filter_end_date"
                            class="form-control" 
                            value="{{ old('filter_end_date') }}" required/>
                            @if ($errors->has('filter_end_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_end_date') }}</span>
                                @endif
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">Apply</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
          </div>


        
    </div>
@endsection

@push('scripts')
    <script type="text/javascript">
        const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#filter_begin_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_begin_date').val(formattedToday);


          $('#filter_end_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_end_date').val(formattedToday);
    </script>
@endpush
