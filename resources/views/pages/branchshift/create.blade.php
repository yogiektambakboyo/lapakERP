@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Customer')

@section('content')
    <div class="bg-light p-4 rounded">
        <h2>@lang('general.lbl_shift_branch_new')</h2>
        <div class="container mt-4">

            <form method="POST" action="{{ route('branchshift.store') }}">
                @csrf
                <div class="mb-3">
                    <label class="form-label">@lang('general.lbl_branch')</label>
                    <div class="col-md-12">
                      <select class="form-control" 
                            name="branch_id">
                            <option value="">@lang('general.lbl_branchselect')</option>
                            @foreach($branchs as $branch)
                                <option value="{{ $branch->id }}">{{  $branch->remark }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Shift</label>
                    <div class="col-md-12">
                        <select class="form-control" 
                            name="shift_id">
                            <option value="">Select Shift</option>
                            @foreach($shifts as $shift)
                                <option value="{{ $shift->id }}">{{  $shift->remark }} ( {{  $shift->time_start }} - {{  $shift->time_end }})</option>
                            @endforeach
                        </select>
                    </div>
                </div>


                <button type="submit" class="btn btn-primary">@lang('general.lbl_save')</button>
                <a href="{{ route('branchshift.index') }}" class="btn btn-default">@lang('general.lbl_back') </a>
            </form>
        </div>

    </div>
@endsection


@push('scripts')
    <script type="text/javascript">
            const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1;
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#dated').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#dated').val(formattedToday);

    </script>
@endpush
