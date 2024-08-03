@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Voucher')

@section('content')
<form method="POST" action="{{ route('voucher.update', [$product->branch_id,'0',$product->dated_start,$product->dated_end,$product->voucher_code]) }}"  enctype="multipart/form-data">
  @method('patch')
  @csrf
    <div class="bg-light p-4 rounded">
        <div class="row">
          <div class="col-md-10">
            <h1>Voucher {{ $product->voucher_code }}</h1>
          </div>
          <div class="col-md-2">
            <div class="mt-4">
              <button type="submit" class="btn btn-info">@lang('general.lbl_save')</button>
              <a href="{{ route('voucher.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
            </div>
          </div>
        </div>

        <br>
      
        <div class="panel text-white">
          <div class="panel-heading bg-teal-600"><h4></h4></div>
          <div class="panel-body bg-white text-black">

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Voucher Name</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="remark" value="{{ $product->voucher_remark }}" disabled/>
              </div>
           </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">Voucher Code</label>
              <div class="col-md-8">
                <input type="text" class="form-control" name="voucher_code" value="{{ $product->voucher_code }}" disabled/>
              </div>
           </div>

            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_service_name')</label>
              <div class="col-md-8">
                <input class="form-control" value="{{ $product->product_name }}" disabled>
              </div>
          </div>
          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_branch')</label>
            <div class="col-md-8">
              <select class="form-control" 
                    name="branch_id" disabled>
                    <option value="">@lang('general.lbl_branchselect')</option>
                    @foreach($branchs as $branch)
                        <option value="{{ $branch->id }}"   {{ ($product->branch_id == $branch->id) 
                          ? 'selected'
                          : '' }}>{{  $branch->remark }}</option>
                    @endforeach
                </select>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_date_start')</label>
            <div class="col-md-8">
              <input type="text" 
              name="dated_start"
              id="dated_start"
              class="form-control" 
              value="{{ Carbon\Carbon::parse($product->dated_start)->format('d-m-Y') }}"/>
              @if ($errors->has('dated_start'))
                      <span class="text-danger text-left">{{ $errors->first('dated_start') }}</span>
                  @endif
            </div>

          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">@lang('general.lbl_date_end')</label>
            <div class="col-md-8">
                <input type="text" 
                name="dated_end"
                id="dated_end"
                type="date"
                class="form-control" 
                value="{{ Carbon\Carbon::parse($product->dated_end)->format('d-m-Y') }}"/>
                @if ($errors->has('dated_end'))
                        <span class="text-danger text-left">{{ $errors->first('dated_end') }}</span>
                    @endif
            </div>
          </div>



          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Persentase Potongan Harga (%)</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="value_idx" value="{{ $product->value_idx }}" required/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Nilai Potongan Harga (Rp)</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="value" value="{{ $product->value }}" required/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Minimum Pembelian</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="moq" value="{{ $product->moq }}" required/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Pakai Berulang</label>
            <div class="col-md-8">
              <select name="unlimeted" class="form-control" id="unlimeted">
                <option value="0" <?= $product->unlimeted=="0"?"selected":""; ?> >Tidak</option>
                <option value="1" <?= $product->unlimeted=="1"?"selected":""; ?>>Ya</option>
              </select>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Harga Jual Voucher (Rp)</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="price" value="{{ $product->price }}" required/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Customer</label>
            <div class="col-md-8">
              <select class="form-control" 
                  name="customer_id" id="customer_id">
                  <option value="%">@lang('general.lbl_customerselect')</option>
                  @foreach($customers as $customer)
                      <option value="{{ $customer->id }}" {{ ($product->user_id == $customer->id) 
                        ? 'selected'
                        : ''}}>{{ $customer->name }}</option>
                  @endforeach
              </select>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Caption 1</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="caption_1"  value="{{ $product->caption_1 }}"/>
            </div>
          </div>

          <div class="row mb-3">
            <label class="form-label col-form-label col-md-2">Caption 2</label>
            <div class="col-md-8">
              <input type="text" class="form-control" name="caption_2"  value="{{ $product->caption_1 }}"/>
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

          const formattedToday =  dd + '-' + mm + '-' + yyyy;
          const formattedNextYear =  dd + '-' + mm + '-' + yyyy1;

          $('#dated_start').datepicker({
              dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });
          ///$('#dated_start').val(formattedToday);


          $('#dated_end').datepicker({
            dateFormat: 'dd-mm-yy',
              todayHighlight: true,
          });
          //$('#dated_end').val(formattedToday);

          $('#customer_id').select2({
            ajax: {
              dataType: 'json',
              url: function (params) {
                $urld = "{{ route('customers.search') }}";
                if(params.term == ""){
                  return $urld+'?src=api&search=%';
                }else{
                  return $urld+'?src=api&search='+params.term;
                }
              }
            },
          });

       
    </script>
@endpush
