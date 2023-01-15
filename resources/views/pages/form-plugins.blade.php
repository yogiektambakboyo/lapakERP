@extends('layouts.default')

@section('title', 'Form Plugins')

@push('css')
	<link href="/assets/plugins/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" />
	<link href="/assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet" />
	<link href="/assets/plugins/bootstrap-datepicker/dist/css/bootstrap-datepicker.css" rel="stylesheet" />
	<link href="/assets/plugins/bootstrap-timepicker/css/bootstrap-timepicker.min.css" rel="stylesheet" />
	<link href="/assets/plugins/ion-rangeslider/css/ion.rangeSlider.min.css" rel="stylesheet" />
	<link href="/assets/plugins/tag-it/css/jquery.tagit.css" rel="stylesheet" />
	<link href="/assets/plugins/spectrum-colorpicker2/dist/spectrum.min.css" rel="stylesheet" />
	<link href="/assets/plugins/select-picker/dist/picker.min.css" rel="stylesheet" />
@endpush

@push('scripts')
	<script src="/assets/plugins/moment/min/moment.min.js"></script>
	<script src="/assets/plugins/bootstrap-daterangepicker/daterangepicker.js"></script>
	<script src="/assets/plugins/select2/dist/js/select2.min.js"></script>
	<script src="/assets/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.js"></script>
	<script src="/assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
	<script src="/assets/plugins/ion-rangeslider/js/ion.rangeSlider.min.js"></script>
	<script src="/assets/plugins/jquery.maskedinput/src/jquery.maskedinput.js"></script>
	<script src="/assets/plugins/jquery-migrate/dist/jquery-migrate.min.js"></script>
	<script src="/assets/plugins/tag-it/js/tag-it.min.js"></script>
	<script src="/assets/plugins/clipboard/dist/clipboard.min.js"></script>
	<script src="/assets/plugins/spectrum-colorpicker2/dist/spectrum.min.js"></script>
	<script src="/assets/plugins/select-picker/dist/picker.min.js"></script>
	<script src="/assets/js/demo/form-plugins.demo.js"></script>
	<script src="/assets/plugins/@highlightjs/cdn-assets/highlight.min.js"></script>
	<script src="/assets/js/demo/render.highlight.js"></script>
@endpush

@section('content')
	<!-- BEGIN breadcrumb -->
	<ol class="breadcrumb float-xl-end">
		<li class="breadcrumb-item"><a href="javascript:;">Home</a></li>
		<li class="breadcrumb-item"><a href="javascript:;">Form Stuff</a></li>
		<li class="breadcrumb-item active">Form Plugins</li>
	</ol>
	<!-- END breadcrumb -->
	<!-- BEGIN page-header -->
	<h1 class="page-header">Form Plugins <small>header small text goes here...</small></h1>
	<!-- END page-header -->
	<!-- BEGIN row -->
	<div class="row">
		<!-- BEGIN col-6 -->
		<div class="col-xl-6">
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-1">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">Date Range Picker</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default Date Ranges</label>
							<div class="col-lg-8">
								<div class="input-group" id="default-daterange">
									<input type="text" name="default-daterange" class="form-control" value="" placeholder="click to select the date range" />
									<div class="input-group-text"><i class="fa fa-calendar"></i></div>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Advance Date Ranges</label>
							<div class="col-lg-8">
								<div id="advance-daterange" class="btn btn-default d-flex text-start align-items-center">
									<span class="flex-1"></span>
									<i class="fa fa-caret-down"></i>
								</div>
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" /&gt;
&lt;script src="/assets/plugins/moment/min/moment.min.js"&gt;&lt;/script&gt;
&lt;script src="/assets/plugins/bootstrap-daterangepicker/daterangepicker.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;div class="input-group" id="default-daterange"&gt;
  &lt;input type="text" name="default-daterange" class="form-control" value="" placeholder="click to select the date range" /&gt;
  &lt;div class="input-group-text"&gt;&lt;i class="fa fa-calendar"&gt;&lt;/i&gt;&lt;/div&gt;
