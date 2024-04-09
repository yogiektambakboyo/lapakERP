@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Create New Invoice')

@section('content')
  <div class="panel text-white">
    <div class="panel-heading  bg-teal-600">
      <div class="panel-title"><h4>@lang('general.lbl_invoice')</h4></div>
      <div>
        <span class="fas fa-user"></span> 
        <label id="label_membership"></label>
        <button type="button" id="member-btn" class="btn btn-warning mx-2" href="#modal-scan-customer" data-bs-toggle="modal" data-bs-target="#modal-scan-customer"><span class='fas fa-address-card'> </span> Scan Member</button>
        <a href="{{ route('invoices.index') }}" class="btn btn-default">@lang('general.lbl_cancel')</a>
        <button type="button" id="save-btn" class="btn btn-info">@lang('general.lbl_save')</button>
      </div>
    </div>
    <div class="panel-body bg-white text-black">

        <div class="row mb-3">
          <div class="col-md-2">
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated_mmddYYYY')</label>
              <div class="col-md-8">
                <input type="hidden" name="branch_id_x" id="branch_id_x" value="{{ $userx->branch_id }}">
                <input type="text" 
                name="invoice_date"
                id="invoice_date"
                class="form-control" 
                value="{{ old('invoice_date') }}" required/>
                @if ($errors->has('invoice_date'))
                          <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                      @endif
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-4">@lang('general.lbl_remark')</label>
              <div class="col-md-8">
                <input type="text" 
                name="remark"
                id="remark"
                class="form-control" 
                value="{{ old('remark') }}"/>
                </div>
            </div>
          </div>

          <div class="col-md-10">
            <div class="row mb-3">

              <label class="form-label col-form-label col-md-2 d-none">@lang('general.lbl_spk')</label>
              <div class="col-md-3 d-none">
                <select class="form-control" 
                    name="ref_no" id="ref_no" required>
                    <option value="">@lang('general.lbl_spkselect')</label>
                    @foreach($orders as $order)
                        <option value="{{ $order->order_no }}">{{ $order->order_no }} </option>
                    @endforeach
                </select>
              </div>



              <label class="form-label col-form-label col-md-1">@lang('general.lbl_customer')</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="customer_id" id="customer_id" required>
                    <option value="">@lang('general.lbl_customerselect')</option>
                    @foreach($customers as $customer)
                        <option value="{{ $customer->id }}">{{ $customer->name }}</option>
                    @endforeach
                </select>
              </div>
              <div class="col-md-1">
                <a type="button" id="add-customer-btn" class="btn btn-sm btn-green"  href="#modal-add-customer" data-bs-toggle="modal" data-bs-target="#modal-add-customer"><span class="fas fa-user-plus"></span></a>
              </div>

              <label class="form-label col-form-label col-md-2">@lang('general.lbl_customer_type')</label>
              <div class="col-md-2">
                <select class="form-control" 
                    name="customer_type" id="customer_type" required>
                    <option value="">@lang('general.lbl_tipeselect')</option>
                    @foreach($type_customers as $type_customer)
                        <option value="{{ $type_customer }}"> {{ $type_customer }}</option>
                    @endforeach
                </select>
              </div>

              <label class="form-label col-form-label col-md-1">@lang('general.lbl_schedule')</label>
              <div class="col-md-3">
                  <div class="input-group">
                    <input type="text" class="form-control" id="scheduled" disabled>
                    <button type="button" class="btn btn-indigo" data-bs-toggle="modal" data-bs-target="#modal-scheduled" >
                      <span class="fas fa-calendar-days"></span>
                    </button>
                  </div>
              </div>
            </div>
            <div class="row mb-3">
              <label class="form-label col-form-label col-md-2">@lang('general.lbl_type_payment')</label>
              <div class="col-md-2">
                <select class="form-control" 
                      name="payment_type" id ="payment_type" required>
                      <option value="">@lang('general.lbl_type_paymentselect')</option>
                      @foreach($payment_type as $value)
                          <option value="{{ $value }}">{{ $value }}</option>
                      @endforeach
                  </select>
              </div>

                <label class="form-label col-form-label col-md-2">@lang('general.lbl_nominal_payment')</label>
                <div class="col-md-2">
                  <input type="text" 
                  id="payment_nominal"
                  name="payment_nominal"
                  class="form-control" 
                  value="0" required/>
                  </div>

                  <label class="form-label col-form-label col-md-1">@lang('general.lbl_charge')</label>
                  <div class="col-md-3">
                    <h2 class="text-end"><label id="order_charge">Rp. 0</label></h2>
                  </div>
                
            </div>
            <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog  modal-lg">
              <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="product_id_selected_lbl">Pilih Terapist</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <div class="form-group row">
                      <label class="form-label col-form-label col-md-2">Pilih Terapist </label>
                      <input type="hidden" id="product_id_selected" value="">
                      <div class="col-md-4">
                        <select class="form-control" 
                            name="assign_id" id="assign_id" required>
                            <option value="">@lang('general.lbl_assignselect') </option>
                            @foreach($users as $user)
                                <option value="{{ $user->id }}">{{ $user->name }}</option>
                            @endforeach
                        </select>
                      </div>
                      <label class="form-label col-form-label col-md-2">@lang('general.lbl_schedule') </label>
                      <div class="col-md-4">
                        <div class="input-group bootstrap-timepicker timepicker">
                          <input id="timepicker2" name="timepicker2" type="text" class="form-control input-small">
                          <span class="btn btn-indigo input-group-addon"><i class="fas fa-clock"></i></span>
                        </div>
                      </div>
                    </div>
                    <div class="form-group row mt-2">
                      <div class="col-md-12">
                        <table class="table table-striped" id="order_terapist_table" style="width:100%">
                          <thead>
                          <tr>
                              <th scope="col" width="13%">No Faktur</th>
                              <th>@lang('general.lbl_room')   </th>
                              <th scope="col" width="15%">@lang('general.lbl_terapist')</th>
                              <th scope="col" width="15%">Perawatan</th>
                              <th scope="col" width="7%">Mulai</th>
                              <th scope="col" width="7%">Selesai</th>
                              <th scope="col" width="8%">Sisa</th>
                          </tr>
                          </thead>
                          <tbody>
                          </tbody>
                        </table> 
                      </div>
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_assigned">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>

            <div class="modal fade" id="modal-referral" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_ref_by') </h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <label class="form-label col-form-label col-md-12" id="referral_selected_lbl">@lang('general.lbl_assignselect')  </label>
                    <input type="hidden" id="referral_selected" value="">
                    <div class="col-md-8">
                      <select class="form-control" 
                          name="referral_by" id="referral_by">
                          <option value="">@lang('general.lbl_assignselect') </option>
                          @foreach($usersall as $userall)
                              <option value="{{ $userall->id }}">{{ $userall->name }}</option>
                          @endforeach
                      </select>
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_referred">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>

            <div class="modal fade" id="modal-scheduled" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg">
              <div class="modal-content">
                  <div class="modal-header">
                  <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_scheduleselect')  </h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">

                    <div class="row mb-3">
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-8">@lang('general.lbl_room')   </label>
                      </div>
                      <div class="col-md-2">
                          <select class="form-control" 
                              name="room_id" id="room_id" required>
                              <option value="">@lang('general.lbl_roomselect')   </option>
                              @foreach($rooms as $room)
                                  <option value="{{ $room->id }}">{{ $room->remark }}</option>
                              @endforeach
                          </select>
                      </div>
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-4">@lang('general.lbl_dated')   </label>
                      </div>
                      <div class="col-md-2">
                        <input type="text" data-date-format="yyyy-mm-dd"
                        name="schedule_date"
                        id="schedule_date"
                        class="form-control" 
                        value="{{ old('invoice_date') }}" required/>
                        @if ($errors->has('invoice_date'))
                                  <span class="text-danger text-left">{{ $errors->first('join_date') }}</span>
                              @endif
                      </div>
                      <div class="col-md-1">
                        <label class="form-label col-form-label col-md-8">@lang('general.lbl_time')   </label>
                      </div>
                      <div class="col-md-2">
                        <div class="input-group bootstrap-timepicker timepicker">
                            <input id="timepicker1" type="text" class="form-control input-small">
                            <span class="btn btn-indigo input-group-addon"><i class="fas fa-clock"></i></span>
                        </div>    
                      </div>
                    </div>
                   
                    <div class="panel-heading bg-teal-600 text-white"><strong>@lang('general.lbl_schedule_list')   </strong></div>
                    <br>
      
                    <div class="col-md-12">
                      <table class="table table-striped" id="order_time_table" style="width:100%">
                        <thead>
                        <tr>
                          <th>@lang('general.lbl_room')</th>
                          <th scope="col" width="13%">No Faktur</th>
                          <th scope="col" width="13%">@lang('general.lbl_customer')</th>
                          <th scope="col" width="15%">@lang('general.lbl_schedule_at')   </th>
                          <th scope="col" width="5%">@lang('general.lbl_duration')   </th>
                          <th scope="col" width="18%">@lang('general.lbl_end_estimation') </th>
                          <th scope="col" width="18%">Terapis </th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                      </table> 
                    </div>
                  </div>
                  <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                  <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_scheduled">@lang('general.lbl_apply')</button>
                  </div>
              </div>
              </div>
            </div>


          </div>
        </div>



        <div class="panel-heading bg-teal-600 text-white mb-2 row"> 
          <div class="col-9"><strong>@lang('general.lbl_order_list')</strong></div>
          <div class="col-3 d-flex justify-content-end">
            
          </div>
        </div>
        <div class="card text-center font-weight-bold my-3 p-1"><h3><i class="fas fa-fw fa-hands-praying"></i> @lang('general.service')</h3></div>

        <div class="row mb-3">
          
          <div class="col-md-3">
            <label class="form-label col-form-label">@lang('general.service')</label>
            <select class="form-control" 
                  name="input_service_id" id="input_service_id" required>
                  <option value="">@lang('general.serviceselect')</option>
              </select>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_uom')</label>
            <input type="text" 
            name="input_service_uom"
            id="input_service_uom"
            class="form-control" 
            value="{{ old('input_service_uom') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <label class="form-label col-form-label">@lang('general.lbl_price')</label>
            <input type="text" 
            name="input_service_price"
            id="input_service_price"
            class="form-control" 
            value="{{ old('input_service_price') }}" required disabled/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_discountrp')</label>
            <input type="text" 
            name="input_service_disc"
            id="input_service_disc"
            class="form-control" 
            value="{{ old('input_service_disc') }}" required/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_qty')</label>
            <input type="text" 
            name="input_service_qty"
            id="input_service_qty"
            class="form-control" 
            value="{{ old('input_service_qty') }}" required/>
          </div>

          <div class="col-md-2">
            <label class="form-label col-form-label">Total</label>
            <input type="hidden" 
            name="input_service_vat_total"
            id="input_service_vat_total"
            class="form-control" 
            value="{{ old('input_service_vat_total') }}" required disabled/>
            <input type="text" 
            name="input_service_total"
            id="input_service_total"
            class="form-control" 
            value="{{ old('input_service_total') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
            <button href="#" id="input_service_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>@lang('general.lbl_add_service')</div></button>
          </div>

        </div>

        <table class="table table-striped" id="order_table">
          <thead>
          <tr>
              <th scope="col">No</th>
              <th scope="col" width="20%">@lang('general.service')</th>
              <th scope="col" width="10%">@lang('general.lbl_uom')</th>
              <th scope="col" width="10%">@lang('general.lbl_price')</th>
              <th scope="col" width="5%">@lang('general.lbl_discount')</th>
              <th scope="col" width="5%">@lang('general.lbl_qty')</th>
              <th scope="col" width="10%">Total</th>  
              <th scope="col" width="10%">@lang('general.lbl_terapist')</th>  
              <th scope="col" width="10%">@lang('general.lbl_ref_by')</th>
              <th scope="col" width="20%" class="nex">@lang('general.lbl_action')</th> 
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table> 
        
        <div class="card text-center font-weight-bold my-3 p-1"><h3><i class="fas fa-fw fa-box"></i> @lang('general.product')</h3></div>

        <div class="row mb-3">
          
          <div class="col-md-3">
            <label class="form-label col-form-label">@lang('general.product')</label>
            <select class="form-control" 
                  name="input_product_id" id="input_product_id" required>
                  <option value="">@lang('general.productselect')</option>
              </select>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_uom')</label>
            <input type="text" 
            name="input_product_uom"
            id="input_product_uom"
            class="form-control" 
            value="{{ old('input_product_uom') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <label class="form-label col-form-label">@lang('general.lbl_price')</label>
            <input type="text" 
            name="input_product_price"
            id="input_product_price"
            class="form-control" 
            value="{{ old('input_product_price') }}" required disabled/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_discountrp')</label>
            <input type="text" 
            name="input_product_disc"
            id="input_product_disc"
            class="form-control" 
            value="{{ old('input_product_disc') }}" required/>
          </div>


          <div class="col-md-1">
            <label class="form-label col-form-label">@lang('general.lbl_qty')</label>
            <input type="text" 
            name="input_product_qty"
            id="input_product_qty"
            class="form-control" 
            value="{{ old('input_product_qty') }}" required/>
          </div>

          <div class="col-md-2">
            <label class="form-label col-form-label">Total</label>
            <input type="hidden" 
            name="input_product_vat_total"
            id="input_product_vat_total"
            class="form-control" 
            value="{{ old('input_product_vat_total') }}" required disabled/>
            <input type="text" 
            name="input_product_total"
            id="input_product_total"
            class="form-control" 
            value="{{ old('input_product_total') }}" required disabled/>
          </div>

          <div class="col-md-2">
            <div class="col-md-12"><label class="form-label col-form-label">_</label></div>
            <button id="input_product_submit" class="btn btn-green"><div class="fa-1x"><i class="fas fa-plus fa-fw"></i>@lang('general.lbl_add_product')</div></button>
          </div>

        </div>

        <table class="table table-striped" id="order_product_table">
          <thead>
          <tr>
              <th scope="col">No</th>
              <th scope="col" width="20%">@lang('general.product')</th>
              <th scope="col" width="10%">@lang('general.lbl_uom')</th>
              <th scope="col" width="10%">@lang('general.lbl_price')</th>
              <th scope="col" width="5%">@lang('general.lbl_discount')</th>
              <th scope="col" width="5%">@lang('general.lbl_qty')</th>
              <th scope="col" width="10%">Total</th>  
              <th scope="col" width="10%">@lang('general.lbl_terapist')</th>  
              <th scope="col" width="10%">@lang('general.lbl_ref_by')</th>
              <th scope="col" width="20%" class="nex">@lang('general.lbl_action')</th> 
          </tr>
          </thead>
          <tbody>
          </tbody>
        </table> 
        
        <div class="row mb-3">
          <div class="col-md-6">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2" id="label-voucher">Voucher</label>
                <br>
                <div class="col-md-3">
                  <input type="text" class="form-control" id="input-apply-voucher">
                </div>
                <div class="col-md-4">
                  <button type="button" id="apply-voucher-btn" class="btn btn-warning">@lang('general.lbl_apply_voucher')</button>
                </div>
            </div>
            <label class="fst-italic">Setelah masukkan Kode Voucher, Klik tombol "Gunakan Voucher" untuk memotong pembayaran</label>
          </div>
          <div class="col-md-6">
            <div class="col-md-12 d-none">
              <div class="col-auto text-end">
                <label class="col-md-2"><h2>Sub Total </h2></label>
                <label class="col-md-8" id="sub-total"> <h3>0</h3></label>
              </div>
            </div>
            <div class="col-md-12 d-none">
              <div class="col-auto text-end">
                <label class="col-md-2"><h2>@lang('general.lbl_tax') </h2></label>
                <label class="col-md-8" id="vat-total"> <h3>0</h3></label>
              </div>
            </div>
            <div class="col-md-12">
              <div class="col-auto text-end">
                <label class="col-md-2"><h1>Total </h1></label>
                <label class="col-md-8 display-5" id="result-total"> <h1>0</h1></label>
              </div>
            </div>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col-md-12">
            <div class="row mb-3">
                <label class="form-label col-form-label col-md-2" id="label-voucher">No Faktur Tamu ke 2</label>
                <br>
                <div class="col-md-3">
                  <input class="form-control" name="promo_inv" id="promo_inv" type="text" placeholder="">
                </div>
                <div class="col-md-4">
                  <button class="ms-2 btn btn-sm btn-danger" id="apply-promo-btn">Hitung Promo</button>
                </div>
            </div>
            <label class="fst-italic">Setelah masukkan No Faktur, Klik tombol "Hitung Promo" untuk menghitung promo yang didapat</label>
          </div>
        </div>



        <div class="modal fade" id="modal-add-customer" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
              <h5 class="modal-title" id="staticBackdropLabel">@lang('general.lbl_add_customer_new')</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                
                <div class="container mt-4">
                        <div class="mb-3">
                            <label for="cust_name" class="form-label">@lang('general.lbl_name')</label>
                            <input value="{{ old('cust_name') }}" 
                                type="text" 
                                class="form-control" 
                                name="cust_name" 
                                id="cust_name" 
                                placeholder="@lang('general.lbl_name')" required>
        
                            @if ($errors->has('cust_name'))
                                <span class="text-danger text-left">{{ $errors->first('cust_name') }}</span>
                            @endif
                        </div>
        
                        <div class="mb-3">
                            <label for="address" class="form-label">@lang('general.lbl_address')</label>
                            <input value="{{ old('cust_address') }}" 
                                type="text" 
                                class="form-control" 
                                name="cust_address" id="cust_address" 
                                placeholder="@lang('general.lbl_address')" required>
        
                            @if ($errors->has('cust_address'))
                                <span class="text-danger text-left">{{ $errors->first('cust_address') }}</span>
                            @endif
                        </div>
        
                        <div class="mb-3">
                            <label for="cust_phone_no" class="form-label">@lang('general.lbl_phoneno') (Minimal 9 digit angka)</label>
                            <input
                                type="number" 
                                class="form-control" 
                                name="cust_phone_no" id="cust_phone_no" value="08"
                                placeholder="@lang('general.lbl_phoneno')" required>
        
                            @if ($errors->has('cust_phone_no'))
                                <span class="text-danger text-left">{{ $errors->first('cust_phone_no') }}</span>
                            @endif
                        </div>
        
                        <div class="mb-3">
                            <label class="form-label">@lang('general.lbl_branch')</label>
                            <div class="col-md-12">
                              <select class="form-control" 
                                    name="cust_branch_id" id="cust_branch_id">
                                    <option value="">@lang('general.lbl_branchselect')</option>
                                    <?php 
                                      foreach($branchs as $branch){  
                                        $selected = $branch->id==$userx->branch_id?"selected":"";                                
                                        echo '<option value="'.$branch->id.'" '.$selected.'>'.$branch->remark.'</option>';
                                      }  
                                    ?>
                                </select>
                            </div>
                          </div>

                          <div class="mb-3">
                            <label class="form-label">Jenis Kelamin</label>
                            <div class="col-md-12">
                              <select class="form-control" 
                                    name="cust_gender" id="cust_gender">
                                    <option value="">Pilih Jenis Kelamin</option>
                                    <option value="Pria">Pria</option>
                                    <option value="Wanita">Wanita</option>
                                  
                                </select>
                            </div>
                          </div>
                </div>
    
              </div>
              <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
              <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_save_customer">@lang('general.lbl_save')</button>
              </div>
          </div>
          </div>
        </div>


        <div class="modal fade" id="modal-scan-customer" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
          <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header">
              <h5 class="modal-title" id="staticBackdropLabel">Scan Membership</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                
                <div class="container mt-1">
                        <div class="row">
                          <div class="col-12">
                            <label for="scan_phone_no" class="form-label">Masukkan No HP Tamu (08xx) / No ID Membership</label>
                          </div>
                          <div class="col-7">
                            <input
                                type="text" 
                                class="form-control" 
                                name="scan_phone_no" id="scan_phone_no" value=""
                                required>
                          </div>
                          <div class="col-1">
                            <button id="btn_scan_cam" class="btn btn-warning"><span class="fas fa-camera-retro fa-lg"></span></button>
                          </div>

                          <div class="col-3 mx-2">
                            <button id="btn_check" class="btn btn-primary"><span class="fas fa-search fa-lg"> </span> Cek Data</button>
                          </div>

                          <div class="my-2" style="width: 500px" id="reader"></div>


                          <div id="div_id" class="d-none">
                            <div class="col-3">
                              <label for="res_name" class="form-label">Nama</label>
                            </div>
                            <div class="col-9">
                              <input
                                  type="text" 
                                  class="form-control" 
                                  name="res_name" id="res_name" value="" readonly
                                  required>
                                  <input
                                  type="hidden" 
                                  class="form-control" 
                                  name="res_id" id="res_id" value="" readonly
                                  required>
                            </div>
  
                            <div class="col-3 mt-1">
                              <label for="res_address" class="form-label">Alamat</label>
                            </div>
                            <div class="col-9 mt-1">
                              <input
                                  type="text" 
                                  class="form-control" readonly
                                  name="res_address" id="res_address" value=""
                                  required>
                            </div>

                          </div>
                            
                        </div>
                </div>
    
              </div>
              <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
              <button type="button" class="btn btn-primary"  data-bs-dismiss="modal" id="btn_scan_customer">Proses</button>
              </div>
          </div>
          </div>
        </div>



    </div>
  </div>
@endsection

@push('scripts')
    <script type="text/javascript">
          var room_selected = "";
          var list_customer = [];
          var assign_selected = "";
          var membership_selected = "";
          var membership_branch_selected = "";
          var membership_name_selected = "";

          $('#btn_scan_cam').on('click',function(){
            html5QrcodeScanner = new Html5QrcodeScanner("reader", { fps: 10, qrbox: 250 });
            html5QrcodeScanner.render(onScanSuccess);
          });

          var html5QrcodeScanner;
                  
          function onScanSuccess(decodedText, decodedResult) {
              // Handle on success condition with the decoded text or result.
              console.log(`Scan result: ${decodedText}`, decodedResult);
              $('#scan_phone_no').val(decodedText);
              html5QrcodeScanner.clear();
              // ^ this will stop the scanner (video feed) and clear the scan area.
          }

          $('#btn_check').on('click', function(){
            var phone_no = $('#scan_phone_no').val();
            if(phone_no == "" ){
              Swal.fire(
                  {
                    position: 'top-end',
                    icon: 'warning',
                    text: 'Silahkan masukkan ID tamu atau Nomor handphone',
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                  }
                );
            }else{
              const res = axios.get("{{ route('login.get_checkmembership') }}", {
                  headers: {
                      'Content-Type': 'application/json'
                    },
                    params: {
                      phone_no: phone_no
                    }
                }).then(resp => {
                  $('#div_id').addClass('d-none');
                  if(resp.data.length<=0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Data tidak ditemukan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                      }
                    );
                  }else{
                    $('#div_id').removeClass('d-none');
                    
                    for (let index = 0; index < resp.data.length; index++) {
                        const element = resp.data[index];
                        $('#res_name').val(element.name);
                        $('#res_id').val(element.id);
                        membership_branch_selected = element.branch_id;
                        $('#res_address').val(element.address);
                    }

                    for (let index = 0; index < resp.data.length; index++) {
                      const element = resp.data[index];
                      if(element.branch_id == $('#branch_id_x').val()){
                        $('#res_name').val(element.name);
                        $('#res_id').val(element.id);
                        membership_branch_selected = element.branch_id;
                        $('#res_address').val(element.address);
                      }
                    }

                    
                  }
                 
                });
            }
            
          });

          $('#btn_scan_customer').on('click', function(){
            if($('#res_name').val()==""){
              Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Data tidak ditemukan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                      }
                    );
            }else{
              $('#label_membership').text($('#res_name').val());
              membership_name_selected = $('#res_name').val();
              membership_selected = $('#res_id').val();
              var ctr = 0;

              if(membership_branch_selected == $('#branch_id_x').val()){
                $("#customer_id > option").each(function() {
                    if(this.value==membership_selected){
                      ctr++;
                      console.log(membership_selected);
                      $("#customer_id").val(membership_selected).trigger('change');
                    }
                });
              }else{

                    const json = JSON.stringify({
                        customer_id : membership_selected,
                        branch_id : $('#branch_id_x').val()
                        }
                      );
                      const res = axios.post("{{ route('customers.clonestoreapi') }}", json, {
                        headers: {
                          // Overwrite Axios's automatically set Content-Type
                          'Content-Type': 'application/json'
                        }
                      }).then(resp => {
                            if(resp.data.status=="success"){
                                var data = {
                                    id: resp.data.data,
                                    text: membership_name_selected
                                };

                                var newOption = new Option(data.text, data.id, false, false);
                                $('#customer_id').append(newOption).trigger('change');
                                $('#customer_id').val(resp.data.data).trigger('change');
                            }else{
                              Swal.fire(
                                {
                                  position: 'top-end',
                                  icon: 'warning',
                                  text: "@lang('general.lbl_msg_failed')"+resp.data.message,
                                  showConfirmButton: false,
                                  imageHeight: 30, 
                                  imageWidth: 30,   
                                  timer: 1500
                                }
                              );
                            }
                      });


              }

              


            }
          });



      $(function () {
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

        $('#btn_save_customer').on('click', function(){
        if($('#cust_name').val()==''){
            $('#cust_name').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan isi alamat',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_address').val()==''){
            $('#cust_address').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan isi alamat',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_phone_no').val()==''){
            $('#cust_phone_no').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan isi nomor handphone',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_phone_no').val().length <= 8){
            $('#cust_phone_no').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan isi nomor handphone lebih dari 8 digit angka',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_branch_id').val()==''){
            $('#cust_branch_id').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan pilih cabang',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#cust_gender').find(':selected').val()==''){
            $('#cust_gender').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan pilih Jenis Kelamin',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{
            const json = JSON.stringify({
                name : $('#cust_name').val(),
                address : $('#cust_address').val(),
                phone_no : $('#cust_phone_no').val(),
                gender : $('#cust_gender').find(':selected').val(),
                branch_id : $('#cust_branch_id').val()
                }
              );
              const res = axios.post("{{ route('customers.storeapi') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                        var data = {
                            id: resp.data.data,
                            text: $('#cust_name').val() +" ("+ $('#cust_branch_id option:selected').text() +")"
                        };


                        var newOption = new Option(data.text, data.id, false, false);
                        $('#customer_id').append(newOption).trigger('change');
                        $('#customer_id').val(resp.data.data).trigger('change');
                    }else{
                      Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "@lang('general.lbl_msg_failed')"+resp.data.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                        }
                      );
                    }
              });


          }
      });





          //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
          
          const today = new Date();
          const yyyy = today.getFullYear();
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = dd + '-' + mm + '-' + yyyy;
          $('#invoice_date').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#invoice_date').val(formattedToday);
          $('#schedule_date').datepicker({
              dateFormat : 'dd-mm-yy',
              todayHighlight: true,
          });
          $('#schedule_date').val(formattedToday);

          var url = "{{ route('orders.getorder','XX') }}";
          var lastvalurl = "XX";
          console.log(url);
          $('#ref_no').change(function(){
              if($(this).val()==""){

              table.clear().draw(false);
              table_product.clear().draw(false);
              order_total = 0;
              disc_total = 0;
              _vat_total = 0;
              sub_total = 0;
              orderList = [];
              $('#order_charge').text("Rp. 0");
            
              $('#result-total').text("Rp. 0");
              $('#vat-total').text("Rp. 0");
              $('#sub-total').text("Rp. 0");


              }else{
                url = url.replace(lastvalurl, $(this).val())
                lastvalurl = $(this).val();
                const res = axios.get(url, {
                  headers: {
                      'Content-Type': 'application/json'
                    }
                }).then(resp => {
                  table.clear().draw(false);
                  table_product.clear().draw(false);
                      order_total = 0;

                      for(var i=0;i<resp.data.length;i++){
                          var product = {
                                "seq" : resp.data[i]["seq"],
                                "id"        : resp.data[i]["product_id"],
                                "abbr"      : resp.data[i]["remark"],
                                "uom"      : resp.data[i]["uom"],
                                "price"     : resp.data[i]["price"],
                                "discount"  : resp.data[i]["discount"],
                                "qty"       : resp.data[i]["qty"],
                                "total"     : resp.data[i]["total"],
                                "assignedto"     : resp.data[i]["assignedto"],
                                "executed_at"     : resp.data[i]["executed_at"],
                                "assignedtoid"     : resp.data[i]["assignedtoid"],
                                "referralby"     : resp.data[i]["referralby"],
                                "referralbyid"     : resp.data[i]["referralbyid"],
                                "total_vat"     : resp.data[i]["vat_total"],
                                "vat_total"     : resp.data[i]["vat"],  
                          }

                          orderList.push(product);
                      }

                      counterno = 0;
                      counterno_service = 0;  
                      orderList.sort(function(a, b) {
                          return parseFloat(a.seq) - parseFloat(b.seq);
                      });

                      for (var i = 0; i < orderList.length; i++){
                      var obj = orderList[i];
                      var value = obj["abbr"];
                      if(obj["type_id"]=="Services"){
                        counterno_service  = counterno_service + 1;
                        table.row.add( {
                                "seq" : counterno_service,
                                "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }else{
                          counterno = counterno + 1;
                          table_product.row.add( {
                              "seq" : counterno,
                              "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"],
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }
                        disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
                        
                        if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').css('color', 'black');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("Rp. 0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }

                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

                    $('#invoice_date').val(resp.data[0]["dated"]);
                    $('#customer_id').val(resp.data[0]["customers_id"]);
                    $('#remark').val(resp.data[0]["order_remark"]);
                    $('#payment_type').val(resp.data[0]["payment_type"]);
                    $('#payment_nominal').val(resp.data[0]["payment_nominal"]);
                    $('#schedule_date').val(resp.data[0]["scheduled_date"]);
                    $('#timepicker1').val(resp.data[0]["scheduled_time"]);
                    $('#room_id').val(resp.data[0]["branch_room_id"]);
                    $('#scheduled').val($('#room_id option:selected').text()+" - "+$('#schedule_date').val()+" "+$('#timepicker1').val());


                });

              }

              

          });

          $('#btn_scheduled').on('click',function(){
            if($('#room_id').val()==""){
              Swal.fire(
                  {
                    position: 'top-end',
                    icon: 'warning',
                    text: 'Please choose room',
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                  }
                );
            }else{
              $('#scheduled').val($('#room_id option:selected').text()+" - "+$('#schedule_date').val()+" "+$('#timepicker1').val());
              room_selected = $('#room_id').val();
            }
          });

      });

      $('#btn_assigned').on('click',function(){
        if($('#assign_id').val()==""){
          Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose staff',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
        }else{
          assign_selected = $('#assign_id option:selected').val();
          table.clear().draw(false);
          table_product.clear().draw(false);
          order_total = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if($('#product_id_selected').val()==obj["id"]){
              orderList[i]["assignedto"] = $('#assign_id option:selected').text();
              orderList[i]["assignedtoid"] = $('#assign_id').val();
              orderList[i]["executed_at"] = $('#timepicker2').val();
            }
          }

          orderList.sort(function(a, b) {
              return parseFloat(a.entry_time) - parseFloat(b.entry_time);
          });


          counterno = 0;
          counterno_service = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];

            if(obj["type_id"]=="Services"){
              counterno_service  = counterno_service + 1;
              table.row.add( {
                      "seq" : counterno_service,
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }

              disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
              
              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }
          }
          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
        }
      });

      $('#btn_referred').on('click',function(){
        if($('#referral_by').val()==""){
          Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Please choose staff',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
        }else{
          table.clear().draw(false);
          table_product.clear().draw(false);
          order_total = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if($('#referral_selected').val()==obj["id"]){
              orderList[i]["referralby"] = $('#referral_by option:selected').text();
              orderList[i]["referralbyid"] = $('#referral_by').val();
            }
          }


          orderList.sort(function(a, b) {
              return parseFloat(a.entry_time) - parseFloat(b.entry_time);
          });


          counterno = 0;
          counterno_service = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];

            if(obj["type_id"]=="Services"){
              counterno_service  = counterno_service + 1;
              table.row.add( {
                      "seq" : counterno_service,
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }

              disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }
          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());


        }
      });

      var productList = [];
      var orderList = [];
      var order_total = 0;
      var disc_total = 0;
      var _vat_total = 0;
      var sub_total = 0;
      var _is_use_voucher = "0";
        
        $('#save-btn').on('click',function(){
          if($('#invoice_date').val()==''){
            $('#invoice_date').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan pilih tanggal ',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#customer_id').val()==''){
            $('#customer_id').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan pilih tamu',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#payment_type').val()==''){
            $('#payment_type').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan pilih tipe pembayaran',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#payment_nominal').val()==''){
            $('#payment_nominal').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan masukkan nominal pembayaran',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else if($('#scheduled').val()==''){
            $('#scheduled').focus();
            Swal.fire(
              {
                position: 'top-end',
                icon: 'warning',
                text: 'Silahkan pilih jadwal',
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
              }
            );
          }else{
       
  
            counterBlank = 0;
            counterBlankSell = 0;
            for (var i=0;i<orderList.length;i++){
                if(orderList[i]["assignedto"]=="" && orderList[i]["type_id"] == "Services"){
                  counterBlank++;
                }
                if(orderList[i]["assignedto"]=="" && orderList[i]["referralbyid"]=="" && orderList[i]["type_id"] == "Good"){
                  counterBlankSell++;
                }
            }

            if(counterBlank>0){
              Swal.fire(
              {
                  position: 'top-end',
                  icon: 'warning',
                  text: 'Silahkan pilih terapis untuk perawatan',
                  showConfirmButton: false,
                  imageHeight: 30, 
                  imageWidth: 30,   
                  timer: 1500
                }
              );
            }else if(counterBlankSell>0){
              Swal.fire(
              {
                  position: 'top-end',
                  icon: 'warning',
                  text: 'Silahkan pilih penjual untuk produk',
                  showConfirmButton: false,
                  imageHeight: 30, 
                  imageWidth: 30,   
                  timer: 1500
                }
              );
            }else{
              // call Loading
              let swal = Swal.fire({
                  title: 'Loading...',
                  html: 'Please wait, Request under processing',
                  allowEscapeKey: false,
                  allowOutsideClick: false,
                  didOpen: () => {
                    Swal.showLoading()
                  }
              });    
              
              const json = JSON.stringify({
                  invoice_date : $('#invoice_date').val(),
                  product : orderList,
                  customer_id : $('#customer_id').val(),
                  remark : $('#remark').val(),
                  payment_type : $('#payment_type').val(),
                  payment_nominal : $('#payment_nominal').val(),
                  total_order : order_total,
                  scheduled_at : $('#schedule_date').val()+" "+$('#timepicker1').val(),
                  branch_room_id : $('#room_id').val(),
                  customer_type : $('#customer_type').val(),
                  ref_no : $('#ref_no').val(),
                  tax : _vat_total,
                  voucher_code :  $("#input-apply-voucher").val(),
                  is_use_voucher : _is_use_voucher,
                  membership : membership_selected,
                }
              );
              const res = axios.post("{{ route('invoices.store') }}", json, {
                headers: {
                  // Overwrite Axios's automatically set Content-Type
                  'Content-Type': 'application/json'
                }
              }).then(resp => {
                    if(resp.data.status=="success"){
                      Swal.fire({
                        text: "@lang('general.lbl_msg_success_invoice') "+resp.data.message,
                        title : "@lang('general.lbl_success')",
                        icon: 'success',
                        showDenyButton: true,
                        showCancelButton: true,
                        cancelButtonColor: '#d33',
                        denyButtonColor: '#0072b3',
                        cancelButtonText: "@lang('general.lbl_close')",
                        confirmButtonText: "@lang('general.lbl_print')",
                        denyButtonText: "@lang('general.lbl_printspk')",
                      }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.isConfirmed) {
                          burl ="{{ route('invoices.print', 'WWWW') }}";
                          burl = burl.replace('WWWW', resp.data.data)
                          //window.location.href = burl; 
                          window.open(
                            burl,
                            '_blank' // <- This is what makes it open in a new window.
                          );
                          window.location.href = "{{ route('invoices.index') }}"; 
                        } else if (result.isDenied) {
                          burl = "{{ route('invoices.printspk', 'WWWW') }}";
                          burl = burl.replace('WWWW', resp.data.data)
                          window.open(
                            burl,
                            '_blank' // <- This is what makes it open in a new window.
                          );
                          window.location.href = "{{ route('invoices.index') }}"; 
                        }else{
                          window.location.href = "{{ route('invoices.index') }}"; 
                        }
                      })
                    }else{
                      Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "@lang('general.lbl_msg_failed')"+resp.data.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 3500
                        }
                      );
                    }
              }).catch(function (error) {
                Swal.fire(
                        {
                          position: 'top-end',
                          icon: 'warning',
                          text: "@lang('general.lbl_msg_failed')"+error.message,
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 3500
                        }
                      );
                console.log(error.toJSON());
              });
            }
          }
        });
        
        $('#product-table').DataTable({
          "bInfo" : false,
          pagingType: 'numbers',
          ajax: "{{ route('invoices.getproduct') }}",
          columns: [
            { data: 'abbr' },
            { data: 'remark' },
            { data: 'type' },
            { data: 'action', name: 'action', orderable: false, searchable: false}
        ],
        }); 

        $('#order_time_table').DataTable({
          "bInfo" : false,
          pagingType: 'numbers',
          ajax: "{{ route('invoices.gettimetable') }}",
          columns: [
            { data: 'branch_room_name' },
            { data: 'invoice_no' },
            { data: 'customer_name' },
            { data: 'scheduled_at' },
            { data: 'duration' },
            { data: 'est_end' },
            { data: 'pic' },
        ],
        }); 

        $('#order_terapist_table').DataTable({
          "bInfo" : false,
          pagingType: 'numbers',
          ajax: "{{ route('invoices.getterapisttable') }}",
          columns: [
            { data: 'invoice_no' },
            { data: 'room' },
            { data: 'terapist_name' },
            { data: 'abbr' },
            { data: 'start_time' },
            { data: 'end_time' },
            { data: 'remain_time' },
        ],
        }); 

        //getterapisttable

        $('#modal-scheduled').on('shown.bs.modal', function () {
            var timetable = $('#order_time_table').DataTable();
            timetable.ajax.reload();
            timetable.columns.adjust();

            // Here

            var url = "{{ route('invoices.gettimetable_room') }}";
                const res = axios.get(url,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    params : {
                        
                    }
                  }
                ).then(resp => {
                    $('#room_id')
                    .find('option')
                    .remove()
                    .end()
                    .append('<option value="">Pilih Kamar</option>');

                    resp.data.forEach(element => {
                        $('#room_id')
                        .append('<option value="'+element.id+'">'+element.branch_room+'</option>');
                    });

                    $('#room_id').val(room_selected);
                });


        });

        $('#modal-filter').on('shown.bs.modal', function () {
            var terapisttable = $('#order_terapist_table').DataTable();
            terapisttable.ajax.reload();
            terapisttable.columns.adjust();

            const json = JSON.stringify({
                  invoice_no : '-'
                }
              );

            var url = "{{ route('invoices.getfreeterapist') }}";
                const res = axios.post(url, json,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    params : {
                        
                    }
                  }
                ).then(resp => {
                    $('#assign_id')
                    .find('option')
                    .remove()
                    .end()
                    .append('<option value="">Pilih Terapis</option>');

                    resp.data.forEach(element => {
                        $('#assign_id')
                        .append('<option value="'+element.id+'">'+element.name+'</option>');
                    });

                    $('#assign_id').val(assign_selected);
                });
        });

        var table = $('#order_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<button href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-sm btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></button>'+
            '<button href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-sm btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></button>'+
            '<button href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-sm btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></button>'+
            '<button href="#" href="#modal-filter" data-bs-toggle="modal" data-bs-target="#modal-filter"  data-toggle="tooltip" data-placement="top" title="Terapis"  data-toggle="tooltip" data-placement="top" title="Terapis" id="assign_row" class="btn btn-sm btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></button>'+
            '<button href="#" href="#modal-referral" data-bs-toggle="modal" data-bs-target="#modal-referral" data-toggle="tooltip" data-placement="top" title="Dijual Oleh"  id="referral_row" class="btn btn-sm btn-purple"><div class="fa-1x"><i class="fas fa-users fa-fw"></i></div></button>',
          }],
          columns: [
            { data: 'seq' },
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'discount',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'qty' },
            { data: 'total',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'assignedto' },
            { data: 'referralby' },
            { data: null},
        ],
        });

        var table_product = $('#order_product_table').DataTable({
          columnDefs: [{ 
            targets: -1, 
            data: null, 
            defaultContent: 
            '<button href="#"  data-toggle="tooltip" data-placement="top" title="Tambah"   id="add_row"  class="btn btn-sm btn-green"><div class="fa-1x"><i class="fas fa-circle-plus fa-fw"></i></div></button>'+
            '<button href="#"  data-toggle="tooltip" data-placement="top" title="Kurangi"   id="minus_row"  class="btn btn-sm btn-yellow"><div class="fa-1x"><i class="fas fa-circle-minus fa-fw"></i></div></button>'+
            '<button href="#" data-toggle="tooltip" data-placement="top" title="Hapus"  id="delete_row"  class="btn btn-sm btn-danger"><div class="fa-1x"><i class="fas fa-circle-xmark fa-fw"></i></div></button>'+
            '<button href="#" href="#modal-filter" data-bs-toggle="modal" data-bs-target="#modal-filter"  data-toggle="tooltip" data-placement="top" title="Terapis"  data-toggle="tooltip" data-placement="top" title="Terapis" id="assign_row" class="btn btn-sm btn-gray"><div class="fa-1x"><i class="fas fa-user-tag fa-fw"></i></div></button>'+
            '<button href="#" href="#modal-referral" data-bs-toggle="modal" data-bs-target="#modal-referral" data-toggle="tooltip" data-placement="top" title="Dijual Oleh"  id="referral_row" class="btn btn-sm btn-purple"><div class="fa-1x"><i class="fas fa-users fa-fw"></i></div></button>',
          }],
          columns: [
            { data: 'seq' },
            { data: 'abbr' },
            { data: 'uom' },
            { data: 'price',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'discount',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'qty' },
            { data: 'total',render: DataTable.render.number( '.', null, 0, '' ) },
            { data: 'assignedto' },
            { data: 'referralby' },
            { data: null},
        ],
        });

        function addProduct(id,abbr, price, discount, qty, uom,vat_total,total,type_id){
          table.clear().draw(false);
          table_product.clear().draw(false);
          order_total = 0;
          disc_total = 0;
          _vat_total = 0;
          sub_total = 0;
          entry_time = Date.now();
          var product = {
                "id"        : id,
                "abbr"      : abbr,
                "price"     : price,
                "discount"  : discount,
                "qty"       : qty,
                "total"     : total,
                "assignedto" : "",
                "assignedtoid" : "",
                "referralby" : "",
                "referralbyid" : "",
                "uom" : uom,
                "vat_total"     : vat_total, 
                "type_id"     : type_id, 
                "entry_time" : entry_time,
                "executed_at" : "",
                "seq" : 999,
          }

          var isExist = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["id"];
            if(id==obj["id"]){
              isExist = 1;
              orderList[i]["total"] = (parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]); 
              orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
            }
          }

          if(isExist==0){
            orderList.push(product);
          }

          orderList.sort(function(a, b) {
              return parseFloat(a.entry_time) - parseFloat(b.entry_time);
          });


          counterno = 0;
          counterno_service = 0;
          for (var i = 0; i < orderList.length; i++){
            var obj = orderList[i];
            var value = obj["abbr"];

            if(obj["type_id"]=="Services"){
              counterno_service  = counterno_service + 1;
              table.row.add( {
                      "seq" : counterno_service,
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }

              disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }


          }

          $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
          $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        }

        $('#order_table tbody').on('click', 'button', function () {
            var data = table.row($(this).parents('tr')).data();
            order_total = 0;
            disc_total = 0;
            _vat_total = 0;
            sub_total = 0;
            table.clear().draw(false);
            table_product.clear().draw(false);
            
            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              var value = obj["id"];

              if($(this).attr("id")=="add_row"){
                if(data["id"]==obj["id"]){
                  orderList[i]["total"] = (parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])>1){
                  orderList[i]["total"] = (parseInt(orderList[i]["qty"])-1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])-1;
                } else if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])==1) {
                  orderList.splice(i,1);
                }
              }

              if($(this).attr("id")=="delete_row"){
                if(data["id"]==obj["id"]){
                  orderList.splice(i,1);
                }
              }

              if($(this).attr("id")=="assign_row"){
                if(data["id"]==obj["id"]){
                  $('#product_id_selected').val(data["id"]);
                  $('#product_id_selected_lbl').text("Pilih terapis untuk produk/perawatan "+data["abbr"]);
                }
              }

              if($(this).attr("id")=="referral_row"){
                if(data["id"]==obj["id"]){
                  $('#referral_selected').val(data["id"]);
                  $('#referral_selected_lbl').text("Pilih penjual produk/perawatan "+data["abbr"]);
                }
              }
            }

            orderList.sort(function(a, b) {
                return parseFloat(a.entry_time) - parseFloat(b.entry_time);
            });

            counterno = 0;
            counterno_service = 0;

            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type_id"]=="Services"){
              counterno_service  = counterno_service + 1;
              table.row.add( {
                      "seq" : counterno_service,
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }
                disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }


            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        });

        $('#order_product_table tbody').on('click', 'button', function () {
            var data = table_product.row($(this).parents('tr')).data();
            order_total = 0;
            disc_total = 0;
            _vat_total = 0;
            sub_total = 0;
            table.clear().draw(false);
            table_product.clear().draw(false);
            
            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              var value = obj["id"];

              if($(this).attr("id")=="add_row"){
                if(data["id"]==obj["id"]){
                  orderList[i]["total"] = (parseInt(orderList[i]["qty"])+1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])+1;
                }
              }
              
              if($(this).attr("id")=="minus_row"){
                if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])>1){
                  orderList[i]["total"] = (parseInt(orderList[i]["qty"])-1)*parseFloat(orderList[i]["price"]); 
                  orderList[i]["qty"] = parseInt(orderList[i]["qty"])-1;
                } else if(data["id"]==obj["id"]&&parseInt(orderList[i]["qty"])==1) {
                  orderList.splice(i,1);
                }
              }

              if($(this).attr("id")=="delete_row"){
                if(data["id"]==obj["id"]){
                  orderList.splice(i,1);
                }
              }

              if($(this).attr("id")=="assign_row"){
                if(data["id"]==obj["id"]){
                  $('#product_id_selected').val(data["id"]);
                  $('#product_id_selected_lbl').text("Pilih terapis untuk produk/perawatan "+data["abbr"]);
                }
              }

              if($(this).attr("id")=="referral_row"){
                if(data["id"]==obj["id"]){
                  $('#referral_selected').val(data["id"]);
                  $('#referral_selected_lbl').text("Pilih penjual produk/perawatan "+data["abbr"]);
                }
              }
            }

            orderList.sort(function(a, b) {
                return parseFloat(a.entry_time) - parseFloat(b.entry_time);
            });

            counterno = 0;
             counterno_service = 0;
            for (var i = 0; i < orderList.length; i++){
              var obj = orderList[i];
              if(obj["type_id"]=="Services"){
              counterno_service  = counterno_service + 1;
              table.row.add( {
                      "seq" : counterno_service,
                      "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }else{
                counterno = counterno + 1;
                table_product.row.add( {
                    "seq" : counterno,
                    "id"        : obj["id"],
                      "abbr"      : obj["abbr"],
                      "uom"       : obj["uom"],
                      "price"     : obj["price"],
                      "discount"  : obj["discount"],
                      "qty"       : obj["qty"],
                      "total"     : obj["total"],
                      "assignedto": obj["assignedto"],
                      "referralby" : obj["referralby"],
                      "action"    : "",
                }).draw(false);
              }
                disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
              sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
              _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
              order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

              if(($('#payment_nominal').val())>order_total){
                $('#order_charge').css('color', 'black');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }else{
                $('#order_charge').text("Rp. 0");
                $('#order_charge').css('color', 'red');
                $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
              }


            }

            $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
            $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

        });




            $("#payment_nominal").on("input", function(){
              order_total = 0;
              for (var i = 0; i < orderList.length; i++){
                  var obj = orderList[i];
                  order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                  if(($('#payment_nominal').val())>order_total){
                    $('#order_charge').css('color', 'black');
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                  }else{
                    $('#order_charge').text("Rp. 0");
                    $('#order_charge').css('color', 'red');
                    $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                  }


                }
              });

            
              $('#invoice_date').on("change", function () {
                 var invoice_date = $('#invoice_date').val(); 
                 var url = "{{ route('period.get_period_status') }}";
                 $('#save-btn').removeClass("d-none");
                const res = axios.get(url,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    params : {
                        invoice_date : moment(invoice_date, 'DD-MM-YYYY').format('YYYY-MM-DD')
                    }
                  }
                ).then(resp => {
                  var respon = resp.data;
                  if(respon[0].close_trans == "1"){
                    $('#save-btn').addClass("d-none");
                    Swal.fire(
                      {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Status periode '+respon[0].remark+' tertutup, anda tidak diperbolehkan membuat transaksi di periode tsb',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                      }
                    );
                  }else{
                    $('#save-btn').removeClass("d-none");
                  }
                });
              });


            var url = "{{ route('orders.getproduct') }}";
            var lastvalurl = "XX";
            const res = axios.get(url, {
              headers: {
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                $('#input_product_id').select2();
                $('#input_service_id').select2();
              
                for(var i=0;i<resp.data.length;i++){
                    var product = {
                          "id"        : resp.data[i]["id"],
                          "abbr"      : resp.data[i]["abbr"],
                          "remark"      : resp.data[i]["remark"],
                          "uom"      : resp.data[i]["uom"],
                          "price"     : resp.data[i]["price"],
                          "type"     : resp.data[i]["type"],
                          "executed_at"     : resp.data[i]["executed_at"],
                          "vat_total"     : resp.data[i]["vat_total"]
                    }

                    productList.push(product);
                }

                for (var i = 0; i < productList.length; i++){
                  var obj = productList[i];
                  var newOption = new Option(obj["remark"], obj["id"], false, false);
                  if((obj["type"]=="Services")||(obj["type"]=="Extra")){
                    $('#input_service_id').append(newOption).trigger('change');  
                  }else{
                    $('#input_product_id').append(newOption).trigger('change');  
                  }
                }

              $('#input_product_id').on('change.select2', function(e){
                $.each(productList, function(i, v) {
                    if (v.id == $('#input_product_id').find(':selected').val()) {
                        $('#input_product_uom').val(v.uom);
                        $('#input_product_price').val(v.price);
                        $('#input_product_qty').val(1);
                        $('#input_product_disc').val(0);
                        $('#input_product_total').val(v.price);
                        $('#input_product_vat_total').val(v.vat_total);
                        return;
                    }
                });
              });

              $('#input_product_price').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val())-$('#input_product_disc').val());
              });

              $('#input_product_qty').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val())-$('#input_product_disc').val());
              });

              $('#input_product_disc').on('input', function(){
                $('#input_product_total').val(($('#input_product_price').val()*$('#input_product_qty').val())-$('#input_product_disc').val());
              });

              $('#input_product_submit').on('click', function(){
                if($('#input_product_id').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please choose product',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_qty').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input qty',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_price').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input price',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_disc').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input disc',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_product_total').val()<0){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input disc less than total',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else{
                  addProduct(
                    $('#input_product_id').val(),
                    $('#input_product_id option:selected').text(), 
                    $('#input_product_price').val(), 
                    $('#input_product_disc').val(), 
                    $('#input_product_qty').val(),
                    $('#input_product_uom').val(),
                    $('#input_product_vat_total').val(),
                    $('#input_product_total').val(),"Good"
                  )
                }
              });

              // Service
              $('#input_service_id').on('change.select2', function(e){
                $.each(productList, function(i, v) {
                    if (v.id == $('#input_service_id').find(':selected').val()) {
                        $('#input_service_uom').val(v.uom);
                        $('#input_service_price').val(v.price);
                        $('#input_service_qty').val(1);
                        $('#input_service_disc').val(0);
                        $('#input_service_total').val(v.price);
                        $('#input_service_vat_total').val(v.vat_total);
                        return;
                    }
                });
              });

              $('#input_service_price').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_qty').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_disc').on('input', function(){
                $('#input_service_total').val(($('#input_service_price').val()*$('#input_service_qty').val())-$('#input_service_disc').val());
              });

              $('#input_service_submit').on('click', function(){
                if($('#input_service_id').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please choose product',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_service_qty').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input qty',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_service_price').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input price',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_service_disc').val()==''){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input disc',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else if($('#input_service_total').val()<0){
                  Swal.fire(
                    {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Please input disc less than total',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                    }
                  );
                }else{
                  addProduct(
                    $('#input_service_id').val(),
                    $('#input_service_id option:selected').text(), 
                    $('#input_service_price').val(), 
                    $('#input_service_disc').val(), 
                    $('#input_service_qty').val(),
                    $('#input_service_uom').val(),
                    $('#input_service_vat_total').val(),
                    $('#input_service_total').val(),
                    "Services"
                  )
                }
              });
              

          });



          $("#apply-voucher-btn").on('click',function(){
              if($("#input-apply-voucher").val()==""){
                  Swal.fire(
                  {
                      position: 'top-end',
                      icon: 'warning',
                      text: 'Silahkan inputkan nomor voucher dahulu',
                      showConfirmButton: false,
                      imageHeight: 30, 
                      imageWidth: 30,   
                      timer: 1500
                  });
              }else{
                var url = "{{ route('orders.checkvoucher') }}";
                const res = axios.get(url,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    params : {
                        voucher_code : $("#input-apply-voucher").val()
                    }
                  }
                ).then(resp => {
                  if(orderList.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Masukkan dahulu sku yang dipesan pelanggan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });
                    $("#input-apply-voucher").val("");

                  }else if(resp.data.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Nomor voucher '+$("#input-apply-voucher").val()+' tidak ditemukan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });

                  }else{
                    table.clear().draw(false);
                    table_product.clear().draw(false);
                    order_total = 0;
                    disc_total = 0;
                    _vat_total = 0;
                    sub_total = 0;

                    counterVoucherHit = 0;

                    orderList.sort(function(a, b) {
                        return parseFloat(a.entry_time) - parseFloat(b.entry_time);
                    });


                    counterno = 0;
                    counterno_service = 0;

                    for (var i = 0; i < orderList.length; i++){
                      for (var j = 0; j < resp.data.length;j++){
                        if((resp.data[j].product_id == orderList[i]["id"] || resp.data[j].is_allitem == 1 ) && counterVoucherHit==0 && ((parseFloat(orderList[i]["qty"]))>= (parseFloat(resp.data[j].moq))) && (((parseFloat(orderList[i]["price"])) * (parseFloat(orderList[i]["qty"]))) >= (parseFloat(resp.data[j].value)))){
                          orderList[i]["discount"] = ( ((parseFloat(resp.data[j].value_idx)) * (parseFloat(orderList[i]["price"])) * (parseFloat(orderList[i]["qty"])) )/100 ) + (parseFloat(resp.data[j].value));
                          orderList[i]["total"] = ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
                          $("#remark").val($("#remark").val()+"["+resp.data[j].remark+"]");
                          counterVoucherHit++;
                          voucherNo = $("#input-apply-voucher").val();
                          voucherNoPID = resp.data[j].product_id;
                          break;
                        }
                      }


                      var obj = orderList[i];
                      var value = obj["abbr"];
                      if(obj["type_id"]=="Services"){
                        counterno_service  = counterno_service + 1;
                        table.row.add( {
                                "seq" : counterno_service,
                                "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }else{
                          counterno = counterno + 1;
                          table_product.row.add( {
                              "seq" : counterno,
                              "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"],
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }


                        disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                        if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').css('color', 'black');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("Rp. 0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }

                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());


                    if(counterVoucherHit>0){
                      _is_use_voucher = "1";
                      Swal.fire(
                      {
                          position: 'top-end',
                          icon: 'success',
                          text: 'Nomor voucher '+$("#input-apply-voucher").val()+' berhasil dipakai',
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                      });
                    }else{
                      Swal.fire(
                      {
                          position: 'top-end',
                          icon: 'warning',
                          text: 'Nomor voucher '+$("#input-apply-voucher").val()+' tidak ada yang cocok dengan SKU yang dipesan',
                          showConfirmButton: false,
                          imageHeight: 30, 
                          imageWidth: 30,   
                          timer: 1500
                      });
                    }
                  }

                });

              }
            });

            $("#apply-promo-btn").on('click',function(){
              console.log($('#customer_id').val());
              if($('#customer_id').val().length<=0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Silahkan pilih dulu pelanggan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });

              }else{

                var url = "{{ route('promo.check') }}";
                const res = axios.get(url,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    params : {
                        invoice_no : $("#promo_inv").val(),
                        customer_id : $("#customer_id").val(),
                    }
                  }
                ).then(resp => {
                  if(orderList.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Masukkan dahulu sku yang dipesan pelanggan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });
                  }else if(resp.data.length==0){
                    Swal.fire(
                    {
                        position: 'top-end',
                        icon: 'warning',
                        text: 'Promo tidak ditemukan',
                        showConfirmButton: false,
                        imageHeight: 30, 
                        imageWidth: 30,   
                        timer: 1500
                    });

                  }else{
                    table.clear().draw(false);
                    table_product.clear().draw(false);
                    order_total = 0;
                    disc_total = 0;
                    _vat_total = 0;
                    sub_total = 0;


                    orderList.sort(function(a, b) {
                        return parseFloat(a.entry_time) - parseFloat(b.entry_time);
                    });


                    counterno = 0;
                    counterno_service = 0;
                    var today = new Date();
                    var weekday = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
                    var minutes = (today.getMinutes() < 10 ? '0' : '') + today.getMinutes()
                    var time = [today.getHours(),minutes].join('');
                    var PromoHit = 0;
                    var PromoSelected = "";

                    for (var i = 0; i < orderList.length; i++){
                      for (var j = 0; j < resp.data.length;j++){
                        var isvalidday = 0;
                        var isvalidtime = 0;
                        var isvalidcust = 0;
                        
                        
                        if(resp.data[j].active_day == "all"){
                          isvalidday = 1;
                        }else if(resp.data[j].active_day == "weekday"){
                          if(today.getDay()>0 && today.getDay()<=5){
                              isvalidday = 1;
                          }
                        }else if(resp.data[j].active_day == "weekend"){
                          if(today.getDay()==0 || today.getDay()>=6){
                              isvalidday = 1;
                          }
                        }

                        if(resp.data[j].active_time == "all"){
                          isvalidtime = 1;
                        }else if(resp.data[j].active_time == "officetime"){
                          if(parseInt(time)>800 && parseInt(time)<=1700){
                            isvalidtime = 1;
                          }
                        }else if(resp.data[j].active_time == "noon"){
                          if(parseInt(time)>1000 && parseInt(time)<=1700){
                            isvalidtime = 1;
                          }
                        }else if(resp.data[j].active_time == "happyhour"){
                          if(parseInt(time)>900 && parseInt(time)<=1600){
                            isvalidtime = 1;
                          }
                        }else if(resp.data[j].active_time == "night"){
                          if(parseInt(time)>1700 && parseInt(time)<=2359){
                            isvalidtime = 1;
                          }
                        }

                        if(resp.data[j].type_customer == "all"){
                          isvalidcust = 1;
                        }else if(resp.data[j].type_customer == $('#customer_type').find(':selected').val()){
                          isvalidcust = 1;
                        }

                        console.log(time);

                        console.log($('#customer_type').find(':selected').val()+" - "+ isvalidtime+"-"+isvalidday+"-"+(((parseFloat(orderList[i]["price"])) * (parseFloat(orderList[i]["qty"]))) >= (parseFloat(resp.data[j].value))));

                        if(resp.data[j].product_id == orderList[i]["id"] && isvalidday==1 && isvalidtime==1 && isvalidcust==1 && parseFloat(orderList[i]["discount"])==0 && ((parseFloat(orderList[i]["qty"]))>= (parseFloat(resp.data[j].moq))) && (((parseFloat(orderList[i]["price"])) * (parseFloat(orderList[i]["qty"]))) >= (parseFloat(resp.data[j].value)))){
                          orderList[i]["discount"] = ( ((parseFloat(resp.data[j].value_idx)) * (parseFloat(orderList[i]["price"])) * (parseFloat(orderList[i]["qty"])) )/100 ) + (parseFloat(resp.data[j].value));
                          orderList[i]["total"] = ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));
                          $("#remark").val($("#remark").val()+"["+resp.data[j].remarks+"]");
                          PromoSelected = resp.data[j].remarks;
                          PromoHit = 1;
                          break;
                        }
                      }

                      if(PromoHit == 0){
                        Swal.fire(
                        {
                            position: 'top-end',
                            icon: 'warning',
                            text: 'Tidak ada promo yang cocok dengan pesanan',
                            showConfirmButton: false,
                            imageHeight: 30, 
                            imageWidth: 30,   
                            timer: 1500
                        });

                      }else{
                        Swal.fire(
                        {
                            position: 'top-end',
                            icon: 'warning',
                            text: 'Promo '+PromoSelected+' telah diterapkan di faktur ini',
                            showConfirmButton: false,
                            imageHeight: 30, 
                            imageWidth: 30,   
                            timer: 1500
                        });
                      }


                      var obj = orderList[i];
                      var value = obj["abbr"];
                      if(obj["type_id"]=="Services"){
                        counterno_service  = counterno_service + 1;
                        table.row.add( {
                                "seq" : counterno_service,
                                "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"] + " (" + obj["executed_at"] + ")",
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }else{
                          counterno = counterno + 1;
                          table_product.row.add( {
                              "seq" : counterno,
                              "id"        : obj["id"],
                                "abbr"      : obj["abbr"],
                                "uom"       : obj["uom"],
                                "price"     : obj["price"],
                                "discount"  : obj["discount"],
                                "qty"       : obj["qty"],
                                "total"     : obj["total"],
                                "assignedto": obj["assignedto"],
                                "referralby" : obj["referralby"],
                                "action"    : "",
                          }).draw(false);
                        }


                        disc_total = disc_total + (parseFloat(orderList[i]["discount"]));
                        sub_total = sub_total + (((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])));
                        _vat_total = _vat_total + ((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100));
                        order_total = order_total + ((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"])+((((parseInt(orderList[i]["qty"]))*parseFloat(orderList[i]["price"]))-(parseFloat(orderList[i]["discount"])))*(parseFloat(orderList[i]["vat_total"])/100)))-(parseFloat(orderList[i]["discount"]));

                        if(($('#payment_nominal').val())>order_total){
                          $('#order_charge').css('color', 'black');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }else{
                          $('#order_charge').text("Rp. 0");
                          $('#order_charge').css('color', 'red');
                          $('#order_charge').text(currency((($('#payment_nominal').val())-order_total), { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                        }

                    }

                    $('#result-total').text(currency(order_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#vat-total').text(currency(_vat_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());
                    $('#sub-total').text(currency(sub_total, { separator: ".", decimal: ",", symbol: "Rp. ", precision: 0 }).format());

                  }

                });


              }
              
            });

 
    </script>
@endpush