&lt;/div&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#default-daterange").daterangepicker({
    opens: "right",
    format: "MM/DD/YYYY",
    separator: " to ",
    startDate: moment().subtract("days", 29),
    endDate: moment(),
    minDate: "01/01/2021",
    maxDate: "12/31/2021",
  }, function (start, end) {
    $("#default-daterange input").val(start.format("MMMM D, YYYY") + " - " + end.format("MMMM D, YYYY"));
  });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-2">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">Select2</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Basic Select2</label>
							<div class="col-lg-8">
								<select class="default-select2 form-control">
									<optgroup label="Alaskan/Hawaiian Time Zone">
										<option value="AK">Alaska</option>
										<option value="HI">Hawaii</option>
									</optgroup>
									<optgroup label="Pacific Time Zone">
										<option value="CA">California</option>
										<option value="NV">Nevada</option>
										<option value="OR">Oregon</option>
										<option value="WA">Washington</option>
									</optgroup>
									<optgroup label="Mountain Time Zone">
										<option value="AZ">Arizona</option>
										<option value="CO">Colorado</option>
										<option value="ID">Idaho</option>
										<option value="MT">Montana</option>
										<option value="NE">Nebraska</option>
										<option value="NM">New Mexico</option>
										<option value="ND">North Dakota</option>
										<option value="UT">Utah</option>
										<option value="WY">Wyoming</option>
									</optgroup>
									<optgroup label="Central Time Zone">
										<option value="AL">Alabama</option>
										<option value="AR">Arkansas</option>
										<option value="IL">Illinois</option>
										<option value="IA">Iowa</option>
										<option value="KS">Kansas</option>
										<option value="KY">Kentucky</option>
										<option value="LA">Louisiana</option>
										<option value="MN">Minnesota</option>
										<option value="MS">Mississippi</option>
										<option value="MO">Missouri</option>
										<option value="OK">Oklahoma</option>
										<option value="SD">South Dakota</option>
										<option value="TX">Texas</option>
										<option value="TN">Tennessee</option>
										<option value="WI">Wisconsin</option>
									</optgroup>
									<optgroup label="Eastern Time Zone">
										<option value="CT">Connecticut</option>
										<option value="DE">Delaware</option>
										<option value="FL">Florida</option>
										<option value="GA">Georgia</option>
										<option value="IN">Indiana</option>
										<option value="ME">Maine</option>
										<option value="MD">Maryland</option>
										<option value="MA">Massachusetts</option>
										<option value="MI">Michigan</option>
										<option value="NH">New Hampshire</option>
										<option value="NJ">New Jersey</option>
										<option value="NY">New York</option>
										<option value="NC">North Carolina</option>
										<option value="OH">Ohio</option>
										<option value="PA">Pennsylvania</option>
										<option value="RI">Rhode Island</option>
										<option value="SC">South Carolina</option>
										<option value="VT">Vermont</option>
										<option value="VA">Virginia</option>
										<option value="WV">West Virginia</option>
									</optgroup>
								</select>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Multiple Selection</label>
							<div class="col-lg-8">
								<select class="multiple-select2 form-control" multiple>
									<optgroup label="Alaskan/Hawaiian Time Zone">
										<option value="AK">Alaska</option>
										<option value="HI">Hawaii</option>
									</optgroup>
									<optgroup label="Pacific Time Zone">
										<option value="CA">California</option>
										<option value="NV">Nevada</option>
										<option value="OR">Oregon</option>
										<option value="WA">Washington</option>
									</optgroup>
									<optgroup label="Mountain Time Zone">
										<option value="AZ">Arizona</option>
										<option value="CO">Colorado</option>
										<option value="ID">Idaho</option>
										<option value="MT">Montana</option>
										<option value="NE">Nebraska</option>
										<option value="NM">New Mexico</option>
										<option value="ND">North Dakota</option>
										<option value="UT">Utah</option>
										<option value="WY">Wyoming</option>
									</optgroup>
									<optgroup label="Central Time Zone">
										<option value="AL">Alabama</option>
										<option value="AR">Arkansas</option>
										<option value="IL">Illinois</option>
										<option value="IA">Iowa</option>
										<option value="KS">Kansas</option>
										<option value="KY">Kentucky</option>
										<option value="LA">Louisiana</option>
										<option value="MN">Minnesota</option>
										<option value="MS">Mississippi</option>
										<option value="MO">Missouri</option>
										<option value="OK">Oklahoma</option>
										<option value="SD">South Dakota</option>
										<option value="TX">Texas</option>
										<option value="TN">Tennessee</option>
										<option value="WI">Wisconsin</option>
									</optgroup>
									<optgroup label="Eastern Time Zone">
										<option value="CT">Connecticut</option>
										<option value="DE">Delaware</option>
										<option value="FL">Florida</option>
										<option value="GA">Georgia</option>
										<option value="IN">Indiana</option>
										<option value="ME">Maine</option>
										<option value="MD">Maryland</option>
										<option value="MA">Massachusetts</option>
										<option value="MI">Michigan</option>
										<option value="NH">New Hampshire</option>
										<option value="NJ">New Jersey</option>
										<option value="NY">New York</option>
										<option value="NC">North Carolina</option>
										<option value="OH">Ohio</option>
										<option value="PA">Pennsylvania</option>
										<option value="RI">Rhode Island</option>
										<option value="SC">South Carolina</option>
										<option value="VT">Vermont</option>
										<option value="VA">Virginia</option>
										<option value="WV">West Virginia</option>
									</optgroup>
								</select>
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet" /&gt;
&lt;script src="/assets/plugins/select2/dist/js/select2.min.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;select class="default-select2 form-control"&gt;
  &lt;optgroup label="Alaskan/Hawaiian Time Zone"&gt;
    &lt;option value="AK"&gt;Alaska&lt;/option&gt;
    &lt;option value="HI"&gt;Hawaii&lt;/option&gt;
  &lt;/optgroup&gt;
&lt;/select&gt;

&lt;!-- multiple selection --&gt;
&lt;select class="multiple-select2 form-control" multiple&gt;
  ...
&lt;/select&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $(".default-select2").select2();
  $(".multiple-select2").select2({ placeholder: "Select a state" });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-3">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">Datepicker</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default Datepicker</label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="datepicker-default" placeholder="Select Date" value="04/1/2021" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Inline Datepicker</label>
							<div class="col-lg-8">
								<div id="datepicker-inline">
									<div></div>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Auto Close Datepicker</label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="datepicker-autoClose" placeholder="Auto Close Datepicker" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Disabled Past @lang('general.lbl_dated')   </label>
							<div class="col-lg-8">
								<div class="input-group date" id="datepicker-disabled-past" data-date-format="dd-mm-yyyy" data-date-start-date="Date.default">
									<input type="text" class="form-control" placeholder="Select Date" />
									<span class="input-group-text input-group-addon"><i class="fa fa-calendar"></i></span>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Range Datepicker</label>
							<div class="col-lg-8">
								<div class="input-group input-daterange">
									<input type="text" class="form-control" name="start" placeholder="Date Start" />
									<span class="input-group-text input-group-addon">to</span>
									<input type="text" class="form-control" name="end" placeholder="Date End" />
								</div>
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/bootstrap-datepicker/dist/css/bootstrap-datepicker.css" rel="stylesheet" /&gt;
&lt;script src="/assets/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;input type="text" class="form-control" id="datepicker-autoClose" /&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#datepicker-autoClose").datepicker({
    todayHighlight: true,
    autoclose: true
  });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-4">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">Select Picker</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default</label>
							<div class="col-lg-8">
								<select class="form-control" id="ex-basic">
									<option>Mustard</option>
									<option>Ketchup</option>
									<option>Relish</option>
								</select>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Multiple SelectBox</label>
							<div class="col-lg-8">
								<select class="selectpicker form-control" id="ex-multiselect" multiple>
									<optgroup label="Picnic">
										<option>Mustard</option>
										<option>Ketchup</option>
										<option>Relish</option>
									</optgroup>
									<optgroup label="Camping">
										<option>Tent</option>
										<option>Flashlight</option>
										<option>Toilet Paper</option>
									</optgroup>
								</select>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Live Search</label>
							<div class="col-lg-8">
								<select class="selectpicker form-control" id="ex-search" multiple>
									<option value="1">Mustard</option>
									<option value="2">Ketchup</option>
									<option value="3">Relish</option>
									<option value="4">Tent</option>
									<option value="5">Flashlight</option>
									<option value="6">Toilet Paper</option>
								</select>
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/select-picker/dist/picker.min.css" rel="stylesheet" /&gt;
&lt;script src=".。/assets/plugins/select-picker/dist/picker.min.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;select class="selectpicker form-control" id="ex-search" multiple&gt;
  ...
&lt;/select&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $('#ex-search').picker({ search: true });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-5">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">IonRange Slider</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default</label>
							<div class="col-lg-8">
								<input type="text" id="default_rangeSlider" name="default_rangeSlider" value="" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Custom Range</label>
							<div class="col-lg-8">
								<input type="text" id="customRange_rangeSlider" name="customRange_rangeSlider" value="" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Custom @lang('general.lbl_values')</label>
							<div class="col-lg-8">
								<input type="text" id="customValue_rangeSlider" name="customValue_rangeSlider" value="" />
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/ion-rangeslider/css/ion.rangeSlider.min.css" rel="stylesheet" /&gt;
&lt;script src="/assets/plugins/ion-rangeslider/js/ion.rangeSlider.min.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;input type="text" id="default_rangeSlider" name="default_rangeSlider" value="" /&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#default_rangeSlider").ionRangeSlider({
    min: 0,
    max: 5000,
    type: "double",
    prefix: "$",
    maxPostfix: "+",
    prettify: false,
    hasGrid: true,
    skin: "big"          // big | flat
  });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
		</div>
		<!-- END col-6 -->
		<!-- BEGIN col-6 -->
		<div class="col-xl-6">
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-6">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">Colorpicker</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default Colorpicker</label>
							<div class="col-lg-8">
								<input type="text" value="#007aff" class="form-control" id="colorpicker-default" />
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/spectrum-colorpicker2/dist/spectrum.min.css" rel="stylesheet" /&gt;
&lt;script src="/assets/plugins/spectrum-colorpicker2/dist/spectrum.min.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;input type="text" value="#007aff" class="form-control" id="colorpicker-default" /&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#colorpicker-default").spectrum({
    showInput: true
  });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-7">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">Timepicker</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default timepicker</label>
							<div class="col-lg-8">
								<div class="input-group bootstrap-timepicker">
									<input id="timepicker" type="text" class="form-control" />
									<span class="input-group-text input-group-addon"><i class="fa fa-clock"></i></span>
								</div>
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/bootstrap-timepicker/css/bootstrap-timepicker.min.css" rel="stylesheet" /&gt;
&lt;script src="/assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;div class="input-group bootstrap-timepicker"&gt;
  &lt;input id="timepicker" type="text" class="form-control" /&gt;
  &lt;span class="input-group-text input-group-addon"&gt;
    &lt;i class="fa fa-clock"&gt;&lt;/i&gt;
  &lt;/span&gt;
&lt;/div&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#timepicker").timepicker();
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-8">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">jQuery Autocomplete</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Autocomplete</label>
							<div class="col-lg-8">
								<input type="text" name="" id="jquery-autocomplete" class="form-control" placeholder="Try typing 'a' or 'b'." />
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- html --&gt;
&lt;input type="text" class="form-control" id="jquery-autocomplete" /&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#jquery-autocomplete").autocomplete({
    source: ["ActionScript", "AppleScript", "Asp", "BASIC", "C"]
  });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-9">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">Masked Input</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">@lang('general.lbl_dated')   </label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="masked-input-date" placeholder="dd/mm/yyyy" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Phone</label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="masked-input-phone" placeholder="(999) 999-9999" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Tax ID</label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="masked-input-tid" placeholder="99-9999999" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Product Key</label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="masked-input-pkey" placeholder="a*-999-a999" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">SSN</label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="masked-input-ssn" placeholder="999/99/9999" />
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">SSN</label>
							<div class="col-lg-8">
								<input type="text" class="form-control" id="masked-input-pno" placeholder="AAA-9999-A" />
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;script src="/assets/plugins/jquery.maskedinput/src/jquery.maskedinput.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;input type="text" class="form-control" id="masked-input-date" /&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#masked-input-date").mask("99/99/9999");
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-10">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title">jQuery Tag-It</h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default Tags Input with Autocomplete</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-default">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
								<p>Try to enter "c++, java, php" </p>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Inverse Theme</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-inverse" class="inverse">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">White Theme</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-white" class="white">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Primary Theme</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-primary" class="primary">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Info Theme</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-info" class="info">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Success Theme</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-success" class="success">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Warning Theme</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-warning" class="warning">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Danger Theme</label>
							<div class="col-lg-8">
								<ul id="jquery-tagIt-danger" class="danger">
									<li>Tag1</li>
									<li>Tag2</li>
								</ul>
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;link href="/assets/plugins/tag-it/css/jquery.tagit.css" rel="stylesheet" /&gt;
&lt;script src="/assets/plugins/jquery-migrate/dist/jquery-migrate.min.js"&gt;&lt;/script&gt;
&lt;script src="/assets/plugins/tag-it/js/tag-it.min.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;ul id="jquery-tagIt-default"&gt;
  &lt;li&gt;Tag1&lt;/li&gt;
  &lt;li&gt;Tag2&lt;/li&gt;
&lt;/ul&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  $("#jquery-tagIt-default").tagit({
    availableTags: ["c++", "java", "php", "javascript", "ruby", "python", "c"]
  });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
			<!-- BEGIN panel -->
			<div class="panel panel-inverse" data-sortable-id="form-plugins-11">
				<!-- BEGIN panel-heading -->
				<div class="panel-heading">
					<h4 class="panel-title"> Clipboard.js <span class="badge bg-success ms-2">NEW</span></h4>
					<div class="panel-heading-btn">
						<a href="javascript:;" class="btn btn-xs btn-icon btn-default" data-toggle="panel-expand"><i class="fa fa-expand"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-success" data-toggle="panel-reload"><i class="fa fa-redo"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-warning" data-toggle="panel-collapse"><i class="fa fa-minus"></i></a>
						<a href="javascript:;" class="btn btn-xs btn-icon btn-danger" data-toggle="panel-remove"><i class="fa fa-times"></i></a>
					</div>
				</div>
				<!-- END panel-heading -->
				<!-- BEGIN panel-body -->
				<div class="panel-body p-0">
					<form class="form-horizontal form-bordered">
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Default</label>
							<div class="col-lg-8">
								<div class="input-group">
									<input id="clipboard-default" type="text" class="form-control" value="https://github.com/zenorocha/clipboard.js.git" />
									<button class="btn btn-dark" type="button" data-toggle="clipboard" data-clipboard-target="#clipboard-default"><i class="fa fa-clipboard"></i></button>
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">Cut to copy</label>
							<div class="col-lg-8">
								<textarea class="form-control mb-10px" id="clipboard-textarea" rows="7">Mussum ipsum cacilds...</textarea>
								<button class="btn btn-dark btn-sm" type="button" data-toggle="clipboard" data-clipboard-target="#clipboard-textarea" data-clipboard-action="cut">Cut to clipboard</button>
							</div>
						</div>
						<div class="form-group row">
							<label class="form-label col-form-label col-lg-4">without Form</label>
							<div class="col-lg-8">
								<button class="btn btn-dark btn-sm" type="button" data-toggle="clipboard" data-clipboard-text="Just because you can doesn't mean you should — clipboard.js">Click to copy</button>
							</div>
						</div>
					</form>
				</div>
				<!-- END panel-body -->
				<!-- BEGIN hljs-wrapper -->
				<div class="hljs-wrapper">
					<pre><code class="html">&lt;!-- required files --&gt;
&lt;script src="/assets/plugins/clipboard/dist/clipboard.min.js"&gt;&lt;/script&gt;

&lt;!-- html --&gt;
&lt;div class="input-group"&gt;
  &lt;input id="clipboard-default" type="text" class="form-control" value="https://github.com/zenorocha/clipboard.js.git" /&gt;
  &lt;button class="btn btn-dark" type="button" data-toggle="clipboard" data-clipboard-target="#clipboard-default"&gt;&lt;i class="fa fa-clipboard"&gt;&lt;/i&gt;&lt;/button&gt;
&lt;/div&gt;

&lt;!-- script --&gt;
&lt;script&gt;
  var clipboard = new ClipboardJS("[data-toggle='clipboard']");
  
  clipboard.on("success", function(e) {
    $(e.trigger).tooltip({
      title: "Copied",
      placement: "top"
    });
    $(e.trigger).tooltip("show");
    setTimeout(function() {
      $(e.trigger).tooltip("dispose");
    }, 500);
  });
&lt;/script&gt;</code></pre>
				</div>
				<!-- END hljs-wrapper -->
			</div>
			<!-- END panel -->
		</div>
		<!-- END col-6 -->
	</div>
	<!-- END row -->
@endsection